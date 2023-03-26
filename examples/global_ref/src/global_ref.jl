module global_ref

using AVRDevices.Common
using AVRDevices.ATmega328p
using AVRDevices.ATmega328p.Serial

const number = Ref(1)

function main()
    s = USART0()

    while true
        write(s, number[])
        delay_ms(1000)
    end
end

end # module global_ref
