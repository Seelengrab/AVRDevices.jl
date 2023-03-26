module Serial

using ...AVRDevices.Common
using ..ATmega328p
using Base: Unicode

export USART0

@enum Parity None Even Odd
@enum StopBits One Two

function calc_baud(baud)
    ubrr = (((CPU_FREQUENCY_HZ() ÷ 16) ÷ baud) - 0x1) % UInt16
    high = (ubrr >> 0x8) % UInt8
    low  =  ubrr         % UInt8
    high, low
end

"""
    USART0{FrameSize}(;
        baud::Int=9600,
        async::Bool=true,
        parity::Parity=None,
        nstop::StopBits=Two
    ) where {5 <= FrameSize <= 9}

Configure and initialize the `USART0`. The returned object has `sizeof(USART0{N}) === 0` and is only used for dispatch.

The frame size is passed as a type parameter to allow the configuration to not be persistent state and to permit the compiler
to optimize the `USART0` instance away entirely. This also leads to specialization of the various `write` methods of a frame,
taking advantage of our compiler as well as abstract interpretation to prevent branches that are known to be dead.
An additional advantage is that the existence of the `USART0` object implies its initialization, upholding the semantics
required by the datasheet - if we have the object, we know that it is valid.

!!! warn "Initialization"
    Modifying the UART global state outside of this constructor invalidates previously existing objects,
    which assume their initialization is still correct. This includes having two different `USART0` objects
    alive at the same time. This will lead to inconsistent data output and is undefined behavior.

!!! warn "Type Stability"
    While reconfiguring the USART0 on the fly based on runtime data is theoretically possible, this will lead to a type instability
    and dynamic dispatch, which is currently not supported.
"""
struct USART0{N} <: IO
    function USART0{FrameSize}(; baud::Int=9600, async::Bool=true, parity::Parity=None, nstop::StopBits=Two) where FrameSize
        5 <= FrameSize <= 9 || throw(ArgumentError("Invalid Framesize: $N")) # TODO: Check if this error path is optimized away
        hi, lo = calc_baud(baud) # this relies on constant propagation

        # disable USART
        UCSR0B[] = zero(UCSR0B)

        # set baud rate
        UBBR0H[] = hi
        UBBR0L[] = lo

        # enable async mode
        if async
            UCSR0A[] |= U2X0
        end

        c_mask = zero(UCSR0C)
        # set stop bits
        if nstop === One
            # nothing to set
        elseif nstop === Two
            c_mask |= USBS0
        end

        # set frame length
        if FrameSize == 0x5
            # no extra registers
        elseif FrameSize == 0x6
            c_mask |=                   UCSZ00
        elseif FrameSize == 0x7
            c_mask |=          UCSZ01
        elseif FrameSize == 0x8
            c_mask |=          UCSZ01 | UCSZ00
        elseif FrameSize == 0x9
            c_mask |= UCSZ02 | UCSZ01 | UCSZ00
        end

        # set parity
        if parity === None
            # no bits set
        elseif parity === Even
            c_mask |= UPM01
        elseif parity === Odd
            c_mask |= UPM01 | UPM00
        end

        # write stop bits, framesize and parity configuration
        UCSR0C[] = c_mask

        # now enable the USART
        UCSR0B[] = RXEN0 | TXEN0

        # USART0 initialized, return object
        new{FrameSize}()
    end
end
USART0(;kwargs...) = USART0{0x8}(;kwargs...)

Base.lock(_::USART0) = return nothing # there is no exclusivity here - disable interrupts later?
Base.unlock(_::USART0) = return nothing # there is no exclusivity here - enable interrupts later?

"""
    Frame{FrameSize, Ninth}

## Invariants

 * `5 <= FrameSize <= 9`
 * `Ninth = FrameSize === 9 ? 1 : 0`

## Fields

 * data::UInt8
 * ninth::Ntuple{Ninth, Bool}

This struct is constructed such that `sizeof(Frame{9, 1}) === 2` and `sizeof(Frame{5/6/7/8, 0}) === 1`.
This allows more efficient passing of arguments, saving an `UInt8`, when `5 <= FrameSize <= 8`.
"""
struct Frame{FrameSize, Ninth}
    data::UInt8
    ninth::NTuple{Ninth, Bool}

    """
        Frame{FrameSize}(data::UInt8[, ninth::Bool=false])

    Construct a single frame of USART data. `ninth` is ignored when `FrameSize !== 9`.
    """
    function Frame{FrameSize}(data::UInt8, ninth::Bool=false) where FrameSize
        5 <= FrameSize <= 9 || throw(ArgumentError("Invalid Framesize: $N"))
        Ninth = FrameSize === 9
        ninth_nt = Ninth ? NTuple{1, Bool}(ninth) : NTuple{0, Bool}()
        new{FrameSize, Int(Ninth)}(data, ninth_nt)
    end
