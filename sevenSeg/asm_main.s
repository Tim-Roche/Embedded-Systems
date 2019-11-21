;port 1 Pin Direction Register
P1DIR EQU 0x40004C04
; Port 1 pin Output Register	
P1OUT EQU 0x40004C02
; Port 2 Pin Direction Register
P2DIR EQU 0x40004C05
; Port 2 Pin Output Register	
P2OUT EQU 0x40004C03

P4DIR EQU 0x40004C25
; Port 2 Pin Output Register	
P4OUT EQU 0x40004C23

P1REN EQU 0x40004C06
P2REN EQU 0x40004C07
    
;Defining Inputs	
P1IN EQU 0x40004C00
P2IN EQU 0x40004C01
    
upMASK EQU 0x2	;p1.1
downMASK EQU 0x10	;p1.4
rollMASK EQU 0x40	;p1.6
	
;olaMASK EQU 0x80
        THUMB
        AREA    |.text|, CODE, READONLY, ALIGN=2
        EXPORT  asm_main
			
asm_main
	LDR     R0, =P1DIR      ; load Dir Reg in R1
    LDRB    R1, [R0]        ;
    BIC     R1, rollMASK     ; set bit 0
    STRB    R1, [R0]        ; store back to Dir Reg
	
	
	LDR     R0, =P1DIR      ; load Dir Reg in R1
    LDRB    R1, [R0]        ;
    BIC     R1, rollMASK     ; set bit 0
    STRB    R1, [R0]        ; store back to Dir Reg
	
	
	LDR     R0, =P1DIR      ; load Dir Reg in R1
    LDRB    R1, [R0]        ;
    BIC     R1, rollMASK     ; set bit 0
    STRB    R1, [R0]        ; store back to Dir Reg

	LDR     R0, =P1DIR      ; load Dir Reg in R1
    LDRB    R1, [R0]        ;
    BIC     R1, rollMASK     ; set bit 0
    STRB    R1, [R0]        ; store back to Dir Reg
	
	LDR     R0, =P4DIR      ; load Dir Reg in R1
	LDRB    R1, [R0]		; 
	ORR     R1, 0xFF     ; set bit 0
	STRB    R1, [R0]        ; store back to Dir Reg

	LDR     R0, =P1REN      ; load Dir Reg in R1
	LDRB    R1, [R0]		; 
	ORR     R1, upMASK     ; set bit 0
	STRB    R1, [R0]        ; store back to Dir Reg

	LDR     R0, =P1REN      ; load Dir Reg in R1
	LDRB    R1, [R0]		; 
	ORR     R1, downMASK     ; set bit 0
	STRB    R1, [R0]        ; store back to Dir Reg

	LDR     R0, =P1REN      ; load Dir Reg in R1
	LDRB    R1, [R0]		; 
	ORR     R1, rollMASK     ; set bit 0
	STRB    R1, [R0]        ; store back to Dir Reg	
		
	;Set Pull-up Resistors set as outputs
	LDR     R0, =P1OUT      ; load Dir Reg in R1
	LDRB    R1, [R0]		; 
	ORR     R1, upMASK     ; set bit 0
	STRB    R1, [R0]        ; store back to Dir Reg
	
	LDR     R0, =P1OUT      ; load Dir Reg in R1
	LDRB    R1, [R0]		; 
	ORR     R1, downMASK     ; set bit 0
	STRB    R1, [R0]        ; store back to Dir Reg
	
	LDR     R0, =P1OUT      ; load Dir Reg in R1
	LDRB    R1, [R0]		; 
	ORR     R1, rollMASK     ; set bit 0
	STRB    R1, [R0]        ; store back to Dir Reg
	
	LDR r3,=8
	BL translate

;Fix this later
checkUP
		; Getting Pin State
        LDR R0, =P1IN
        LDRB R1, [R0]
        TST R1, upMASK
		BNE checkDOWN
		ADD r3, r3, #1
		BL topToZero
		
upwait  LDR R0, =P1IN
        LDRB R1, [R0]
        TST R1, upMASK
		BEQ upwait
		
		BL translate
		
		LDR R0, =100
		BL delayMs
        B checkDOWN
		
checkDOWN
        LDR R0, =P1IN
        LDRB R1, [R0]
        TST R1, downMASK
		BNE checkROLL
		BL zeroToTop
		SUB r3, r3, #1
		

dwait	LDR R0, =P1IN
        LDRB R1, [R0]
        TST R1, downMASK
		BEQ dwait
		
		BL translate
		LDR R0, =100
		BL delayMs
        B checkROLL
		
	
topToZero
	CMP r3, #16
	MOVEQ r3, 0
	BX LR	;branch with exit to lr
	
zeroToTop
	CMP r3, #0
	MOVEQ r3, #16
	BX LR

incUP
    ADD r3, r3, #1
	BL topToZero
    BL translate
    BX LR
    
incDOWN
	BL zeroToTop
    SUB r3, r3, #1
    BL translate
    BX LR
    
;r0 is the input
translate
        LDR R2,=TRANSLATOR
        LDRB R1,[R2, R3]
        LDR R2,=P4OUT
        STRB R1, [R2]
        BX LR

		
checkROLL
        LDR R0, =P1IN
        LDRB R1, [R0]
        TST R1, rollMASK ;IF R1 is 1, button is NOT being pressed 
		BNE checkUP ;That means 
		;Here if button was pressed
		
roll	CMP r3, #0
		BNE notZ
		B checkUP
notZ 	CMP r3, #8
		BGE rU
rD
		; Down
		BL zeroToTop
		SUB r3, r3, #1
		
		BL translate
		
		LDR R0, =500000
		BL delayMs
		B roll
rU
		; Up
		ADD r3, r3, #1
		BL topToZero
		
		BL translate
		
		LDR R0, =500000
		BL delayMs
		B roll
		
delayMs
L1     SUBS    R0, #1          ; inner loop
       BNE     L1
       BX      LR
	   
        AREA mydata, DATA, READWRITE
		;         0        1      2       3      4        5       6       7       8       9        A      b       c      d        e       f
TRANSLATOR DCB ~(0x3F),~(0x06),~(0x5B),~(0x4F),~(0x66),~(0x6D),~(0x7D),~(0x07),~(0x7F),~(0x6F),~(0x77),~(0x7C),~(0x39),~(0x5E),~(0x79),~(0x71)
;~(0x3F),~(0x30),~(0x6D),~(0x79),~(0x66),~(0x6D),~(0x7D),~(0x07),~(0x7F),~(0x6F),~(0x77),~(0x7C),~(0x39),~(0x5E),~(0x79),~(0x71)
           END