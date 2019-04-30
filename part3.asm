		; xzho684

		.orig	0x3000
		AND	R1, R1, #0	; R1 is count		
		ADD 	R1, R1, #11
		LD 	R0, number	; R0 holds test case

start		ADD	R0, R0, R0
		ADD	R1, R1, #-1
		BRZ	goprint		
		BR	start		

goprint		LD	R2, expmask	; R2 holds expmask
		AND	R0, R0, R2	; R0 is now masked
		ADD	R5, R0, #0	; R5 holds binary that needs to be printed		
		AND 	R4, R4, #0   	; clears the register we will count with R4
        	LEA 	R2, masks    	; finds the address in memory of the first mask

loop	   	LDR 	R3, R2, #0   	; load the mask from the address stored in R2
        	ADD 	R2, R2, #1   	; next mask address
        	AND 	R0, R5, R3
        	BRnz 	else 
        	LD  	R0, ascii1
        	BRnzp 	done

else    	LD  	R0, ascii0

done    	OUT
		LD  	R0, space
		OUT
        	ADD 	R4, R4, #1
        	ADD 	R0, R4, #-16  	; sets condition bit zero when R4 = 15
        	BRn 	loop		; loops if R4 < 15
        	HALT

number		.fill 	b1000000000001011 ; test case

ascii0  	.fill 	x30
ascii1  	.fill 	x31
space		.fill 	x20
expmask		.fill	b0111100000000000

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

		.END
