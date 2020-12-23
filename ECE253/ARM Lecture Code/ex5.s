.data
LIST:
    .word 1,2,3,4,5
N:
    .word 5
.text
.global_start
_start:
    LDR R6, =N
    LDR R5, [R6]
    LDR R1, =LIST
    SUB R5, R5, #1 
    LSL R5, R5, #2
    ADD R2, R5, R1
LOOP:
    CMP R1, R2
    BGE END
    LDR R3, [R1]
    LDR R4, [R2]
    STR R4, [R1]
    STR R3, [R2]
    ADD R1, R1, #4
    SUB R2, R2, #4
    B LOOP
END:
    B END
    