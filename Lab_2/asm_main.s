P1DIR EQU 0x40004C04
P1OUT EQU 0x40004C02

P2DIR EQU 0x40004C05
P2OUT EQU 0x40004C03

        THUMB
        AREA    |.text|, CODE, READONLY, ALIGN=2
        EXPORT  asm_main

asm_main
        ; make P1.0 an output pin
        LDR     R0, =P1DIR      ; load Dir Reg in R1
        LDRB    R1, [R0]
        ORR     R1, #1          ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg
		
		; make P2.(0-2 outpus)
        LDR     R0, =P2DIR      ; load Dir Reg in R1
        LDRB    R1, [R0]
        ORR     R1, #7          ; set bit 0
        STRB    R1, [R0]        ; store back to Dir Reg
		
		; Set P1 and P2 outputs to be 0
		LDR 	R0,=P1OUT
		MOV 	R2, #0 
		STRB 	R2, [R0]
		LDR 	R0,=P2OUT
		STRB 	R2, [R0]
		
loop
		;RED led (p1.0) on!
        LDR     R0, =P1OUT      ; load Output Data Reg in R1
        LDRB    R1, [R0]
        ORR     R1, #1          ; set bit 0
        STRB    R1, [R0]        ; store back to Output Data Reg
		
        ; delay for 0.5 second
        LDR R0, =500000
        BL      delayMs

		;RED led (p1.0) off!
        LDR     R0, =P1OUT      ; load Output Data Reg in R1
        LDRB    R1, [R0]
        MVN     R2, #1          ; load complement of bit 0 mask
        AND     R1, R2          ; clear bit 0
        STRB    R1, [R0]        ; store back to Output Data Reg
		
		;RED led (p2.0) on!
        LDR     R0, =P2OUT      ; load Output Data Reg in R1
        LDRB    R1, [R0]
        ORR     R1, #1          ; set bit 0
        STRB    R1, [R0]        ; store back to Output Data Reg
		
		; delay for 0.5 second
        LDR R0, =500000
        BL      delayMs
		
		;GREEN led (p2.1) on!
        LDR     R0, =P2OUT      ; load Output Data Reg in R1
        LDRB    R1, [R0]
        ORR     R1, #2          ; set bit 0
        STRB    R1, [R0]        ; store back to Output Data Reg
		
        ; delay for 0.5 second
        LDR R0, =500000
        BL       delayMs

		;BLUE led (p2.2) on!
        LDR     R0, =P2OUT      ; load Output Data Reg in R1
        LDRB    R1, [R0]
        ORR     R1, #4          ; set bit 0
        STRB    R1, [R0]        ; store back to Output Data Reg	
		
        ; delay for 0.5 second
        LDR R0, =500000
        BL       delayMs	

		;BLUE led (p2.1) off!
        LDR     R0, =P2OUT      ; load Output Data Reg in R1
        LDRB    R1, [R0]
        MVN     R2, #7         ; load complement of bit 0 mask
        AND     R1, R2          ; clear bit 0
        STRB    R1, [R0]        ; store back to Output Data Reg

        B       loop	; repeat the loop


; This subroutine performs a delay of n ms (for 3 MHz CPU clock). 
; n is the value in R0.
delayMs
L1 		SUBS R0, #1
		BNE L1
		BX LR

        ALIGN 	
        END