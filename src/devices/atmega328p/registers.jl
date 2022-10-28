export PINB, DDRB, PORTB, PINC, DDRC, PORTC, PIND, DDRD, PORTD, TIFR0,
       TIFR1, TIFR2, PCIFR, EIFR, EIMSK, GPIOR0, EECR, EEDR, EEARL, EEARH,
       GTCCR, TCCR0A, TCCR0B, TCNT0, OCR0A, OCR0B, GPIOR1, GPIOR2, SPCR,
       SPSR, SPDR, ACSR, SMCR, MCUSR, MCUCR, SPMCSR, SPL, SPH, SREG, WDTCSR,
       CLKPR, PRR, OSCCAL, PCICR, EICRA, PCMSK0, PCMSK1, PCMSK2, TIMSK0,
       TIMSK1, TIMSK2, ADCL, ADCH, ADCSRA, ADCSRB, ADMUX, DIDR0, DIDR1,
       TCCR1A, TCCR1B, TCCR1C, TCNT1L, TCNT1H, ICR1L, ICR1H, OCR1AL,
       OCR1AH, OCR1BL, OCR1BH, TCCR2A, TCCR2B, TCNT2, OCR2A, OCR2B, ASSR,
       TWBR, TWSR, TWAR, TWDR, TWCR, TWAMR, UCSR0A, UCSR0B, UCSR0C, UBBR0L, UBBR0H, UDR0

const Ru8{R} = Register{R, UInt8}

const PINB   = Ru8{:PINB}(0x23)
const DDRB   = Ru8{:DDRB}(0x24)
const PORTB  = Ru8{:PORTB}(0x25)

for p in 0:7
    _p = p+1
    pinb  = Symbol(:PINB,  p)
    ddrb  = Symbol(:DDRB,  p)
    portb = Symbol(:PORTB, p)
    @eval begin
       const $pinb  = Pin{PINB,  $_p}()
       const $ddrb  = Pin{DDRB,  $_p}()
       const $portb = Pin{PORTB, $_p}()
       export $pinb, $ddrb, $portb
    end
end

const PINC   = Ru8{:PINC}(0x26)
const DDRC   = Ru8{:DDRC}(0x27)
const PORTC  = Ru8{:PORTC}(0x28)

for p in 0:6
    pinc  = Symbol(:PINC,  p)
    ddrc  = Symbol(:DDRC,  p)
    portc = Symbol(:PORTC, p)
    @eval begin
       const $pinc  = Pin{PINC,  $(p+1)}()
       const $ddrc  = Pin{DDRC,  $(p+1)}()
       const $portc = Pin{PORTC, $(p+1)}()
       export $pinc, $ddrc, $portc
    end
end

const PIND   = Ru8{:PIND}(0x29)
const DDRD   = Ru8{:DDRD}(0x2a)
const PORTD  = Ru8{:PORTD}(0x2b)

for p in 0:7
    _p = p+1
    pind  = Symbol(:PIND,  p)
    ddrd  = Symbol(:DDRD,  p)
    portd = Symbol(:PORTD, p)
    @eval begin
       const $pind  = Pin{PIND,  $_p}()
       const $ddrd  = Pin{DDRD,  $_p}()
       const $portd = Pin{PORTD, $_p}()
       export $pind, $ddrd, $portd
    end
end

const TIFR0  = Ru8{:TIFR0}(0x35)
const TIFR1  = Ru8{:TIFR1}(0x36)
const TIFR2  = Ru8{:TIFR2}(0x37)

for p in 0:2
    tov = Symbol(:TOV, p)
    ocfa = Symbol(:OCF, p, :A)
    ocfb = Symbol(:OCF, p, :B)
    tifr = eval(Symbol(:TIFR, p))
    @eval begin
      const $tov  = Pin{$tifr, 1}()
      const $ocfa = Pin{$tifr, 2}()
      const $ocfb = Pin{$tifr, 3}()
      export $tov, $ocfa, $ocfb
    end
end
const ICF1 = Pin{TIFR1, 6}()

