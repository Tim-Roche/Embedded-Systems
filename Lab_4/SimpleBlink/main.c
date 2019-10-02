//#include <msp430.h>
//Simple Blink
/*int main(void)
{
  WDTCTL = WDTPW + WDTHOLD;                 // Stop watchdog timer
  P1DIR |= 0x01;                            // Set P1.0 as an output
  //P1OUT = 0x00;

  for (;;)
  {
    volatile unsigned int i;

    P1OUT ^= 0x01;                          // Toggle P1.0 using exclusive-OR

    i = 50000;                              // Delay
    do (i--);
    while (i != 0);
  }
}*/

/*
#include <msp430.h>
int main(void)
{
  WDTCTL = WDTPW + WDTHOLD;                 // Stop watchdog timer
  P1DIR |= 0x41;                            // Set P1.0 and P1.6 to output direction
  P4DIR |= BIT7;

  for (;;)
  {
    volatile unsigned int i;
    for(i = 0; i<=50000; i++)
    {
        if((i % 2000) == 0)
        {
            P4OUT ^= BIT7;      // Toggle P1.6 using exclusive-OR
        }

        if((i % 1000) == 0)
        {
            P1OUT ^= 0x01;      // Toggle P1.0 using exclusive-OR
        }
    }
  }
}
*/

#include <msp430.h>


/**
 * File: main.c
 * Author: Will Cronin
 * Date Created: September 12th 2018
 * Date of Last Revision: September 19th 2018
 * Board Used: MSP430G2553
 */
//#include <msp430.h>

//Button Blink
/**
 * main.c
 * MSP430f5529
 */
/*
int main(void)
{
    int j;
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    P1SEL = 0;
    P2SEL = 0;
    P1DIR |= BIT0; //Set port 1.0 as output (LED)
    P2DIR &= ~BIT1; //Set port 2.1 as input (Button)

    P2REN |= BIT1; //enable pull up resistor
    P2OUT |= BIT1;
    P1OUT &= ~(BIT0);

    while(1)
    {
        j = P2IN & BIT1;
        if(j != 2)
        {
            P1OUT ^= 0x01; // Blink LED
        }
        else
        {
            P1OUT &= ~(BIT0);
        }
    }
}
*/

#include <msp430.h>
int main(void)
{
    int j;
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    P1SEL = 0;
    P2SEL = 0;
    P1DIR |= BIT4; //Set port 1.4
    P1DIR |= BIT5; //Set port 1.5

    P2REN |= BIT1; //enable pull up resistor
    P2OUT |= BIT1;
    P1OUT &= ~(BIT0);

    P1OUT &= ~BIT4;
    P1OUT &= ~BIT5;
    volatile unsigned int i = 0;
    while(1)
    {

        j = P2IN&BIT1;
        while(j == 0)
        {
            if((i % 1000) == 0)
            {
                P1OUT ^= BIT4;      // Toggle P1.0 using exclusive-OR
                P1OUT ^= BIT5;
                i=0;
            }
            j = P2IN&BIT1;
            i++;
        }
        P1OUT &= ~BIT4;
        P1OUT &= ~BIT5;
    }
}
