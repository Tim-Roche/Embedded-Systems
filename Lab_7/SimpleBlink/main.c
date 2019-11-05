#include <msp430.h>

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    P1SEL |= BIT1;             // Sets P1.0 and P1.1 to be GPIO
    P1DIR |= BIT0;              // Sets P1.0 to be an output
    P1DIR &= ~BIT1;             // Sets P1.1 to be an input

    P1REN |= BIT1;              // Pull-up/pull-down resistor enabled for P1.1
    P1OUT |= BIT1;              // Pull-up/pull-down resistor set to pull-down for P1.1

    //P1IE |= BIT1;               // Enables interrupt for P1.1
    P1IES |= BIT1;              // Set interrupt as falling edge of P1.1
    //P1IFG &= ~BIT1;             // Clears the interrupt for P1.1


    TA0CTL = TASSEL_1 + ID_3 + MC_2 + TACLR + TAIE;
    TA0CCTL0 = CM_3 + CCIS_0 + SCS + CAP + CCIE;
    TA0CCTL2 |= CCIE;
    TA0CCR2 = 4000;             // Sets CCR0 register to value 0x19A
    TA0CCR0 = TA0CCR2;
    _BIS_SR(LPM0_bits + GIE);   // Enter LPM0 and enable global interrupts
    for(;;)
    {}
}

#pragma vector = TIMER0_A1_VECTOR
__interrupt void TIMER0_A1(void)
{
    // Switch TAIV, automatically resets the flags
    switch(TA0IV)
    {
        case 4:                 // Capture/Compare detect for CCR2
            P1OUT ^= BIT0;      // Toggle status of D1
            TA0CCR2 = TA0CCR2 + TA0CCR0;
            TA0CCTL2 &= ~CCIFG;
            break;
    }
}

#pragma vector = TIMER0_A0_VECTOR
__interrupt void TIMER_A0(void)
{
    if(P1IES & BIT1)
    {
        P1IES &= ~BIT1;
        TA0CTL = TASSEL_1 + ID_3 + MC_2 + TACLR + TAIE; //Reset Timer A
    }
    else
    {
        P1IES |= BIT1;
        TA0CTL = TASSEL_1 + ID_3 + MC_2 + TACLR + TAIE; //Reset Timer A
        TA0CCR2 = TA0CCR0;
        P1OUT &= ~BIT0;
    }
}
