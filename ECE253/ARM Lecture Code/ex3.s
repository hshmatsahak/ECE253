/*
int j; int i = 0;
for j=5; j>0; j--
    i = i+2
while(1)
;
 */
.global_start
_start:
    MOV R1, #5
    MOV R2, #0
LOOP:
    CMP R1, #0
    BEQ END
    ADD R2, R2, #2
    SUB R1, R1, #1
    B LOOP
END:
    B END
