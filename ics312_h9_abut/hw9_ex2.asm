; Gerald Abut
; ICS 312 Assignment 9
; Exercise # 2 (EXTRA CREDIT)
; 4/27/2014

; computes the infinite series e^x = 1 + x + x^2/2! + x^3/3! + x^4/4!...

%define x		dword  	[ebp+8]		; 1st parameter
%define	LIMIT 40

%include "asm_io.inc"

segment .data
segment .bss
segment .text
	global compute_exp 
compute_exp :	
	push	ebp     	; save old ebp     
	mov		ebp, esp	; ebp = esp

	fld1						; st0 = 1 ; the first term 	
	fld 	x 					; st0 = x ; the argument; st1 = 1
	fldz 						; st0 = 0 ; the sum accumulator; st1 = x, st2 = 1

	; ADD THE FIRST AND SECOND TERMS TO THE SUM
	faddp 	st1, st0 	; add the sum to the second term
	faddp 	st1, st0   	; add the second term (that is now the sum) to the first term

	mov 	ebx, 2 			; compute factorials from 2 - 40
	compute_series_loop:	

		; COMPUTE EXPONENT OF X
		push 	ebx				; arg2
		push 	x  				; arg1
		call 	compute_power
		add 	esp, 4 			; restore stack
		;dump_math 0

		; COMPUTE FACTORIAL
		push 	ebx					; arg1  
		call	compute_factorial	; compute the factorial stored in ebx
		add 	esp,	4 			; reset stack
		;dump_math 0

		; DIVIDE AND ADD TO SUM
		fdivp	st1, st0
		faddp 	st1, st0 			; add to sum accumulator and pop st0 off stack
		;dump_math 0
		inc 	ebx	 				; ebx++
		cmp 	ebx, LIMIT			; is ebx == 40 ?
		jle 	compute_series_loop ; if ebx <= 40, perform another loop iteration
	;dump_math 0

	mov		esp, ebp	; reset esp
	pop		ebp			; restore ebp
	ret					; return

;COMPUTE FACTORIAL n!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
segment .data
segment .bss
segment .text
compute_factorial:
	push 	ebp				; save old ebp
	mov 	ebp,	esp		; update the value of this subprogram's ebp

	push 	ebx 			; save old ebx
	mov 	ecx,	[ebp+8]	; the first argument stored as the starting value of the loop	
	fild 	dword [ebp+8]	; push into FP stack the current value of ebx
	fild	dword [ebp+8]	; push into FP stack the modifiable copy of ebx
	compute_factorial_loop:			
			fld1 				; store 1 to FP stack
			fsubp 	st1, st0  	; st1 - st0, subtract 1 from st1 and pop from FP stack
			fmul	st1, st0  	; st1 * st0 and pop from FP stack
			;dump_math 0
			dec 	ecx 					; ecx--
			cmp 	ecx, 1  				; is ecx == 1?
			jg 	compute_factorial_loop 	; if ecx > 1, loop again

    fmulp 	st1, st0 	; last item is a multiplication of 1 so no effect. pop extra 1 off the FP stack
	;dump_math 0
    pop 	ebx 							; restore the old ebx (counter from the calling function)
	mov 	esp, 	ebp	; reset esp
	pop		ebp			; restore ebp
	ret 				; return

;COMPUTE EXPONENT x^n
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
segment .data
segment .bss
segment .text
compute_power:
	push 	ebp				; save old ebp
	mov 	ebp,	esp		; update the value of this subprogram's ebp
	push 	x 				; save old x value
	push 	ebx 			; save old ebx value

	fld 	dword [ebp+8]		; 1st argument x
	mov 	ecx,	[ebp+12]	; 2nd argument stored as the starting value of the loop
	compute_exponent_loop:
			fld 	dword [ebp+8] 	; x
			fmulp 	st1, st0 	  	; st1 * st0
			dec 	ecx 			; ecx--
			cmp 	ecx, 1  		; is ecx == 1?
			jg 	compute_exponent_loop 	; if ecx > 1, loop again
	;dump_math 0
    pop 	ebx 		; restore old ebx value
    pop 	x 			; restore old x value
	mov 	esp, 	ebp	; reset esp
	pop		ebp			; restore ebp
	ret 				; return     	; return value is stored in ST0