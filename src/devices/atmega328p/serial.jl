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

struct USART0{N} <: IO
    function USART0{ndata}(; baud::Int=9600, async::Bool=false, parity::Parity=None, nstop::StopBits=Two) where ndata
        hi, lo = calc_baud(baud)
        UBBR0H[] = hi
        UBBR0L[] = lo

        # now enable the USART
        UCSR0B[] = RXEN0 | TXEN0

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
        if ndata == 0x5
            # no extra registers
        elseif ndata == 0x6
            c_mask |=                   UCSZ00
        elseif ndata == 0x7
            c_mask |=          UCSZ01
        elseif ndata == 0x8
            c_mask |=          UCSZ01 | UCSZ00
        elseif ndata == 0x9
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

        UCSR0C[] = c_mask

        new{ndata}()
    end
end
USART0(;kwargs...) = USART0{0x8}(;kwargs...)

Base.lock(_::USART0) = return # there is no exclusivity here
Base.unlock(_::USART0) = return # there is no exclusivity here

function _write_byte(::USART0{N}, b::UInt8, ninth::Bool) where N
    while !UDRE0[] end # wait until we can send
    if N == 0x9
        TXB80[] = ninth
    end
    UDR0[] = b
    nothing
end

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

function _write_int(u::USART0{N}, x::T) where {N, T <: Base.BitInteger}
    ts = sizeof(T) % UInt8
    nloops = div(0x8*ts, N, RoundUp) % UInt8
    for _ in 0x1:nloops
        if N == 0x9 && ts > 0x1
            ninth = ((x >> 0x8) & 0x01) != 0x0 # save the ninth bit
        else
            ninth = false
        end
        byte = (x % UInt8) & ~(0xff << N)
        _write_byte(u, byte, ninth)
        x >>= N
    end
    nloops
end

function Base.write(u::USART0{N}, vec::T) where {N, T <: AbstractVector{UInt8}}
    wr = 0x0
    isempty(vec) && return wr
    if N != 0x9 # easy case
        data = vec[0x1]
        wr += write(u, data)
        data <<= N
        idx = 0x1
        while idx < lastindex(vec)
            idx += 0x1
            el = vec[idx]
            data |= el >> (0x8 - N)
            wr += write(u, data)
            data = el << N
        end
    else # troublesome 9th
        # TODO
    end
    wr
end

Base.write(u::USART0, s::String) = write(u, codeunits(s))


end
