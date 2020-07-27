		; Assembler uses is VASM. Can be found at http://sun.hasenbraten.de/vasm/
		
		.include system_defs.asm	; Import the system defines

		.org ROM_BOTTOM				; Used to trick the assemebler to generate full rom image
		nop			
		.org CODE_START

reset_handler:
		cli 			; Enable interrupts.	
		ldx #$7f 		; Initialise the stack pointer inside 6532
		txs				; Initialise the the hardware.
		jmp main

irq_handler:
		sei				; Diable further interrupts.
		lda #32			; Reset the interrupt period.
		sta $21e
		jsr tic			; Do port output.
		cli
		rti				; End of IRQ.

main:					; Just configure ports and first interrupt timer value.
		lda #$ff
		sta $21f
		lda #$ff
		sta $201
		sta $203
		ldx #0			; Initial port output value.
cycle:					; Loop waiting for interrupt.
		nop
		jmp cycle

tic:					; Ouput incremental output value.
		txa
		sta $200
		sta $202
		inx		
		rts


nmi_handler:			; Do nothing wiht NMI
		rti

vectors:				; Required vectors for 6502
		.org $FFFA
		.word nmi_handler
		.word reset_handler
		.word irq_handler
		
		
