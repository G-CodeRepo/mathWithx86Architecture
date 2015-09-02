; Gerald Abut
; ICS 312 Assignment 9
; Exercise # 1
; 4/26/2014

; compute function f(x,y) = x^2 + (1+y)/sqrt(x)

%define x		dword  	[ebp+8]		; 1st parameter
%define y 		dword	[ebp+12]	; 2nd parameter

%include "asm_io.inc"

segment .data
segment .bss
segment .text
	global compute_f
compute_f:	
	push	ebp     	; save old ebp     
	mov		ebp, esp	; ebp = esp

	fld 	x					; sto = x
	fmul 	x					; sto = x^2
	fld1						; sto = 1, st1 = x^2
	fadd 	y					; sto = (1+y), st1 = x^2
	fld 	x					; sto = x, st1 = (1+y), st2 = x^2
	fsqrt						; squareroot sto (currently x)
	fdivp  	st1					; st1/st0, and pop sto from stack
	faddp	st1 				; st1 += sto, and pop st0 form stack
	;dump_math 0
	mov		esp, ebp	; reset esp
	pop		ebp			; restore ebp
	ret					; return