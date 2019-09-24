P1DIR EQU 0x40004C04
P1OUT EQU 0x40004C02
	
P2DIR EQU 0x40004C05
P2OUT EQU 0x40004C03

P1REN EQU 0x40004C06
P2REN EQU 0x40004C07
	
P1IN EQU 0x40004C02
P2IN EQU 0x40004C01
	
redMASK EQU 0x1
greenMASK EQU 0x2
blueMASK EQU 0x4
	
tstMASK EQU 0x2
ackMASK EQU 0x8
flaMASK EQU 0x40
olaMASK EQU 0x80

        THUMB
        AREA    |.text|, CODE, READONLY, ALIGN=2
        EXPORT  asm_main

asm_main
;INPUTS:  P1.1 (TST) 
;         P1.4 (ACK) 
;         P2.6 (FLA) 
;         P2.7 (OLA)
;OUTPUTS: P1.0 RED 
;         P2.1 GREEN 
;         P2.2 BLUE
		; make ALL INPUTS
		
		;Set Inputs
        LDR     R0, =P1DIR      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        BIC     R1, tstMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg
		
	    LDR     R0, =P1DIR      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        BIC     R1, ackMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg
		
		LDR     R0, =P2DIR      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        BIC     R1, flaMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg
		
		LDR     R0, =P2DIR      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        BIC     R1, olaMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg
		
		;Set Outputs
        LDR     R0, =P1DIR      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        ORR     R1, redMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg		

        LDR     R0, =P2DIR      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        ORR     R1, greenMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg	

        LDR     R0, =P2DIR      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        ORR     R1, blueMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg	

		;Set Pull-up Resistors
        LDR     R0, =P1REN      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        ORR     R1, tstMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg
		
	    LDR     R0, =P1REN      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        ORR     R1, ackMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg
		
		LDR     R0, =P2REN      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        ORR     R1, flaMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg
		
		LDR     R0, =P2REN      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        ORR     R1, olaMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg		

		;Set Pull-up Resistors set as outputs
        LDR     R0, =P1OUT      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        ORR     R1, tstMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg
		
	    LDR     R0, =P1OUT      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        ORR     R1, ackMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg
		
		LDR     R0, =P2OUT      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        ORR     R1, flaMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg
		
		LDR     R0, =P2OUT      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
        ORR     R1, olaMASK     ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg	

checkTST
		;INPUTS:  P1.1 (TST) 
		;         P1.4 (ACK) 
		;         P2.6 (FLA) 
		;         P2.7 (OLA)
        LDR     R0,=P1IN      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
		TST     R1, tstMASK
		MOVNE	R0, 1 		
		
		
		
functionB
		BL  offRed
		Bl  offBlue
		BL  onGreen
		
		
		
		
		

green


; This subroutine performs a delay of n ms (for 3 MHz CPU clock). 
; n is the value in R0.
delayMs
L1 		SUBS R0, #1
		BNE L1
		BX LR

        ALIGN 	
        END