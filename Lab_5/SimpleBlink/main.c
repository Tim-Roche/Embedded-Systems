#include <msp430.h>

// Author: Brian Harlow
// Class: Introduction to Embedded Systems
// Section: 3
// Date: 25 September 2018
// Microcontroller: MSP430G2553

// Program Description: This program is designed to use interrupts to toggle the state of an LED on a development board with
//                      the MSP430G2553 microcontroller. By using interrupts instead of polling, we are able to put the
//                      microcontroller into low power mode so the system runs more efficiently.
/**
 * main.c
 */
int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    P1SEL &= ~(BIT0|BIT1);      // Sets P1.0 and P1.3 to be GPIO
    P2SEL &= ~(BIT0|BIT1);      // Sets P1.0 and P1.3 to be GPIO
    P1DIR |= BIT0;              // Sets P1.0 to be output
    P1DIR &= ~BIT1;             // Sets P1.1 to be input
    P1REN |= BIT1;              // Pull-up/pull-down resistor enabled for P1.1
    P1OUT |= BIT1;              // Pull-up/pull-down resistor set to pull-down for P1.1
    P1IE |= BIT1;               // Enables interrupt for P1.1
    P1IES &= ~BIT1;             // Set interrupt as rising edge of P1.1
    P1IFG &= ~BIT1;             // Clears the interrupt for P1.1
    _BIS_SR(LPM0_bits + GIE);   // Enter LPM0 and enable global interrupts
    return 0;
}

#pragma vector=PORT1_VECTOR
__interrupt void Port_1(void)   // Runs when S1 (P1.1) is pressed on the rising edge
{
    P1OUT ^= BIT0;              // Toggles the status of P1.0
    P1IFG &= ~BIT1;             // Clears the interrupt for P1.1
}