end

"""
    write(::USART0{FrameSize}, f::Frame{FrameSize}) where 5 <= FrameSize <= 9

Write a single frame of data to the USART transmit buffer. This will block until the data is written.
"""
function Base.write(::USART0{FrameSize}, f::Frame{FrameSize}) where FrameSize
    # TODO: implement interrupt based writing
    while !UDRE0[] end # wait until we can send
    if FrameSize === 0x9 # this constant folds away
        TXB80[] = f.ninth[1]
    end
    UDR0[] = f.data
    nothing
end

"""
    read(::USART0{FrameSize}, ::Type{<:Frame{FrameSize}}) where 5 <= FrameSize <= 9

Read a single frame of data from the USART receive buffer. This will block until data is available to read.
"""
function Base.read(::USART0{FrameSize}, ::Type{<:Frame{FrameSize}}) where FrameSize
    # TODO: implement interrupt based reading
    while !RXC0[] end # wait until we have data to read
    ninth = if FrameSize === 0x9 # this constant folds away
        RXB80[]
    else
        false
    end
    data = UDR0[]
    Frame{FrameSize}(data, ninth)
end

#########
# writing
#########

# this is just here until julialang/julia#47385 is fixed
Base.write(u::USART0, v::Int8)    = _write_int(u, v)
Base.write(u::USART0, v::Int16)   = _write_int(u, v)
Base.write(u::USART0, v::Int32)   = _write_int(u, v)
Base.write(u::USART0, v::Int64)   = _write_int(u, v)
Base.write(u::USART0, v::Int128)  = _write_int(u, v)
Base.write(u::USART0, v::UInt8)   = _write_int(u, v)
Base.write(u::USART0, v::UInt16)  = _write_int(u, v)
Base.write(u::USART0, v::UInt32)  = _write_int(u, v)
Base.write(u::USART0, v::UInt64)  = _write_int(u, v)
Base.write(u::USART0, v::UInt128) = _write_int(u, v)

function _write_int(u::USART0{FrameSize}, x::T) where {FrameSize, T <: Base.BitInteger}
    typesize = sizeof(T) % UInt8
    nloops = div(0x8*typesize, FrameSize, RoundUp) % UInt8
    for _ in 0x1:nloops
        if FrameSize === 0x9 && typesize > 0x1
            ninth = ((x >> 0x8) & 0x01) != 0x0 # save the ninth bit
        else
            ninth = false
        end
        data = (x % UInt8) & ~(0xff << FrameSize)
        frame = Frame{FrameSize}(data, ninth)
        write(u, frame)
        x >>= FrameSize
    end
    nloops
end

Base.write(u::USART0, s::String) = write(u, codeunits(s))
Base.write(u::USART0{N}, vec::T) where {N, X, T <: NTuple{X, UInt8}}           = _write(u, vec)
Base.write(u::USART0{N}, vec::T) where {N, T <: AbstractVector{UInt8}}         = _write(u, vec)
Base.write(u::USART0{N}, vec::T) where {N, T <: Base.CodeUnits{UInt8, String}} = _write(u, vec)

function _write(u::USART0{N}, vec::T) where {N, I <: Integer, T <: AbstractVector{I}}
    wr = 0x0
    isempty(vec) && return wr
    if N != 0x9 # easy case
        data = @inbounds vec[0x1]
        wr += write(u, data)
        data <<= N
        idx = 0x1
        while idx < lastindex(vec)
            idx += 0x1
            el = @inbounds vec[idx]
            data |= el >> (0x8 - N)
            wr += write(u, data)
            data = el << N
        end
    else # troublesome 9th
        # TODO
    end
    wr
end

# we don't have locking here and `try`/`catch` of the Base version
# doesn't work yet
function Base.print(io::USART0, x::T...) where T
    for x in xs
        print(io, x)
    end
    return nothing
end

Base.print(u::USART0, s::String) = (write(u, s); nothing)

end
