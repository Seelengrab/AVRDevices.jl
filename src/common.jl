module Common

export Register, volatile_load, volatile_store!, keep, delay_ms, delay_us, delay

CPU_FREQUENCY_HZ() = 16_000_000 # this value can be set to a new one by redefining this function

struct Register{T <: Base.BitInteger}
    ptr::Ptr{T}
    Register{T}(x::Ptr{T}) where T = new{T}(x)
    Register{T}(x::Base.BitInteger) where T = new{T}(Ptr{T}(x % UInt)) # Ptr only takes Union{Int, UInt, Ptr}...
end

# gracefullly stolen from VectorizationBase.jl
const LLVM_TYPES = IdDict{Type{<:Union{Bool,Base.HWReal,Float16}},String}(
  Float16 => "half",
  Float32 => "float",
  Float64 => "double",
  # Bit => "i1", # I don't think we have these here?
  Bool => "i8",
  Int8 => "i8",
  UInt8 => "i8",
  Int16 => "i16",
  UInt16 => "i16",
  Int32 => "i32",
  UInt32 => "i32",
  Int64 => "i64",
  UInt64 => "i64",
  # Int128 => "i128", # let's not worry about these
  # UInt128 => "i128",
  # UInt256 => "i256",
  # UInt512 => "i512",
  # UInt1024 => "i1024",
)

"""
    volatile_store!(r::Register{T}, v::T) -> Nothing
    volatile_store!(p::Ptr{T}, v::T) -> Nothing
    
Stores a value `T` in the register/pointer `r`/`p`. Unlike `unsafe_store!`, is not elided by LLVM.
"""
function volatile_store! end

"""
  volatile_load(r::Register{T}) -> T
  volatile_load(p::Ptr{T}) -> T

Loads a value of type `T` from the register/ptr `r`/`p`. Unlike `unsafe_load`, is not elided by LLVM.
"""
function volatile_load end


"""
    keep(x)
    
Forces LLVM to keep a value alive, by pretending to clobber its memory. The memory is never actually accessed,
which makes this a no-op in the final assembly.
"""
function keep end

volatile_store!(x::Register{T}, v::T) where T = volatile_store!(x.ptr, v)
volatile_load(x::Register) = volatile_load(x.ptr)

for T in keys(LLVM_TYPES)
    ptrs = LLVM_TYPES[T]
    store = """
          %ptr = inttoptr i64 %0 to $ptrs*
          store volatile $ptrs %1, $ptrs* %ptr, align 1
          ret void
          """
    vs = :(function volatile_store!(x::Ptr{$T}, v::$T)
        return Base.llvmcall(
            $store,
            Cvoid,
            Tuple{Ptr{$T},$T},
            x.ptr,
            v
        )
    end)
    load = """
           %ptr = inttoptr i64 %0 to $ptrs*
           %val = load volatile $ptrs, ptr %ptr, align 1
           ret $ptrs %val
           """
    ld = :(function volatile_load(x::Ptr{$T})
        return Base.llvmcall(
            $load,
            $T,
            Tuple{Ptr{$T}},
            x
        )
    end)
    @eval $vs
    @eval $ld
    
    str = """
          call void asm sideeffect "", "X,~{memory}"($ptrs %0)
          ret void
          """
    k = :(function keep(x::$T)
        return Base.llvmcall(
            $str,
            Cvoid,
            Tuple{$T},
            x
    )
    end)
    @eval $k
end

Base.getindex(r::Register) = volatile_load(r)
Base.setindex!(r::Register{T}, v::T) where T = volatile_store!(r, v)


# delay functionality transpiled from
# https://github.com/avr-rust/delay/blob/master/src/lib.rs
delay_ms(ms::Int) = delay_us(ms * 1000)

function delay_us(us::Int)
    us_in_loop = (CPU_FREQUENCY_HZ() ÷ 1000000 ÷ 4)
    loops = us * us_in_loop
    delay(loops)
end

function delay(count::Int)
    outer_count = count ÷ 65536
    rest_count = ((count % 65536) + 1) % UInt16
    for _ in 0:outer_count
        z = zero(UInt16)
        while true
            keep(z)
            z -= one(z)
            iszero(z) && break
        end
    end
    while true
        keep(rest_count)
        rest_count -= one(rest_count)
        iszero(rest_count) && break
    end
    # Base.llvmcall(
    #     """
    #     call void asm "1:
    #                      sbiw \$0, 1
    #                      brne 1b", "=X,~{memory}"(i16 %0)
    #     ret void
    #     """,
    #     Cvoid,
    #     Tuple{UInt16},
    #     rest_count
    # )
end

end # module
