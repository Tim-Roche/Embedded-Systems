#include <msp430.h>

int main(void)
{
    P1SEL &= ~BIT0;
    P1DIR |= BIT0;

    ADC12CTL0 = ADC12SHT0_4+ADC12ON;
    ADC12CTL1=ADC12SHP;
    ADC12MCTL0 = ADC12SREF_1+ADC12INCH0;
    P6SEL |= BIT0;
    ADC12IE = BIT0; //enable interrupt
    ADC12CTL0 |= ADC12ENC; //enable conversion
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
    if(ADC12MEM0 > 2048)
    {
        P1OUT |= BIT0;
    }
    else
    {
        P1OUT &= ~BIT0;
    }
}
