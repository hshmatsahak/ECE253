.global _start
_start:
//set up stack pointer in interrupt mode
MOV R0, #0b10010
MSR CPSR, R0
LDR SP, =0x20000

//set up stack pointer in supervisor mode
MOV R0, #0b10011
MSR CPSR, R0
LDR SP, =0x10000

//configure interrupt in interrupt controller
BL CONFIG_GIC

//enable interrupt in I/O device (timer)
LDR R0, =0xFFFEC600
MOV R1, =20000000
STR R1, [R0]
MOV R1, #0b111
STR R1, [R0, #8]

//Enable Interrupt in Processor
MOV R0, #0b00010011
MSR CPSR, R0

// Interrupt Request Handler/ IRQ
// only relevant interrupt in our example here is timer
IRQ_HANDLER:
	PUSH {R0-R5, LR}
	LDR R4, =MPCORR_GIC_CPUIF
	LDR R5, [R4, #ICCIAR]
TIMER_CHECK:
	CMP R5, #29 
	BNE UNKNOWN_INT
	BL TIMER_ISR
	B EXIT_IRQ
UNKNOWN_IRQ:
	B UNKNOWN_IRQ
EXIT_IRQ:
	STR R5, [R4, #ICCEOIR]
	POP {R0-R5, LR}
	SUBS PC, LR, #4
	
// Timer Interrupt Service Routine
TIMER_ISR:
	LDR R0, =0xFFFEC600
	LDR R1, [R0, #12] //load F bit
	STR R1, [R0, #12] //clear F bit
	LDR R0, =LEDR_BASE
	LDR R1, [R0]
	EOR R1, R1, #1
	STR R1, [R0]
	MOV PC, LR
	


