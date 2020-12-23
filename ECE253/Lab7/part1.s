.global _start
_start:
	LDR R1, = TEST_NUM
	BL COUNT
END:
	B END
COUNT:
	MOV R7, #0
	MOV R8, #0
	LOOP:
		LDR R2, [R1]
		ADD R1, R1, #4
		CMP R2, #-1
		BEQ ENDSUB
		ADD R7, R7, R2
		ADD R8, R8, #1
		B LOOP
ENDSUB:
	MOV PC, LR
