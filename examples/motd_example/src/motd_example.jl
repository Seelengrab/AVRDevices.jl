module motd_example

using AVRDevices.Common
using AVRDevices.ATmega328p.Serial: USART0

const MOTD = "The message of the day is: https://www.youtube.com/watch?v=cEzcFXRKHUw"

function main()
    s = USART0()

    while true
        write(s, MOTD)
        delay_ms(1000)
    end
end

end # module motd_example
