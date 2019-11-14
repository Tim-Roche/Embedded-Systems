P1DIR EQU 0x40004C04
P1OUT EQU 0x40004C02
	
P2DIR EQU 0x40004C05
P2OUT EQU 0x40004C03

P1REN EQU 0x40004C06
P2REN EQU 0x40004C07
	
P1IN EQU 0x40004C00
P2IN EQU 0x40004C01
	
upMASK EQU 0x2    //1.1
downMASK EQU 0x10 //1.4
rollMASK EQU 0x40 //1.6

        THUMB
        AREA    |.text|, CODE, READONLY, ALIGN=2
        EXPORT  asm_main

asm_main

	LDR r3,=0
loop
	BL checkUP
	CMP R0, 1
	BNE down
	BL incUp
	
down BL checkDOWN
	 CMP R0, 1
	 BNE roll
	 BL incDOWN
	 
roll BL checkROLL
	 CMP R0, 1
	 BNE loop
	 BL rollOVER
	 B loop


topToZero
	CMP r3, 16
	MOVEQ r3,0
	BX LR

zeroToTop
	CMP r3, 0
	MOVEQ r3, 16
	BX LR

incUP
	ADD r3, r3, 1
	BL topToZero
	BL translate
	BX LR
	
incDOWN
	BL zeroToTop
	SUB r3, r3, 1
	BL translate
	BX LR
	
rollOVER
	CMP r3, 0
    BNE notZ
	BX LR
notZ CMP r3, 8
	BGE rU
rD
	BL incDOWN
	LDR r0, 500
	BL delayMs
	B rollOVER
		
rU
	BL incUP
	LDR r0, 500
	BL delayMs
	B rollOVER
	
	
	BX LR

;r0 is the input
translate
		LDR r2,=TRANSLATOR
		LDRB r1,[r2, r0]
		LDR r2,=P2OUT
		STRB r1, [r2]
		BX LR

;Fix this later
checkUP
        LDR R0, =P1IN
        LDRB R1, [R0]
        TST R1, upMask
        MOVEQ R0, 1
        MOVNE R0, 0
        BX LR

checkDOWN
        LDR R0, =P1IN
        LDRB R1, [R0]
        TST R1, downMASK
        MOVEQ R0, 1
        MOVNE R0, 0
        BX LR

checkROLL
        LDR R0, =P1IN
        LDRB R1, [R0]
        TST R1, rollMASK
        MOVEQ R0, 1
        MOVNE R0, 0
        BX LR



delayMs
L1     SUBS    R0, #1          ; inner loop
       BNE     L1
       BX      LR

		AREA mydata, DATA, READWRITE
TRANSLATOR DCB 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71
		   END