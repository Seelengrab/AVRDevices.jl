module ATmega328p

using ..AVRDevices.Common

export PINB, DDRB, PORTB, PINC, DDRC, PORTC, PIND, DDRD, PORTD, TIFR0,
       TIFR1, TIFR2, PCIFR, EIFR, EIMSK, GPIOR0, EECR, EEDR, EEARL, EEARH,
       GTCCR, TCCR0A, TCCR0B, TCNT0, OCR0A, OCR0B, GPIOR1, GPIOR2, SPCR,
       SPSR, SPDR, ACSR, SMCR, MCUSR, MCUCR, SPMCSR, SPL, SPH, SREG, WDTCSR,
       CLKPR, PRR, OSCCAL, PCICR, EICRA, PCMSK0, PCMSK1, PCMSK2, TIMSK0,
       TIMSK1, TIMSK2, ADCL, ADCH, ADCSRA, ADCSRB, ADMUX, DIDR0, DIDR1,
       TCCR1A, TCCR1B, TCCR1C, TCNT1L, TCNT1H, ICR1L, ICR1H, OCR1AL,
       OCR1AH, OCR1BL, OCR1BH, TCCR2A, TCCR2B, TCNT2, OCR2A, OCR2B, ASSR,
       TWBR, TWSR, TWAR, TWDR, TWCR, TWAMR, UCSR0A, UCSR0B, UCSR0C, UBBR0L, UBBR0H, UDR0

const Ru8 = Register{UInt8}

const PINB = Ru8(0x03)
const DDRB = Ru8(0x04)
const PORTB = Ru8(0x05)

const PINC = Ru8(0x06)
const DDRC = Ru8(0x07)
const PORTC = Ru8(0x08)

const PIND = Ru8(0x09)
const DDRD = Ru8(0x0A)
const PORTD = Ru8(0x0B)

const TIFR0 = Ru8(0x15)
const TIFR1 = Ru8(0x16)
const TIFR2 = Ru8(0x17)

const PCIFR = Ru8(0x1B)
const EIFR = Ru8(0x1C)
const EIMSK = Ru8(0x1D)
const GPIOR0 = Ru8(0x1E)
const EECR = Ru8(0x1F)
const EEDR = Ru8(0x20)
const EEARL = Ru8(0x21)
const EEARH = Ru8(0x22)
const GTCCR = Ru8(0x23)
const TCCR0A = Ru8(0x24)
const TCCR0B = Ru8(0x25)
const TCNT0 = Ru8(0x26)
const OCR0A = Ru8(0x27)
const OCR0B = Ru8(0x28)

const GPIOR1 = Ru8(0x2A)
const GPIOR2 = Ru8(0x2B)
const SPCR = Ru8(0x2C)
const SPSR = Ru8(0x2D)
const SPDR = Ru8(0x2E)

const ACSR = Ru8(0x30)

const SMCR = Ru8(0x33)
const MCUSR = Ru8(0x34)
const MCUCR = Ru8(0x34)

const SPMCSR = Ru8(0x37)

const SPL = Ru8(0x3D)
const SPH = Ru8(0x3E)
const SREG = Ru8(0x3F)

const WDTCSR = Ru8(0x60)
const CLKPR = Ru8(0x61)

const PRR = Ru8(0x64)

const OSCCAL = Ru8(0x66)

const PCICR = Ru8(0x68)
const EICRA = Ru8(0x69)

const PCMSK0 = Ru8(0x6B)
const PCMSK1 = Ru8(0x6C)
const PCMSK2 = Ru8(0x6D)
const TIMSK0 = Ru8(0x6E)
const TIMSK1 = Ru8(0x6F)
const TIMSK2 = Ru8(0x70)

const ADCL = Ru8(0x78)
const ADCH = Ru8(0x79)
const ADCSRA = Ru8(0x7A)
const ADCSRB = Ru8(0x7B)
const ADMUX = Ru8(0x7C)

const DIDR0 = Ru8(0x7E)
const DIDR1 = Ru8(0x7F)
const TCCR1A = Ru8(0x80)
const TCCR1B = Ru8(0x81)
const TCCR1C = Ru8(0x82)

const TCNT1L = Ru8(0x84)
const TCNT1H = Ru8(0x85)
const ICR1L = Ru8(0x86)
const ICR1H = Ru8(0x87)
const OCR1AL = Ru8(0x88)
const OCR1AH = Ru8(0x89)
const OCR1BL = Ru8(0x8A)
const OCR1BH = Ru8(0x8B)

const TCCR2A = Ru8(0xB0)
const TCCR2B = Ru8(0xB1)
const TCNT2 = Ru8(0xB2)
const OCR2A = Ru8(0xB3)
const OCR2B = Ru8(0xB4)

const ASSR = Ru8(0xB6)

const TWBR = Ru8(0xB8)
const TWSR = Ru8(0xB9)
const TWAR = Ru8(0xBA)
const TWDR = Ru8(0xBB)
const TWCR = Ru8(0xBC)
const TWAMR = Ru8(0xBD)

const UCSR0A = Ru8(0xC0)
const UCSR0B = Ru8(0xC1)
const UCSR0C = Ru8(0xC2)

const UBBR0L = Ru8(0xC4)
const UBBR0H = Ru8(0xC5)
const UDR0 = Ru8(0xC6)

end