const PCIFR  = Ru8{:PCIFR}(0x3b)

for p in 0:2
    pcif = Symbol(:PCIF, p)
    @eval begin
      const $pcif = Pin{PCIFR, $p}()
      export $pcif
    end
end

const EIFR   = Ru8{:EIFR}(0x3c)
const EIMSK  = Ru8{:EIMSK}(0x3d)

for p in 0:1
    _p = p+1
    int  = Symbol(:INT,  p)
    intf = Symbol(:INTF, p)
    @eval begin
        const $int  = Pin{EIFR,  $_p}()
        const $intf = Pin{EIMSK, $_p}()
        export $int, $intf
    end
end

const GPIOR0 = Ru8{:GPIOR0}(0x3e)
const EECR   = Ru8{:EECR}(0x3f)

const EERE   = Pin{EECR, 1}()
const EEPE   = Pin{EECR, 2}()
const EEMPE  = Pin{EECR, 3}()
const EERIE  = Pin{EECR, 4}()
const EEPM0  = Pin{EECR, 5}()
const EEPM1  = Pin{EECR, 6}()
export EERE, EEPE, EEMPTE, EERIE, EEPM0, EEPM1

const EEDR   = Ru8{:EEDR}(0x40)
const EEARL  = Ru8{:EEARL}(0x41)
const EEARH  = Ru8{:EEARH}(0x42)

const GTCCR  = Ru8{:GTCCR}(0x43)

const PSRSYNC = Pin{GTCCR, 1}()
const PSRASY  = Pin{GTCCR, 2}()
const TSM     = Pin{GTCCR, 8}()
export PSRSYNC, PSRASY, TSM

const TCCR0A = Ru8{:TCCR0A}(0x44)

const WGM00  = Pin{TCCR0A, 1}()
const WGM01  = Pin{TCCR0A, 2}()
const COM0B0 = Pin{TCCR0A, 5}()
const COM0B1 = Pin{TCCR0A, 6}()
const COM0A0 = Pin{TCCR0A, 7}()
const COM0A1 = Pin{TCCR0A, 8}()
export WGM00, WGM01, COM0B0, COM0B1, COM0A0, COM0A1

const TCCR0B = Ru8{:TCCR0B}(0x45)

const CS00  = Pin{TCCR0B, 1}()
const CS01  = Pin{TCCR0B, 2}()
const CS02  = Pin{TCCR0B, 3}()
const WGM02 = Pin{TCCR0B, 4}()
const FOC0B = Pin{TCCR0B, 7}()
const FOC0A = Pin{TCCR0B, 8}()
export CS00, CS01, CS02, WGM02, FOC0B, FOC0A

const TCNT0  = Ru8{:TCNT0}(0x46)
const OCR0A  = Ru8{:OCR0A}(0x47)
const OCR0B  = Ru8{:OCR0B}(0x48)

const GPIOR1 = Ru8{:GPIOR1}(0x4a)
const GPIOR2 = Ru8{:GPIOR2}(0x4b)

const SPCR   = Ru8{:SPCR}(0x4c)

const SPR0 = Pin{SPCR, 1}()
const SPR1 = Pin{SPCR, 2}()
const CPHA = Pin{SPCR, 3}()
const CPOL = Pin{SPCR, 4}()
const MSTR = Pin{SPCR, 5}()
const DORD = Pin{SPCR, 6}()
const SPE  = Pin{SPCR, 7}()
const SPIE = Pin{SPCR, 8}()
export SPR0, SPR1, CPHA, CPOL, MSTR, DORD, SPE, SPIE

const SPSR   = Ru8{:SPSR}(0x4d)

const SPI2X = Pin{SPSR, 1}()
const WCOL  = Pin{SPSR, 7}()
const SPIF  = Pin{SPSR, 8}()
export SPI2C, WCOL, SPIF

const SPDR   = Ru8{:SPDR}(0x4e)

