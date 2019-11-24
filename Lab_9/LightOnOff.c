#include <msp430.h>
// Current sensor conversion example
// Input voltage has range 0-2.5V, which corresponds to 0 to 1A.
unsigned int in_value;

int main(void)
{
    P1SEL &= ~BIT0;
    P1DIR |= BIT0;

    P1OUT &= ~BIT0;
    /* ***** Core configuration ***** */

    // Reset REFMSTR to enable control of reference voltages by ADC12
    REFCTL0 &= ~REFMSTR;

    /*
     * Initialize control register ADC12CTL0
     * STH0x   = 9 => 384 clock cycles; MSC = 0 => no multisample mode
     * REF2_5V = 1 => Reference is 2.5V, REFON = 1 => Use internel reference generator
     * ADC12ON = 1 => Turn on ADC12
     */
    ADC12CTL0 = ADC12SHT0_9 | ADC12REFON | ADC12REF2_5V | ADC12ON;

    /*
     * Initialize control register ADC12CTL1
     * STARTADDx = 0 => Start conversion at ADC12MEM0
     * SHSx      = 0 => Conversion trigger:  Start when ADC12SC is set to 1
     * SHP       = 1 => SAMPCON sourced from sampling timer (default)
     * ISSH      = 0 => Input signal not inverted
     * SSEL      = 0 => ADC12clock = ADC12OSC (~5 MHz)
     * DIVx      = 0 => Divide ADC12CLK by 1
     * CONSEQx   = 0 => Single channel, single conversion mode
     */
    ADC12CTL1 = ADC12SHP;

    /* ***** Channel configuration ***** */

    // Set conversion memory control register ADC12MCTL0
    // SREF = 001b => Voltage refs:
    // EOS  =   0  => End of sequence not set (not a multi-channel conversion, so ignore)
    ADC12MCTL0 = ADC12SREF_1 | ADC12INCH_0;

    // Set P6.0 to FUNCTION mode
    // This connects the physical pin P6.0/A0 to the ADC input A0
    P6SEL |= BIT0;

    ADC12IE = BIT0; //enable interrupt
    // Enable the ADC.  This means we are done configuring it,
    // so we can start the conversion.
    ADC12CTL0 |= ADC12ENC;
    // Clear the start bit (as a precaution)
    ADC12CTL0 &= ~ADC12SC;

    while (1)
    {
        ADC12CTL0 |= ADC12SC; // Start conversion
        __bis_SR_register(LPM0_bits + GIE);
        __no_operation(); // SET BREAKPOINT HERE
    }
}

#pragma vector = ADC12_VECTOR
__interrupt void ADC12_ISR(void)
{
    in_value = ADC12MEM0 & 0x0FFF;
    if(in_value > 3700)
    {
        P1OUT |= BIT0;
    }
    else
    {
        P1OUT &= ~BIT0;
    }
}
