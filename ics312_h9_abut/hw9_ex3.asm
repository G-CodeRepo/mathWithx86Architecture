; Gerald Abut
; ICS 312 Assignment 9
; Exercise # 3 (EXTRA CREDIT)
; 4/29/2014

; compute logarithm's infinite series (x-1/x) + (1/2)[(x-1)/x]^2 + (1/3)[(x-1)/x]^3...

%define x		dword  	[ebp+8]		; 1st parameter
%define	LIMIT 4999 	; THERE ARE 5000 TERMS TOTAL. THE FIRST TERM IS COMPUTED OUTSIDE THE LOOP

%include "asm_io.inc"

segment .data
segment .bss

segment .text
	global compute_ln 
compute_ln :	
	push	ebp     	; save old ebp     
	mov		ebp, esp	; ebp = esp

	fldz						; st0 = 0 ; used for the sum accumulator
	
	; COMPUTE FIRST TERM (x-1)/x
	push 	x 					; push x onto stack
	call 	compute_variable	; goto compute_variable function
	add	 	esp, 4  			; restore stack
	faddp	st1, st0 			; st1 += st0 	; add to sum accumulator 

	; COMPUTE TERMS 2-40
	mov 	ebx, 2 				; ebx = 2, loop counter to compute terms 2-40
	compute_ln_loop:	
		; COMPUTE FRACTION (1/n)
		push 	ebx 				; arg1 (denominator to compute fraction)
		call 	compute_fraction	; goto compute_fraction subprogram
		add 	esp, 4 				; restore stack

		; COMPUTE VARIABLE (x-1)/x  (BEFORE EXPONENT)		
		push 	x 					; push x onto stack
		call 	compute_variable	; goto compute_variable subprogram
		add	 	esp, 4  			; restore stack

		; COMPUTE EXPONENT OF [(x-1)/x]^n
		push 	ebx				; arg1 	(counter to compute exponent)
		call 	compute_power	; goto compute_power subprograms
		add 	esp, 4 			; restore stack

		; COMPUTE BY MULTIPLYING (1/n)[(x-1)/x]^n
		fmulp 	st1, st0 			; st1 * st0
		faddp	st1, st0 			; st1 += st0 	; add to sum accumulator

		; UPDATE LOOP
		inc 	ebx	 				; ebx++
		cmp 	ebx, LIMIT			; is ebx == 5000 ?
		jl 	compute_ln_loop ; if ebx != 5000, perform another loop iteration (compute another term)
	;dump_math 0
	mov		esp, ebp	; reset esp
	pop		ebp			; restore ebp
	ret					; return

; COMPUTE FRACTION	(1/n)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
segment .data
segment .bss
segment .text
compute_fraction:
	push 	ebp 			; save old ebp value
	mov 	ebp, 	esp 	; update the value of this subprogram's ebp

	fld1 						; push 1 into stack	
	fild 	dword [ebp+8]		; 1st argument (from ebx)
	fdivp 	st1, st0 			; st1/st0
	;dump_math 0

	mov 	esp, 	ebp		; reset esp
	pop 	ebp 			; restore ebp
	ret 					; return value stored in st0

; COMPUTE VARIABLE (x-1)/x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
segment .data
segment .bss
segment .text
compute_variable:
	push 	ebp 			; save old ebp value
	mov 	ebp, 	esp 	; update the value of this subprogram's ebp	
	push 	ebx				; push old value of ebx onto stack
	push 	x 				; push old value of x onto stack

	fld 	dword [ebp+8] 		; st0 = x ; the argument
	fld1 						; st0 = 1 ; st1 = x
	fsubp 	st1, st0 			; st0 = x-1
	fld 	x 					; st0 = x, st1 = x-1
	fdivp 	st1, st0 			; (x-1)/x

	pop 	x 				; pop old value of x out of stack
	pop 	ebx 			; pop old value of ebx out of stack
	mov 	esp, 	ebp		; reset esp
	pop 	ebp 			; restore ebp
	ret 					; return value stored in st0

; COMPUTE EXPONENT [(x-1)/x]^n
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
segment .data
segment .bss
segment .text
compute_power:
	push 	ebp				; save old ebp
	mov 	ebp,	esp		; update the value of this subprogram's ebp

	push 	ebx					; push old ebx into stack
	mov 	ecx, 	[ebp+8]		; counter for exponents
	fld 	st0 				; push a copy of st0 onto FP stack
	compute_exponent_loop:
			fmul 	st1, st0 			; st1 * st0
			dec 	ecx 				; ecx--
			cmp 	ecx, 1  			; is ecx == 1?
			jg 	compute_exponent_loop 	; if ecx > 1, loop again

    fdivp 	st0, st0 	; divide the extra stack to itself to change it to 1.  pop extra 1 off the FP stack
	;dump_math 0
	pop	  	ebx 		; restore old value of ebx from stack
	mov 	esp, 	ebp	; reset esp
	pop		ebp			; restore ebp
	ret 				; return     	; return value is stored in ST0