for p in 0:7
    _p = p+1
    gpio0 = Symbol(:GPIOR0, p)
    gpio1 = Symbol(:GPIOR1, p)
    gpio2 = Symbol(:GPIOR2, p)
    eedr  = Symbol(:EEDR,   p)
    eearl = Symbol(:EEARL,  p)
    eearh = Symbol(:EEARH,  p)
    tcnt0 = Symbol(:TCNT0,  p)
    ocr0a = Symbol(:OCR0A,  p)
    ocr0b = Symbol(:OCR0B,  p)
    spdr  = Symbol(:SPDR,   p)
    @eval begin
        const $gpio0 = Pin{GPIOR0, $_p}()
        const $gpio1 = Pin{GPIOR1, $_p}()
        const $gpio2 = Pin{GPIOR2, $_p}()
        const $eedr  = Pin{EEDR,   $_p}()
        const $eearl = Pin{EEARL,  $_p}()
        const $eearh = Pin{EEARH,  $_p}()
        const $ocr0a = Pin{OCR0A,  $_p}()
        const $ocr0b = Pin{OCR0B,  $_p}()
        const $spdr  = Pin{SPDR,   $_p}()
        export $gpio0, $gpio1, $gpio2, $eedr, $eearl, $eearh, $ocr0a, $ocr0b, $spdr
    end
end

const ACSR   = Ru8{:ACSR}(0x50)

const ACIS0 = Pin{ACSR, 1}()
const ACIS1 = Pin{ACSR, 2}()
const ACIC  = Pin{ACSR, 3}()
const ACIE  = Pin{ACSR, 4}()
const ACI   = Pin{ACSR, 5}()
const ACO   = Pin{ACSR, 6}()
const ACBG  = Pin{ACSR, 7}()
const ACD   = Pin{ACSR, 8}()
export ACIS0, ACIS1, ACIC, ACIE, ACI, ACO, ACBG, ACD

const SMCR   = Ru8{:SMCR}(0x53)

const SE  = Pin{SMCR, 1}()
const SM0 = Pin{SMCR, 2}()
const SM1 = Pin{SMCR, 3}()
const SM2 = Pin{SMCR, 4}()
export SE, SM0, SM1, SM2

const MCUSR  = Ru8{:MCUSR}(0x54)

const PORF  = Pin{MCUSR, 1}()
const EXTRF = Pin{MCUSR, 2}()
const BORF  = Pin{MCUSR, 3}()
const WDRF  = Pin{MCUSR, 4}()
export PORF, EXTR, BORF, WDRF

const MCUCR  = Ru8{:MCUCR}(0x55)

const IVCE  = Pin{MCUCR, 1}()
const IVSEL = Pin{MCUCR, 2}()
const PUD   = Pin{MCUCR, 3}()
const BODSE = Pin{MCUCR, 4}()
const BODS  = Pin{MCUCR, 5}()
export IVCE, IVSEL, PUD, BODSE, BODS

const SPMCSR = Ru8{:SPMCSR}(0x57)

const SPMEN  = Pin{SPMCSR, 1}()
const PGERS  = Pin{SPMCSR, 2}()
const PGWRT  = Pin{SPMCSR, 3}()
const BLBSET = Pin{SPMCSR, 4}()
const RWWSRE = Pin{SPMCSR, 5}()
const SIGRD  = Pin{SPMCSR, 6}()
const RWWSB  = Pin{SPMCSR, 7}()
const SPMIE  = Pin{SPMCSR, 8}()
export SPMEN, PGERS, PGWRT, BLBSET, RWWSRE, SIGRD, RWWSB, SPMIE

const SPL    = Ru8{:SPL}(0x5d)

for p in 0:7
    _p = p+1
    sp = Symbol(:SP, p)
    @eval begin
        const $sp = Pin{SPL, $_p}()
        export $sp
    end
end

const SPH = Ru8{:SPH}(0x5e)

const SP8  = Pin{SPH, 1}()
const SP9  = Pin{SPH, 2}()
const SP10 = Pin{SPH, 3}()
export SP8, SP9, SP10

const SREG   = Ru8{:SREG}(0x5f)

