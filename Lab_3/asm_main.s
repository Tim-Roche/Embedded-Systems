P1DIR EQU 0x40004C04
P1OUT EQU 0x40004C02
	
P2DIR EQU 0x40004C05
P2OUT EQU 0x40004C03

P1REN EQU 0x40004C06
P2REN EQU 0x40004C07
	
P1IN EQU 0x40004C00
P2IN EQU 0x40004C01
	
redMASK EQU 0x1
greenMASK EQU 0x2
blueMASK EQU 0x4
	
tstMASK EQU 0x2
ackMASK EQU 0x10
flaMASK EQU 0x40
olaMASK EQU 0x80

        THUMB
        AREA    |.text|, CODE, READONLY, ALIGN=2
        EXPORT  asm_main

asm_main
;INPUTS:  P1.1 (CMP) 
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
		

    BL      offRed
    BL      offBlue
	BL 		offGreen
loopB
    BL      offRed
    BL      offBlue
    BL      onGreen
	
	;Exit Conditions
	BL checkFLA
	CMP R0, 1
	BEQ loopC
	BL checkTST
	CMP R0, 1
	BEQ loopA
	B loopB

loopA
        BL      offRed
        BL      offBlue
        BL      onGreen
		
		;Exit Conditions
		LDR R3,=40000
		LDR R6,=0
iLoop   BL checkTST
		CMP R0, 1
		BNE loopB
		ADD R6, R6, 1
		CMP R6, R3
		BNE iLoop
		BL xorBlue
		BL xorRed
		LDR R6,=0
		B iLoop		

loopC
        BL      offRed
        BL      offBlue
        BL      offGreen
		LDR R6,=0
		LDR R3,=40000
jLoop   BL checkOLA
		CMP R0, 1
		BEQ loopE
		BL checkFLA
		CMP R0, 1
		BNE loopB
		BL checkACK
		CMP R0, 1
		BEQ loopD
		
		ADD R6, R6, 1
		CMP R6, R3
		BNE jLoop
		BL xorBlue
		LDR R6,=0
		B jLoop				

loopD
        BL      offRed
        BL      offGreen
        BL      onBlue
		
		BL checkOLA
		CMP R0, 1
		BEQ loopE
		BL checkFLA
		CMP R0, 1
		BNE loopC
		B loopD

loopE
        BL      offGreen
        BL      offBlue
		BL 		offRed
		
		LDR R6,=0
		LDR R3,=40000
kLoop	BL checkACK
		CMP R0, 1
		BEQ loopF

		ADD R6, R6, 1
		CMP R6, R3
		BNE kLoop
		BL xorRed
		LDR R6,=0
		B kLoop	

loopF
        BL      offGreen
        BL      offBlue
		BL 		onRed
		
		BL checkOLA
		CMP R0, 1
		BNE loopD
		B loopF

checkTST
		;INPUTS:  P1.1 (CMP) 
		;         P1.4 (ACK) 
		;         P2.6 (FLA) 
		;         P2.7 (OLA)
        LDR     R0,=P1IN      ; load Dir Reg in R1
        LDRB    R1, [R0]	  ; 
		TST     R1, tstMASK
		MOVEQ	R0, 1 	
		MOVNE   R0, 0
		BX LR
		
checkFLA
		;INPUTS:  P1.1 (CMP) 
		;         P1.4 (ACK) 
		;         P2.6 (FLA) 
		;         P2.7 (OLA)
        LDR     R0,=P2IN      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
		TST     R1, flaMASK
		MOVEQ	R0, 1 	
		MOVNE   R0, 0	
		BX LR

checkOLA
        LDR R0, =P2IN
        LDRB R1, [R0]
        TST R1, olaMASK
        MOVEQ R0, 1
        MOVNE R0, 0
        BX LR

checkACK
		;INPUTS:  P1.1 (CMP) 
		;         P1.4 (ACK) 
		;         P2.6 (FLA) 
		;         P2.7 (OLA)
        LDR     R0,=P1IN      ; load Dir Reg in R1
        LDRB    R1, [R0]		; 
		TST     R1, ackMASK
		MOVEQ	R0, 1 	
		MOVNE   R0, 0
		BX LR	



offBlue
        ; turn off blue LED
        LDR     R0, =P2OUT      ; load Output Data Reg in R1
        LDRB    R1, [R0]
        MVN     R2, blueMASK    ; load complement of bit 0 mask
        AND     R1, R2          ; clear bit 0
        STRB    R1, [R0]        ; store back to Output Data Reg
        BX      LR
offRed
         ; turn off red LED
        LDR     R0, =P1OUT      ; load Output Data Reg in R1
        LDRB    R1, [R0]
        MVN     R2, #redMASK    ; load complement of bit 0 mask
        AND     R1, R2          ; clear bit 0
        STRB    R1, [R0]        ; store back to Output Data Reg
        BX      LR
offGreen
         ; turn off green LED
        LDR     R0, =P2OUT      ; load Output Data Reg in R1
        LDRB    R1, [R0]
        MVN     R2, #greenMASK    ; load complement of bit 0 mask
        AND     R1, R2          ; clear bit 0
        STRB    R1, [R0]        ; store back to Output Data Reg
        BX      LR
onBlue
        ; turn on blue LED
        LDR     R0, =P2OUT      ; load Output Data Reg in R1
        LDRB    R1, [R0]
        ORR     R1, #blueMASK         ; set bit 0
        STRB    R1, [R0]        ; store back to Output Data Reg
        BX      LR
onRed 
        ; turn on Red LED
        LDR     R0, =P1OUT      ; load Output Data Reg in R1
        LDRB    R1, [R0]
        ORR     R1, #redMASK         ; set bit 0
        STRB    R1, [R0]        ; store back to Output Data Reg
        BX      LR
onGreen
        ; turn on blue LED
        LDR     R0, =P2OUT      ; load Output Data Reg in R1
        LDRB    R1, [R0]
        ORR     R1, greenMASK         ; set bit 0
        STRB    R1, [R0]        ; store back to Output Data Reg
        BX      LR
xorBlue
        ; turn on blue LED
        LDR     R0, =P2OUT      ; load Output Data Reg in R1
        LDRB    R1, [R0]
        EOR     R1, blueMASK         ; set bit 0
        STRB    R1, [R0]        ; store back to Output Data Reg
        BX      LR		
xorRed 
        ; turn on Red LED
        LDR     R0, =P1OUT      ; load Output Data Reg in R1
        LDRB    R1, [R0]
        EOR     R1, redMASK         ; set bit 0
        STRB    R1, [R0]        ; store back to Output Data Reg
        BX      LR
		
delayMs
L1     SUBS    R0, #1          ; inner loop
       BNE     L1
       BX      LR
       END
	