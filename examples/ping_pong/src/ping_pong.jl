module ping_pong

using AVRDevices.Common
using AVRDevices.ATmega328p
using AVRDevices.ATmega328p.Serial

function main()
    s = USART0()

    while true
        data = read(UInt8, s)
        delay_ms(1000)
        write(s, data + 0x1)
        delay_ms(1000)
    end
end

end # module ping_pong
