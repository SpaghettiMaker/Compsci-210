		; xzho684
		.orig	x3000
		LD	R2, number	; R2 holds test case
		LEA 	R3, decimal 	; address of first ascii decimal which if effectivly a count
		ADD 	R2, R2, #0  	; test if negative
		BRzp 	loop		
		BR	output

loop		ADD 	R3, R3, #3	; increment to next ascii decimal
		ADD 	R2, R2, R2	; left shift
		BRzp 	loop
		
output		LEA     R0, out_str	; R0 only used for output
        	PUTS
		ADD 	R0, R3, #0	; copy current ascii address to R0
  		PUTS
        	HALT 

number		.fill b0000000000000001	; test cases

out_str   	.STRINGZ "The first significant bit is "
decimal 	.fill x31		;15 ASCII 
		.fill x35
		.fill x0
		.fill x31		;14 ASCII
		.fill x34
		.fill x0
		.fill x31		;13 ASCII
		.fill x33
		.fill x0
		.fill x31		;12 ASCII
		.fill x32
		.fill x0
		.fill x31		;11 ASCII
		.fill x31
		.fill x0
		.fill x31		;10 ASCII
		.fill x30
		.fill x0
		.fill x39		;9 ASCII
		.fill x0
		.fill x0
		.fill x38		;8 ASCII
		.fill x0
		.fill x0
		.fill x37		;7 ASCII
		.fill x0
		.fill x0
		.fill x36		;6 ASCII
		.fill x0
		.fill x0
		.fill x35		;5 ASCII
		.fill x0
		.fill x0
		.fill x34		;4 ASCII
		.fill x0
		.fill x0
		.fill x33		;3 ASCII
		.fill x0
		.fill x0
		.fill x32		;2 ASCII
		.fill x0
		.fill x0
		.fill x31		;1 ASCII
		.fill x0
		.fill x0
		.fill x30		;0 ASCII
		.fill x0
		.fill x0
		.END