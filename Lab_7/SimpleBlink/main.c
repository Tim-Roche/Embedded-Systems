#include <msp430.h>

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    P1SEL |= BIT1;             // Sets P1.0 and P1.1 to be GPIO
    P1DIR |= BIT0;              // Sets P1.0 to be an output
    P1DIR &= ~BIT1;             // Sets P1.1 to be an input

    P1REN |= BIT1;              // Pull-up/pull-down
    //P1IE |= BIT1;               // Enables interrupt fresistor enabled for P1.1
    P1OUT |= BIT1;              // Pull-up/pull-down resistor set to pull-down for P1.1 or P1.1
    P1IES |= BIT1;              // Set interrupt as

    falling edge of P1.1
    //P1IFG &= ~BIT1;             // Clears the interrupt for P1.1

    //ADC Setup
    REFCTL0 &= ~REFMSTR;
    ADC12CTL0 = ADC12SHT0_4+ADC12REFON+ADC12REFON2_5V+ADC12ON;
    ADC12CTL1=ADC12SHP;
    ADC12MCTL0 = ADC12SREF_1+ADC12INCH0;
    P6SEL |= 0x01;
    ADC12IE = 0x01; //enable interrupt
    ADC12CTL0 |= ADC12ENC; //enable conversion

    TA0CTL = TASSEL_1 + ID_3 + MC_2 + TACLR + TAIE;
    TA0CCTL0 = CM_3 + CCIS_0 + SCS + CAP + CCIE;
    TA0CCTL2 |= CCIE;
    TA0CCR2 = 0;             // Sets CCR0 register to value 0x19A
    TA0CCR0 = 4095;

    for(;;)
    {
        ADC12CTL0 |= ADC12SC; // Start conversion
        _BIS_SR(LPM0_bits + GIE);
        __no_operation(); // SET BREAKPOINT HERE
    }
}

#pragma vector = ADC12_VECTOR
__interrupt void ADC12_ISR(void)
{
    TA0CCR1 += 4095 - ADC12MEM0;
}
