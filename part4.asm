; xzho684

; To 16 bit floating point.
; Take a signed integer in the range -511 to +511.
; Print the value as a 16 bit floating point value as in Assignment 1.
; This program must use subroutines.

; When calling a subroutine, r0 is assumed to be changed.
; Any other registers used by the subroutine should be saved and restored.
; (not absolutely necessary but it is good style)

		.orig	x3000

start		jsr	get_number
		jsr	convert_number	; r0 returns xffff if invalid, otherwise the converted integer
		add	r1, r0, #1
		brz	start		; try again if invalid
		jsr	print_binary	; prints r0 as binary
		jsr	convert_float 	; result in r0
		jsr	print_binary
		halt

get_number	ST	R7, ret_address
		AND	R0, R0, #0	; R0 is for integer
		AND	R6, R6, #0	; R6 is for neg integer
		AND	R4, R4, #0	; R4 holds max buffer size
		LD	R4, max_size
		LEA	R3, buffer	; R3 holds buffer address

clear		STR	R0, R3, #0	; clear buffer
		ADD	R3, R3, #1
		ADD	R4, R4, #-1	; R4 is buffer size count
		BRp	clear

		AND	R4, R4, #0
		LEA	R3, buffer	; R3 is buffer address
		LEA	R0, prompt
		PUTS
		
loop		GETC
		OUT
		ADD	R1, R0, #-10	; (decimal) 10 is newline
		BRz	break
		STR	R0, R3, #0	; R0 is ascii of user input
		ADD	R3, R3, #1	; point to next buffer position
		BRnzp	loop

break		LD	R7, ret_address
		AND 	R4, R4, #0
		ST	R4, ret_address
		RET

convert_number	ST	R7, ret_address	
		AND 	R7, R7, #0	; R7 is used for checking special case for just sign input
		AND	R0, R0, #0	; R0 is for integer
		LEA	R3, buffer	; R3 holds pointer to buffer

		LD	R2, buffer	; R2 holds binary data		
		LD 	R4, plus	; R4 holds ascii +
		NOT 	R4, R4
		ADD	R4, R4, #1
		ADD	R1, R2, R4	; will be zero if plus		
		BRz	check	
		
		LD 	R4, minus	; R4 holds ascii -
		NOT 	R4, R4
		ADD	R4, R4, #1
		ADD	R1, R2, R4	; will be zero if minus
		BRz	check

invalid_input	LEA	R0, invalid
		PUTS
		LD 	R0, bad_input
		LD	R7, ret_address
		RET

negate		NOT	R6, R0		; converts to its two's complement negative
		ADD 	R6, R6, #1	; don't need special case as -0 is desired to be 0
		RET		

check2		ADD	R7, R7, #0
		BRz	invalid_input
		LD	R7, ret_address
		LD	R5, range	; R5 is bound
		ADD	R5, R5,	R0
		BRp	invalid_input
		
		LD	R2, buffer	; R2 holds sign
		LD 	R4, minus	; R4 is checks with 1st char
		NOT 	R4, R4
		AND	R1, R2, R4	; will be zero if minus
		BRz	negate
		
		RET

check		ADD	R3, R3, #1	; R3 holds address of next char in buffer
		LDR	R1, R3, #0	; R1 will hold binary data value
		BRz	check2
		LD 	R4, neg_ascii
		ADD 	R1, R1, R4
		BRn	invalid_input	; less than 0
		ADD	R4, R1, #-9
		BRp	invalid_input	; more than 9
		
		ADD 	R2, R0, R0  	; value = value x 10
		ADD 	R4, R2, R2
		ADD 	R6, R4, R4
		ADD 	R0, R6, R2

		ADD	R0, R0, R1	; R0 is final integer
		ADD	R6, R0, #0

		LD	R5, range	; R5 is -511
		ADD	R5, R5, R6	; check range
		BRp	invalid_input	
		
		ADD	R7, R7, #-1	; R7 used for single sign case
		BR check

					; R0 and R6 both will hold the final binary to print
					; R7 only used for returns
print_binary	ST	R7, ret_address	
		ADD	R0, R6, #0	

start_print	LEA	R4, masks	; R4 holds masks address
		AND	R3, R3, #0	; R3 is count
		ADD	R3, R3, #15
		;AND	R1, R1, #0				;change made here
		ADD	R1, R0, #0	; R1 is temp for R0
		
print_loop	;AND	R0, R0, #0	; R0 cleared		;change made here
		ADD	R0, R1, #0	; R0 stores integer
		LDR	R5, R4, #0	; R5 holds masks data
		AND	R0, R0, R5
		BRz	print_zero
		BR	print_one

