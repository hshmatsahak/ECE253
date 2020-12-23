// if number greater than 4 add2 otherwise subtract 2. use 5
.global_start
_start:
    MOV R1, #5
    CMP R1, #4
    BLE NOTTRUE
    ADD R1, R1, #2
    B END
NOTTRUE:
    SUB R1, R1, #2
END:
    B END
    