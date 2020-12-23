// set up stack pointer in IRQ mode
MOV R1, #0b10010
MSR CPSR, R1
LDR SP, =0x20000

// set up stack pointer in Supervisor mode
MOV R1, #0b10011
MSR CPSR, R1
LDR SP, =0x10000

// configure interrupts in interrupt controller
BL CONFIG_GIC

// enable interrupt in I/O device(keys)
LDR R1, =0xFF200050
MOV R0, #0b1000
STR R0, [R1, #8]

// Enabler interrupt in processor
MOV R0, #0b00010011
MSR CPSR, R0

// Interrupt Request Handler
// checks which device caused interrupt, and branches to corresponding service routine handler
IRQ_HANDLER:
	PUSH {R0-R5, LR}
	LDR R4, =MPCORE_GIC_CPUIF
	LDR R5, [R4, #ICCIAR]
KEYS_CHECK:
	CMP R5, #73
	BNE UNKNOWN_INT
	BL KEYS_ISR
	B EXIT_IRQ
UNKNOWN_INT:
	B UNKNOWN_INT
EXIT_IRQ:
	STR R5, [R4, #ICCEOIR]
	POP {R0-R5, LR}
	SUBS PC, LR, #4

// Interrupt service routine for key press
KEY_ISR:
	LDR R0, =KEY_BASE
	LDR R1, [R0, #0xC] // load edge capture bit
	STR R1, [R0, #0xC] //clear interrupt
CH_KEY3:
	CMP R1, #0b1000
	BNE END_KEY_ISR
	LDR R1, =LEDR_BASE
	LDR R0, [R1]
	EOR R0, R0, #1
	STR R0, [R1]
END_KEY_ISR:
	MOV PC, LR
	
	
	
	
	