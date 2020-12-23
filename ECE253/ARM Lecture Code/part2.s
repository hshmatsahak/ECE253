LDR R0, =0xFF200000 //leds
LDR R1, =0xFFFEC600 //timer
LDR R2, =0xFF200050 //KEYS
LDR R3, =49999999
STR R3, [R1]
MOV R3, #0x3 // enable, autoreload
STR R3, [R1, #8]
LDR R4, =0x0201
MOV R7, #0
LOOP:
    STR R4, [R0]
WAITFORPRESS:
    LDR R5, [R2]
    CMP R5, #0
    BNE WAITFORRELEASE
DELAY:
    LDR R4, [R1, #12]
    CMP R4, #0
    BEQ WAITFORPRESS
    STR R4, [R1, #12]
    CMP R7, #0 //R7=0 --> TOWARDS
    BNE AWAY
TOWARDS:
    CMP R4, #0x0030
    BEQ AWAY
    MOV R7, #0
    AND R8, R4, #0x03E0
    LSR R8, R8, #1
    AND R9, R9, #0x001F
    LSL R9, R9, #1
    ADD R4, R8, R9
    B LOOP
AWAY:
    CMP R4, #0x0201
    BEQ TOWARDS
    MOV R7, #1
    AND R8, R8, #0x03E0
    LSL R8, R8, #1
    AND R9, R9, #0x001F
    LSR R9, R9, #1
    ADD R4, R8, R9
    B LOOP
WAITFORRELEASE:
    LDR R5, [R2]
    CMP R5, #0
    BNE WAITFORRELEASE
STALLRELEASED:
    LDR R5, [R2]
    CMP R5, #0
    BEQ STALL
STALLPRESSED:
    LDR R5, [R2]
    CMP R5, #0
    BNE STALLPRESSED
    B LOOP