const C = Pin{SREG, 1}()
const Z = Pin{SREG, 2}()
const N = Pin{SREG, 3}()
const V = Pin{SREG, 4}()
const S = Pin{SREG, 5}()
const H = Pin{SREG, 6}()
const T = Pin{SREG, 7}()
const I = Pin{SREG, 8}()
export C, Z, N, V, S, H, T, I

const WDTCSR = Ru8{:WDTCSR}(0x60)

const WDP0 = Pin{WDTCSR, 1}()
const WDP1 = Pin{WDTCSR, 2}()
const WDP2 = Pin{WDTCSR, 3}()
const WDE  = Pin{WDTCSR, 4}()
const WDCE = Pin{WDTCSR, 5}()
const WDP3 = Pin{WDTCSR, 6}()
const WDIE = Pin{WDTCSR, 7}()
const WDIF = Pin{WDTCSR, 8}()
export WDP0, WDP1, WDP2, WDE, WDCE, WDP3, WDIE, WDIF

const CLKPR  = Ru8{:CLKPR}(0x61)

const CLKPS0 = Pin{CLKPR, 1}()
const CLKPS1 = Pin{CLKPR, 2}()
const CLKPS2 = Pin{CLKPR, 3}()
const CLKPS3 = Pin{CLKPR, 4}()
const CLKPCE = Pin{CLKPR, 8}()
export CLKPS0, CLKPS1, CLKPS2, CLKPS3, CLKPCE

const PRR    = Ru8{:PRR}(0x64)

const PRADC    = Pin{PRR, 1}()
const PRUSART0 = Pin{PRR, 2}()
const PRSPI    = Pin{PRR, 3}()
const PRTIM1   = Pin{PRR, 4}()
const PRTIM0   = Pin{PRR, 6}()
const PRTIM2   = Pin{PRR, 7}()
const PRTWI    = Pin{PRR, 8}()
export PRADC, PRUSART0, PRSPI, PRTIM1, PRTIM0, PRTIM2, PRTWI

const OSCCAL = Ru8{:OSCCAL}(0x66)

for p in 0:7
    _p = p+1
    osc = Symbol(:OSCCAL, p)
    @eval begin
        const $osc = Pin{OSCCAL, $_p}()
        export $osc
    end
end

const PCICR  = Ru8{:PCICR}(0x68)

const PCIE0 = Pin{PCICR, 1}()
const PCIE1 = Pin{PCICR, 2}()
const PCIE2 = Pin{PCICR, 3}()
export PCIE0, PCIE1, PCIE2

const EICRA  = Ru8{:EICRA}(0x69)

const ISC00 = Pin{EICRA, 1}()
const ISC01 = Pin{EICRA, 2}()
const ISC10 = Pin{EICRA, 3}()
const ISC11 = Pin{EICRA, 4}()
export ISC00, ISC01, ISC10, ISC11

const PCMSK0 = Ru8{:PCMSK0}(0x6B)
const PCMSK1 = Ru8{:PCMSK1}(0x6C)
const PCMSK2 = Ru8{:PCMSK2}(0x6D)

for p in 0:7
    _p = p+1
    pc0 = Symbol(:PCINT, p)
    pc1 = Symbol(:PCINT, p+8)
    pc2 = Symbol(:PCINT, p+16)
    @eval begin
        const $pc0 = Pin{PCMSK0, $_p}()
        const $pc2 = Pin{PCMSK2, $_p}()
        export $pc0, $pc2
    end
    if p != 7
        @eval begin
            const $pc1 = Pin{PCMSK1, $_p}()
            export $pc1
        end
    end
end

const TIMSK0 = Ru8{:TIMSK0}(0x6E)
const TIMSK1 = Ru8{:TIMSK1}(0x6F)
const TIMSK2 = Ru8{:TIMSK2}(0x70)

