.data
LIST:
    .word 1,2,3,4
.text
.global_start
_start:
    LDR R5, =LIST
    LDR R2, [R5]
    LDR R3, [R5, #4]
    ADD R2, R2, R3
    LDR R3. [R5. #8]
    ADD R2, R2, R3
    LDR R3, [R5, #12]
    ADD R2, R2, R3
END:
    B END