continue	OUT
		LD	R0, space
		OUT
		ADD	R4, R4, #1
		ADD	R3, R3, #-1				
		BRzp	print_loop
		LD	R0, new_line
		OUT

		AND 	R0, R0, #0
		ADD	R0, R6, #0
		LD	R7, ret_address
		RET

print_zero	LD	R0, ascii0
		BR 	continue

print_one	LD	R0, ascii1
		BR 	continue

unegate		NOT	R1, R1
		ADD 	R1, R1, #1
		NOT	R0, R0
		ADD 	R0, R0, #1
		BR 	start_float

convert_float	ST	R7, ret_address	; clear all except R0, R6, R7
		;AND 	R1, R1, #0		;made changes
		AND 	R2, R2, #0
		AND 	R3, R3, #0
		;AND 	R4, R4, #0
		AND 	R5, R5, #0
		
		ADD	R1, R0, #0	; will be zero if +-0 case
		BRz	special_case	; treat as positive
		
		ADD 	R0, R0, #0  	; test if negative
		BRn	unegate

start_float	ADD 	R2, R2, #15	; R2 is count
		BRzp 	sig_loop
		
sig_loop	ADD 	R2, R2, #-1	
		ADD 	R1, R1, R1	; left shift
		BRp 	sig_loop
		
		ADD	R4, R2, #0	; R4 is count b4 bias for masking r0 pre
		ADD	R2, R2, #7	; bias-7

		ADD	R3, R3, #11	; R3 is count
exp_shift	ADD	R2, R2, R2
		ADD	R3, R3, #-1
		BRp	exp_shift
		
		ADD	R5, R2, #0	; R5 is final float
		LEA	R1, manti_masks	; remember 11 - (first occurrence) is left shifs for manti	
					

		ADD	R1, R1, R4
		LDR	R1, R1, #0	; R1 now holds correct mask

		AND	R0, R0, R1	; masked R0 now make shifts
		AND 	R2, R2, #0
		ADD	R2, R2, #11	; R2 is count for shifts
		NOT	R4, R4							
		ADD	R4, R4, #1	; R4 is not -(first occurrence)	
		ADD	R2, R2, R4

manti_shift	ADD 	R0, R0, R0
		ADD	R2, R2, #-1
		BRp	manti_shift

		ADD	R5, R5, R0	; check for neg sign
		
		LD	R2, buffer	; R2 holds sign
		LD 	R4, minus	; R4 is checks with 1st char
		NOT 	R4, R4
		AND	R2, R2, R4	; will be zero if minus
		BRz	manti_negate

special_case	LD	R7, ret_address
		AND 	R6, R6, #0
		ADD	R6, R5, #0
		RET

manti_negate	LD	R1, is_neg	; OR R1 and R5
		NOT	R1, R1
		NOT	R5, R5
		AND 	R5, R5, R1
		NOT	R5, R5
		BR	special_case


plus		.fill	x2B
minus		.fill	x2D
range		.fill	b1111111000000001 ; -511
ret_address	.blkw	1
bad_input	.fill	xffff
ascii0  	.fill 	x30
ascii1  	.fill 	x31
space		.fill 	x20
new_line	.fill	xA
neg_ascii	.fill	b1111111111010000 ; this is ((NOT x30) + 1)
is_neg		.fill	b1000000000000000 


masks   	.fill 	b1000000000000000
		.fill 	b0100000000000000
        	.fill 	b0010000000000000
        	.fill 	b0001000000000000
        	.fill 	b0000100000000000
        	.fill	b0000010000000000
        	.fill 	b0000001000000000
        	.fill 	b0000000100000000
		.fill 	b0000000010000000
		.fill 	b0000000001000000
		.fill 	b0000000000100000
		.fill	b0000000000010000
		.fill 	b0000000000001000
		.fill	b0000000000000100
		.fill 	b0000000000000010
		.fill	b0000000000000001

manti_masks   	.fill 	b0000000000000000
		.fill 	b0000000000000001
        	.fill 	b0000000000000011
        	.fill 	b0000000000000111
        	.fill 	b0000000000001111
        	.fill	b0000000000011111
        	.fill 	b0000000000111111
        	.fill 	b0000000001111111
		.fill 	b0000000011111111

invalid		.stringz "The input is invalid.\n"
prompt		.stringz "Enter an integer between -511 and +511: "
max_size	.fill	b0000000001010000 ; 80
buffer		.blkw	80		; buffer size

		.END