for p in 0:2
    _p = p+1
    toie = Symbol(:TOIE, p)
    ociea = Symbol(:OCIE, p, :A)
    ocieb = Symbol(:OCIE, p, :B)
    reg = eval(Symbol(:TIMSK, p))
    @eval begin
        const $toie = Pin{$reg, 1}()
        const $ociea = Pin{$reg, 2}()
        const $ocieb = Pin{$reg, 3}()
        export $toie, ociea, ocieb
    end
end
const ICIE1 = Pin{TIMSK1, 6}()
export ICIE1

const ADCL   = Ru8{:ADCL}(0x78)
const ADCH   = Ru8{:ADCH}(0x79)

for p in 0:7
    _p = p+1
    adcl = Symbol(:ADCL, p)
    adch = Symbol(:ADCH, p)
    @eval begin
        const $adcl = Pin{ADCL, $_p}()
        const $adch = Pin{ADCH, $_p}()
        export $adcl, $adch
    end
end

const ADCSRA = Ru8{:ADCSRA}(0x7A)

const ADPS0 = Pin{ADCSRA, 1}()
const ADPS1 = Pin{ADCSRA, 2}()
const ADPS2 = Pin{ADCSRA, 3}()
const ADIE  = Pin{ADCSRA, 4}()
const ADIF  = Pin{ADCSRA, 5}()
const ADATE = Pin{ADCSRA, 6}()
const ADSC  = Pin{ADCSRA, 7}()
const ADEN  = Pin{ADCSRA, 8}()
export ADPS0, ADPS1, ADPS2, ADIE, ADIF, ADATE, ADSC, ADEN

const ADCSRB = Ru8{:ADCSRB}(0x7B)

const ADTS0 = Pin{ADCSRB, 1}()
const ADTS1 = Pin{ADCSRB, 2}()
const ADTS2 = Pin{ADCSRB, 3}()
const ACME  = Pin{ADCSRB, 7}()
export ADTS0, ADTS1, ADTS2, ACME

const ADMUX = Ru8{:ADMUX}(0x7C)

const MUX0  = Pin{ADMUX, 1}()
const MUX1  = Pin{ADMUX, 2}()
const MUX2  = Pin{ADMUX, 3}()
const MUX3  = Pin{ADMUX, 4}()
const ADLAR = Pin{ADMUX, 6}()
const REFS0 = Pin{ADMUX, 7}()
const REFS1 = Pin{ADMUX, 8}()
export MUX0, MUX1, MUX2, MUX3, ADLAR, REFS0, REFS1

const DIDR0  = Ru8{:DIDR0}(0x7E)

for p in 0:5
    _p = p+1
    adcd = Symbol(:ADC, p, :D)
    @eval begin
        $adcd = Pin{DIDR0, $_p}()
        export $adcd
    end
end

const DIDR1  = Ru8{:DIDR1}(0x7F)
const AIN0D = Pin{DIDR1, 1}()
const AIN1D = Pin{DIDR1, 2}()
export AIN0D, AIN1D

const TCCR1A = Ru8{:TCCR1A}(0x80)
const TCCR1B = Ru8{:TCCR1B}(0x81)
const TCCR1C = Ru8{:TCCR1C}(0x82)

const WGM10  = Pin{TCCR1A, 1}()
const WGM11  = Pin{TCCR1A, 2}()
const COM1B0 = Pin{TCCR1A, 5}()
const COM1B1 = Pin{TCCR1A, 6}()
const COM1A0 = Pin{TCCR1A, 7}()
const COM1A1 = Pin{TCCR1A, 8}()
export WGM10, WGM11, COM1B0, COM1B1, COM1A0, COM1A1

const CS10  = Pin{TCCR1B, 1}()
const CS11  = Pin{TCCR1B, 2}()
const CS12  = Pin{TCCR1B, 3}()
const WGM12 = Pin{TCCR1B, 4}()
const WGM13 = Pin{TCCR1B, 5}()
const ICES1 = Pin{TCCR1B, 7}()
const ICNC1 = Pin{TCCR1B, 8}()
export CS10, CS11, CS12, WGM12, WGM13, ICES1, ICNC1

