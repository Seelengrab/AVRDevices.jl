module Common

export Register, RegisterBits, Pin, volatile_load, volatile_store!, keep, delay_ms, delay_us, delay, CPU_FREQUENCY_HZ

CPU_FREQUENCY_HZ() = 16_000_000 # this value can be set to a new one by redefining this function

struct Register{Reg, T <: Base.BitInteger}
    ptr::Ptr{T}
    Register{Reg, T}(x::Ptr{T}) where {Reg, T} = new{Reg, T}(x)
    Register{Reg, T}(x::Base.BitInteger) where {Reg, T} = new{Reg, T}(Ptr{T}(x % UInt)) # Ptr only takes Union{Int, UInt, Ptr}...
end

struct RegisterBits{Reg, T}
    bits::T
end

struct Pin{RT, Reg, Bit, Mask}
    function Pin{Reg, bit}() where {Reg, bit}
        T = typeof(Reg)
        mask = eltype(Reg)(1 << (bit - 1))
        new{T, Reg, bit, mask}()
    end
end

Base.eltype(::Type{R}) where {Reg, T, R <: Register{Reg, T}} = T

Base.getindex(r::Register) = volatile_load(r)
Base.setindex!(r::Register{Reg, T}, data::T) where {Reg, T} = volatile_store!(r, data)
Base.setindex!(r::Register{Reg, T}, rb::RegisterBits{Reg, T}) where {Reg, T} = volatile_store!(r, rb.bits)
Base.setindex!(r::RT, _::Pin{RT, Reg, b, m}) where {RT, Reg, b, m} = volatile_store!(r, m)

Base.:(|)(rba::RegisterBits{Reg, T}, rbb::RegisterBits{Reg, T}) where {Reg, T} = RegisterBits{Reg, T}(rba.bits | rbb.bits)
Base.:(&)(rba::RegisterBits{Reg, T}, rbb::RegisterBits{Reg, T}) where {Reg, T} = RegisterBits{Reg, T}(rba.bits & rbb.bits)
Base.xor(rba::RegisterBits{Reg, T}, rbb::RegisterBits{Reg, T}) where {Reg, T} = RegisterBits{Reg, T}(xor(rba.bits, rbb.bits))
Base.:(~)(rb::RegisterBits{Reg, T}) where {Reg, T} = RegisterBits{Reg, T}(~rb.bits)

Base.:(|)(::Pin{RT, Reg, ba, ma}, ::Pin{RT, Reg, bb, mb}) where {R, T, RT <: Register{R, T}, Reg, ba, bb, ma, mb} = RegisterBits{R, T}(ma | mb)
Base.:(&)(::Pin{RT, Reg, ba, ma}, ::Pin{RT, Reg, bb, mb}) where {R, T, RT <: Register{R, T}, Reg, ba, bb, ma, mb} = RegisterBits{R, T}(ma & mb)
Base.:(~)(::Pin{RT, Reg, ba, ma}) where {R, T, RT<:Register{R,T}, Reg, ba, ma} = RegisterBits{R, T}(~ma)

Base.:(|)(p::Pin, rb::RegisterBits) = rb | p
Base.:(|)(rb::RegisterBits{R, T}, _::Pin{RT, Reg, b, m}) where {R, T, RT<:Register{R,T}, Reg, b, m} = RegisterBits{R, T}(rb.bits | m)
Base.:(&)(p::Pin, rb::RegisterBits) = rb & p
Base.:(&)(rb::RegisterBits{R, T}, _::Pin{RT, Reg, b, m}) where {R, T, RT<:Register{R,T}, Reg, b, m} = RegisterBits{R, T}(rb.bits & m)

Base.getindex(_::Pin{RT, Reg, b, m}) where {RT, Reg, b, m} = (volatile_load(Reg) & m) != zero(m)
function Base.setindex!(_::Pin{Register{R, T}, Reg, b, m}, val::Bool) where {R, T, Reg, b, m}
    cur = volatile_load(Reg)

    res = ifelse(val, cur | T(1 << b), cur & ~T(1 << b))

    return volatile_store!(Reg, res)
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
  UInt64 => "i64"
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

volatile_store!(x::Register{Reg, T}, v::T) where {Reg, T} = volatile_store!(x.ptr, v)
volatile_load(x::Register) = volatile_load(x.ptr)

for T in keys(LLVM_TYPES)
    ptrs = LLVM_TYPES[T]
    store = """
          %ptr = inttoptr i64 %0 to $ptrs*
          store volatile $ptrs %1, $ptrs* %ptr, align 1
          ret void
          """
    vs = :(function volatile_store!(x::Ptr{$T}, v::$T)
        @inline
        return Base.llvmcall(
            $store,
            Cvoid,
            Tuple{Ptr{$T},$T},
            x,
            v
        )
    end)
    load = """
           %ptr = inttoptr i64 %0 to $ptrs*
           %val = load volatile $ptrs, $ptrs* %ptr, align 1
           ret $ptrs %val
           """
    ld = :(function volatile_load(x::Ptr{$T})
        @inline
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
        @inline
        return Base.llvmcall(
            $str,
            Cvoid,
            Tuple{$T},
            x
    )
    end)
    @eval $k
end

# delay functionality transpiled from
# https://github.com/avr-rust/delay/blob/master/src/lib.rs
delay_ms(m::Int) = delay_ms(reinterpret(UInt, m))
delay_ms(ms::UInt) = delay_us(ms * 1000)

delay_us(m::Int) = delay_us(reinterpret(UInt, m))
function delay_us(us::UInt)
    us_in_loop = (CPU_FREQUENCY_HZ() ÷ 1000000 ÷ 4)
    loops = us * us_in_loop
    delay(loops)
end

delay(m::Int) = delay(reinterpret(UInt, m))
@inline function delay(count::UInt)
    outer_count = (count ÷ 65536) % UInt16
    rest_count = ((count % 65536) + 1) % UInt16
    for y in one(outer_count):outer_count
        keep(y)
        Base.llvmcall(
            """
            %X = call i16 asm sideeffect "1:
                             sbiw \$0, 1
                             brne 1b", "=X,0"(i16 %0)
            ret void
            """,
            Cvoid,
            Tuple{UInt16},
            zero(UInt16)
        )
    end
    Base.llvmcall(
        """
        %X = call i16 asm sideeffect "1:
                         sbiw \$0, 1
                         brne 1b", "=X,0"(i16 %0)
        ret void
        """,
        Cvoid,
        Tuple{UInt16},
        rest_count
    )
end

end # module
