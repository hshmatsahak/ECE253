.global _start
_start:
    LDR SP, =0x10000
    LDR R5, =LIST
    LDR R1, [R5] // stores number of numbers to sort
    SUB R1, R1, #1
    ADD R5, R5, #4
    MOV R6, #0 //outerloop count
    MOV R7, #0 //innerloop count
LOOP:
    LDR R5, =LIST
    ADD R5, R5, #4
    CMP R6, R1
    BEQ END
    INNER:
        MOV R0, R5
	BL SWAP
        ADD R5, R5, #4
        ADD R7, R7, #1
        CMP R7, R1
        BLT INNER
    ADD R6, R6, #1
    MOV R7, #0
    B LOOP
END:
    B END

.global SWAP
SWAP:
    LDR R2, [R0]
    LDR R3, [R0, #4]
    CMP R2, R3
    BLE NOSWAP
    STR R2, [R0, #4]
    STR R3, [R0]
    MOV R0, #1
    MOV PC, LR
NOSWAP:
    MOV R0, #0
    MOV PC, LR
