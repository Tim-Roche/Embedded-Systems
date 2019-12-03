#include <msp430.h>
// Current sensor conversion example
// Input voltage has range 0-2.5V, which corresponds to 0 to 1A.
unsigned int in_value;

void my_wait (unsigned char my_time);
void my_wait (unsigned char my_time)
{
    int j, k, l;
    for (j=0; j<my_time; j++) //While j is less than my_time
    {
        for (k=0; k<255; k++) //Loop internally by 255 to increase delay time
        {
            l++;
        }
    }
}

int main(void)
{

    P1SEL &= ~BIT0;
    P4SEL |= BIT4 + BIT5;
    P1DIR |= BIT0;

    P1OUT &= ~BIT0;
    REFCTL0 &= ~REFMSTR;
    ADC12CTL0 = ADC12SHT0_9 | ADC12REFON | ADC12REF2_5V | ADC12ON;
    ADC12CTL1 = ADC12SHP;
    ADC12MCTL0 = ADC12SREF_1 | ADC12INCH_0;
    P6SEL |= BIT0;

    UCA1CTL1 |= UCSWRST;
    UCA1BR0 = 8;
    UCA1BR1 = 0;
    UCA1CTL1 |= UCSSEL_2;
    UCA1MCTL |= UCBRS_6;


    ADC12IE = BIT0; //enable interrupt
    ADC12CTL0 |= ADC12ENC;
    ADC12CTL0 &= ~ADC12SC;
    UCA1CTL1 &= ~UCSWRST;


    while (1)
    {
        while(!(UCA1IFG & UCTXIFG));
        UCA1TXBUF = 12;//ADC12MEM0 & 0x0FFF;
        my_wait(50);
        ADC12CTL0 |= ADC12SC; // Start conversion
        __bis_SR_register(LPM0_bits + GIE);
        __no_operation(); // SET BREAKPOINT HERE
    }
}

#pragma vector = ADC12_VECTOR
__interrupt void ADC12_ISR(void)
{

    unsigned char string[4];
    //unsigned int value = ADC12MEM0 & 0x0F;
    unsigned int value = 10;
    int i;
    for (i = 2; i >= 0; i--)
    {
    unsigned int var = value & 0x0F;
    value >>= 4;
    if (var <= 9) // 0..9
    string[i] = var + 0x30; // place ascii code of var
    else // A..F
    string[i] = var + 0x41 - 10;
    }
    string[3] = '\0';

    while(!(UCA1IFG & UCTXIFG));
    UCA1TXBUF = *string;//ADC12MEM0 & 0x0FFF;
}
/*
int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;
    P4SEL |= BIT4 + BIT5;

    UCA1CTL1 |= UCSWRST;
    UCA1BR0 = 8;
    UCA1BR1 = 0;
    UCA1CTL1 |= UCSSEL_2;
    UCA1MCTL |= UCBRS_6;
    UCA1CTL1 &= ~UCSWRST;
    UCA1IE   |= UCRXIE;
    __bis_SR_register(LPM0_bits + GIE);
}

#pragma vector = USCI_A1_VECTOR
__interrupt void USCI_ISR(void)
{
    switch(_even_in_range(UCA1IV,4))
    {
        case 0: break;
        case 2:
            while(!(UCA1IFG & UCTXIFG));
            UCA1TXBUF = UCA1RXBUF;
            break;
        case 4: break;
        default: break;
    }
}
*/
