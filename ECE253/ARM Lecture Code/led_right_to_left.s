.text
.global _start
_start:
LDR R0, =0xFFFEC600 //timer
LDR R1, =0xFF200000 //leds
LDR R3, =20000000
STR R3, [R0]
MOV R3, #0b11
STR R3, [R0, #8]
MOV R4, #1
LOOP:	
	STR R4, [R1] 
WAIT:	
	LDR R3, [R0, #12]
	CMP R3, #0
	BEQ WAIT
	STR R3, [R0, #12]
	LSL R4, R4, #1
	CMP R4, #0x400
	BNE LOOP
	MOV R4, #1
	B LOOP