const FOC1B = Pin{TCCR1C, 7}()
const FOC1A = Pin{TCCR1C, 8}()
export FOC1B, FOC1A

const TCNT1L = Ru8{:TCNT1L}(0x84)
const TCNT1H = Ru8{:TCNT1H}(0x85)
const ICR1L  = Ru8{:ICR1L}(0x86)
const ICR1H  = Ru8{:ICR1H}(0x87)
const OCR1AL = Ru8{:OCR1AL}(0x88)
const OCR1AH = Ru8{:OCR1AH}(0x89)
const OCR1BL = Ru8{:OCR1BL}(0x8A)
const OCR1BH = Ru8{:OCR1BH}(0x8B)

for p in 0:7
    _p = p+1
    tcntl = Symbol(:TCNT1L, p)
    tcnth = Symbol(:TCNT1H, p)
    icrl  = Symbol(:ICR1L,  p)
    icrh  = Symbol(:ICR1H,  p)
    ocral = Symbol(:OCR1AL, p)
    ocrah = Symbol(:OCR1AH, p)
    ocrbl = Symbol(:OCR1BL, p)
    ocrbh = Symbol(:OCR1BH, p)
    @eval begin
        const $tcntl = Pin{TCNT1L, $_p}
        const $tcnth = Pin{TCNT1H, $_p}
        const $icrl  = Pin{ICR1L,  $_p}
        const $icrh  = Pin{ICR1H,  $_p}
        const $ocral = Pin{OCR1AL, $_p}
        const $ocrah = Pin{OCR1AH, $_p}
        const $ocrbl = Pin{OCR1BL, $_p}
        const $ocrbh = Pin{OCR1BH, $_p}
        export $tcntl, $tcnth, $icrl, $icrh, $ocral, $ocrah, $ocrbl, $ocrbh
    end
end

const TCCR2A = Ru8{:TCCR2A}(0xB0)

const WGM20  = Pin{TCCR2A, 1}()
const WGM21  = Pin{TCCR2A, 2}()
const COM2B0 = Pin{TCCR2A, 5}()
const COM2B1 = Pin{TCCR2A, 6}()
const COM2A0 = Pin{TCCR2A, 7}()
const COM2A1 = Pin{TCCR2A, 8}()
export WGM20, WGM21, COM2B0, COM2B1, COM2A0, COM2A1

const TCCR2B = Ru8{:TCCR2B}(0xB1)

const CS20  = Pin{TCCR2B, 1}()
const CS21  = Pin{TCCR2B, 2}()
const CS22  = Pin{TCCR2B, 4}()
const WGM22 = Pin{TCCR2B, 5}()
const FOC2B = Pin{TCCR2B, 7}()
const FOC2A = Pin{TCCR2B, 8}()
export CS20, CS21, CS22, WGM22, FOC2B, FOC2A

const TCNT2  = Ru8{:TCNT2}(0xB2)
const OCR2A  = Ru8{:OCR2A}(0xB3)
const OCR2B  = Ru8{:OCR2B}(0xB4)

for p in 0:7
    _p = p+1
    tcnt = Symbol(:TCNT2, p)
    ocra = Symbol(:OCR2A, p)
    ocrb = Symbol(:OCR2B, p)
    @eval begin
        const $tcnt = Pin{TCNT2, $_p}
        const $ocra = Pin{OCR2A, $_p}
        const $ocrb = Pin{OCR2B, $_p}
        export $tcnt, $ocra, $ocrb
    end
end

const ASSR   = Ru8{:ASSR}(0xB6)

const TCR2BUB = Pin{ASSR, 1}()
const TCR2AUB = Pin{ASSR, 2}()
const OCR2BUB = Pin{ASSR, 3}()
const OCR2AUB = Pin{ASSR, 4}()
const TCN2UB  = Pin{ASSR, 5}()
const AS2     = Pin{ASSR, 6}()
const EXCLK   = Pin{ASSR, 7}()
export TCR2BUB, TCR2AUB, OCR2BUB, OCR2AUB, TCN2UB, AS2, EXCLK

