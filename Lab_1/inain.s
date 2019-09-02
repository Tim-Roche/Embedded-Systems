	AREA program, CODE, READONLY
	EXPORT main
	ENTRY 
main
	MOV r0, #0
	MOV r1, #1
	MOV r2, #2
	MOV r3, #3
	B main
	END