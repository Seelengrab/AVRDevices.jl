module blink_led

using AVRDevices.Common
using AVRDevices.ATmega328p

function main()
    DDRB[] = DDRB1
    
    while true
        PORTB[] =  PORTB1
        delay_ms(1000)
        
        PORTB[] = ~PORTB1
        delay_ms(1000)
    end
end

end
