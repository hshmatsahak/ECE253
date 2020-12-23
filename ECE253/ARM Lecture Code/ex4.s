.global_start
_start:
    MOV R1, 0x17
    MOV R2, #0
LOOP:
    CMP R1, #0
    BLT END
    AND R3, R1, #1
    CMP R3, #1
    BNE NOTTRUE
    ADD R2, R2, #1
NOTTRUE:
    LSR R1, R1, #1
    B LOOP
END:
    B END
