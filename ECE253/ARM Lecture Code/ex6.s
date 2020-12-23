// Sw[0:3] + SW[7:4]
.text
.global_start
_start:
    LDR R0, =0xFF200000
    LDR R1, =0xFF200040
LOOP:
    LDR R2, [R1]
    MOV R3, R2
    AND R2, R2, #0xF
    LSR R3, R3, #4
    AND R3, R3, #0xF
    ADD R2, R2, R3
    STR R2, [R0]
    B LOOP
    