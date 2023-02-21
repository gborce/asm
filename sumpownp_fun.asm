;;; (c) Bruce Gjorgjievski
;;; calculates sum of numbers from 1 to n, all to power p, returns pointer
;;; uses assembly function call

%include "m15.mac"

[SECTION .data]
msgN	db	"Enter n: ",0
msgP	db	"Enter p: ", 0
msgFin	db	"The sum of the p powers from 1 to n is : ",0
errN	db	"N must be non-negative!",0,10
errP	db	"P must be non-negative!",0,10
n:	dd	0
p:	dd	0
fsum:	dd	0
temp:	dd	0		
	
[SECTION .text]
global main

main:	start
	put_str         [msgN]
	get_i           [n]
	put_str         [msgP]
	get_i           [p]
	mov		ESI, [n]
	mov		EDI, [p]
	cmp		ESI, 0
	jl		error_n
	cmp		EDI, 0
	jl near		error_p

	push dword	fsum	; address of fsum
	push dword	[p]
	push dword	[n]
	call		sum
	add		ESP, 12 	; remove 3 params
	mov		EAX, [EBP-16]
	mov		EBX, [EAX]
	mov		[fsum], EBX
	put_str		[msgFin]
	put_i		[fsum]
	put_ch		10
	jmp		finished
error_n:
	put_str		[errN]
	jmp		finished
error_p:
	put_str		[errP]
	jmp		finished
finished:	
	done

	;; Function sum(int n, int p, *pResult)
	;; sum is in EAX
sum:	start
	mov		EBX, 0	; sum =0
	mov		ECX, [EBP+8]; ECX = [n]
	
again:	mov		EDX, [EBP+12]; EDX = [p], repeat in case it changed
	cmp		ECX, 0
	jle		after

	push dword	temp	; address of temp
	push		EDX	;  p
	push		ECX	; the current n
	call		power
	add		ESP, 12	; remove 3 int params
	mov		EAX, [EBP-16]
	add		EBX, [EAX]
	sub		ECX, 1
	jmp		again

after:	
	mov		EAX, [EBP+16]; the address of [sum]
	mov		[EAX], EBX	
	done
	
;;; Function power(int n, int p, *pResult)
;;; result is in EAX
	
power:	start
	mov             EBX, [EBP+12];  EBX = [p]
	mov		EDI, [EBP+8]; EDI = [n]
	cmp		EBX, 0
	jg		pow_cont
	mov		EAX, 1
	jmp		pow_out
pow_cont:	
	mov             EAX, EDI;  power = n, assume p > 0
pow_top:
	cmp		EBX, 1
	jle		pow_out
	mul		EDI
	add		EAX, EDX
	dec		EBX
	jmp		pow_top
pow_out:
	mov		ESI, [EBP+16]
	mov		[ESI], EAX; the address of [temp]
	done
