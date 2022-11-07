module uart_example

using AVRDevices.Common
using AVRDevices.ATmega328p
using AVRDevices.ATmega328p.Serial

function main()
    s = USART0()

    idx = 0x0
    while true
        write(s, idx)
        idx += 0x1
        delay_ms(100)
    end
end

end # module uart_example
