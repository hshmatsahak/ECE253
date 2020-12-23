.text
.global _start
_start:
LOOP:
LDR R0, =0xFF200000 //LED
LDR R1, =0xFF200040 //SW
LDR R2, [R1]
MOV R3, R2
AND R2, R2, #0xF
LSR R3, R3, #4
AND R3, R3, #0xF
ADD R3, R3, R2
STR R3, [R0]
B LOOP


