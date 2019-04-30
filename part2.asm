		; xzho684

		.orig	0x3000

start		AND	R6, R6, #0	; R6 is for integer 
		AND	R4, R4, #0	; R4 is used in clear to clean buffer
		LD	R4, max_size	; R4 holds size of buffer
		LEA	R3, buffer	; R3 used to clear buffer 

clear		STR	R6, R3, #0	; clears buffer
		ADD	R3, R3, #1
		ADD	R4, R4, #-1	; R4 is buffer size count
		BRp	clear
		
		AND	R3, R3, #0
		AND	R4, R4, #0
		LEA	R2, buffer	; R2 is buffer address
		LEA	R0, prompt
		PUTS

loop		GETC
		OUT
		ADD	R1, R0, #-10	; (decimal) 10 is newline
		BRz	check1
		STR	R0, R2, #0	; R0 is ascii of user input store into buffer which is R2
		ADD	R2, R2, #1	; point to next buffer position
		BRnzp	loop

check1		AND	R5, R5, #0	; R5 is special case for just sign input	

		LEA	R2, buffer	; R2 holds pointer to buffer
		LD 	R4, plus	; R4 is checks with 1st char
		NOT 	R4, R4
		ADD	R4, R4, #1
		LD	R3, buffer	; R3 points to first char in buffer
		ADD	R1, R3, R4	; will be zero if plus sign
		BRz	check2

		LD 	R4, minus	; R4 is checks with 1st char
		NOT 	R4, R4
		ADD	R4, R4, #1
		ADD	R1, R3, R4	; will be zero if minus sign
		BRz	check2

invalid_input	LEA 	R0, invalid
		PUTS
		BR	start

check2		ADD	R2, R2, #1	; R2 holds address of buffer add 1 to skip sign
		LDR	R1, R2, #0	; R1 will hold binary data value of current digit
		BRz	output 
		LD 	R7, ascii
		ADD 	R1, R1, R7
		BRn	invalid_input	; less than 0
		ADD	R5, R1, #-9
		BRp	invalid_input	; more than 9
		
		ADD 	R3, R6, R6  	; value = value x 10
		ADD 	R4, R3, R3
		ADD 	R6, R4, R4
		ADD 	R6, R6, R3

		ADD	R6, R6, R1	; R6 is final integer

		LD	R5, range	; R5 is -511
		ADD	R5, R5, R6	; check range
		BRp	invalid_input	
		ADD	R5, R5, #-1
		BR	check2

output		ADD	R5, R5, #0	; check for just single sign input
		BRz	invalid_input
		LD	R5, range	; range of valid
		ADD	R5, R5,	R6	; check if in range
		BRnz	valid
		LEA 	R0, invalid
		PUTS
		BR	start

valid		LD	R2, buffer	; R2 holds sign
		LD 	R4, minus	; R4 is checks with 1st char
		NOT 	R4, R4
		ADD	R4, R4, #1
		ADD	R2, R2, R4	; check sign type
		BRz	negate		; will negate if - sign

		LD  	R0, ascii0	; else do nothing
		OUT
		LD  	R0, space
		OUT
		BR	goprint

negate		NOT	R6, R6		; converts to its two's complement negative
		ADD 	R6, R6, #1
		BRZ	specialcase	; case for -0
		LD  	R0, ascii1
		OUT
		LD  	R0, space
		OUT
		BR	goprint

specialcase	LD  	R0, ascii0
		OUT
		LD  	R0, space
		OUT

goprint		AND 	R4, R4, #0   	; clears the register we will count with R4
        	LEA 	R2, masks    	; finds the address in memory of the first mask

loop2    	LDR 	R3, R2, #0   	; load the mask from the address stored in R2
        	ADD 	R2, R2, #1   	; next mask address
        	AND 	R0, R6, R3
        	BRnz 	else 
        	LD  	R0, ascii1
        	BRnzp 	done

else    	LD  	R0, ascii0

done    	OUT
		LD  	R0, space
		OUT
        	ADD 	R4, R4, #1
        	ADD 	R0, R4, #-15  	; sets condition bit zero when R4 = 15
        	BRn 	loop2		; loops if R4 < 15
        	HALT

;a = 0
;foreach digit in string
;do
;   a = 10 * a + digit
;end

plus		.fill	x2B
minus		.fill	x2D
range		.fill	b1111111000000001 ; -511 	
buffer		.blkw	100		; buffer size
ascii		.fill	b1111111111010000 ; this is ((NOT x30) + 1)
ascii0  	.fill 	x30
ascii1  	.fill 	x31
space		.fill 	x20
max_size	.fill	b0000000001100100 ; 100

masks   
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

prompt		.stringz "Enter an integer between -511 and +511: "
invalid		.stringz "The input is invalid.\n"
		.end