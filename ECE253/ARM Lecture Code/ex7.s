LDR R0, =0xFF200000 //leds
LDR R1, =0xFFFEC600 //timer
// keys= 0xff20 0050
LDR R3, =20000000
STR R3, [R1]
MOV R3, #0x3 // E,A
STR R3, [R1, #8]
MOV R2, #1
LOOP:
    STR R2, [R0]
WAIT:
    LDR R4, [R1, #12]
    CMP R4, #0
    BEQ WAIT
    STR R4, [R1, #12]
    LSL R2, R2, #1
    CMP R2, #0x400
    BNE LOOP
    MOV R2, #1
    B LOOP