const TWBR   = Ru8{:TWBR}(0xB8)
const TWSR   = Ru8{:TWSR}(0xB9)
const TWAR   = Ru8{:TWAR}(0xBA)
const TWDR   = Ru8{:TWDR}(0xBB)
const TWCR   = Ru8{:TWCR}(0xBC)
const TWAMR  = Ru8{:TWAMR}(0xBD)

for p in 0:7
    _p = p+1
    twbr = Symbol(:TWBR, p)
    twdr = Symbol(:TWDR, p)
    @eval begin
        const $twbr = Pin{TWBR, $_p}()
        const $twdr = Pin{TWDR, $_p}()
        export $twbr, $twdr
    end
end

const TWPS0 = Pin{TWSR, 1}()
const TWPS1 = Pin{TWSR, 2}()
const TWS3  = Pin{TWSR, 4}()
const TWS4  = Pin{TWSR, 5}()
const TWS5  = Pin{TWSR, 6}()
const TWS6  = Pin{TWSR, 7}()
const TWS7  = Pin{TWSR, 8}()
export TWPS0, TWPS1, TWS3, TWS4, TWS5, TWS6, TWS7

const UCSR0A = Ru8{:UCSR0A}(0xC0)

const MPCM0  = Pin{UCSR0A, 1}()
const U2X0   = Pin{UCSR0A, 2}()
const UPE0   = Pin{UCSR0A, 3}()
const DOR0   = Pin{UCSR0A, 4}()
const FE0    = Pin{UCSR0A, 5}()
const UDRE0  = Pin{UCSR0A, 6}()
const TXC0   = Pin{UCSR0A, 7}()
const RXC0   = Pin{UCSR0A, 8}()
export MPCM0, U2X0, UPE0, DOR0, FE0, UDRE0, TXC0, RXC0

const UCSR0B = Ru8{:UCSR0B}(0xC1)

const TXB80 = Pin{UCSR0B, 1}()
const RX80  = Pin{UCSR0B, 2}()
const UCSZ02 = Pin{UCSR0B, 3}()
const TXEN0  = Pin{UCSR0B, 4}()
const RXEN0  = Pin{UCSR0B, 5}()
const UDRIE0 = Pin{UCSR0B, 6}()
const TXCIE0 = Pin{UCSR0B, 7}()
const RXCIE0 = Pin{UCSR0B, 8}()
export TXB80, RXB80, UCSZ02, TXEN0, RXEN0, UDRIE0, TXCIE0, RXCIE0

const UCSR0C = Ru8{:UCSR0C}(0xC2)

const UCPOL0 = Pin{UCSR0C, 1}()
const UCSZ00 = Pin{UCSR0C, 2}()
const UCSZ01 = Pin{UCSR0C, 3}()
const USBS0 = Pin{UCSR0C, 4}()
const UPM00 = Pin{UCSR0C, 5}()
const UPM01 = Pin{UCSR0C, 6}()
const UMSEL00 = Pin{UCSR0C, 7}()
const UMSEL01 = Pin{UCSR0C, 8}()
const UCPHA0 = UCSZ00
const UDORD0 = UCSZ01
export UCPOL0, UCSZ00, UCSZ01, USBS0, UPM00, UPM01, UMSEL00, UMSEL01, UCPHA0, UDORD0

const UBBR0L = Ru8{:UBBR0L}(0xC4)
const UBBR0H = Ru8{:UBBR0H}(0xC5)
const UDR0   = Ru8{:UDR0}(0xC6)

for p in 0:7
    _p = p+1
    ubl = Symbol(:UBBR0L, p)
    ubh = Symbol(:UBBR0H, p)
    udr = Symbol(:UDR0, p)
    @eval begin
        const $ubl = Pin{UBBR0L, $_p}()
        const $udr = Pin{UDR0,   $_p}()
        export $ubl, $udr
    end
    if p < 5
        @eval begin
            const $ubh = Pin{UBBR0H, $_p}()
            export $ubh
        end
    end
end