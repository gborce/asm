;;; (c) Borce Gjorgjievski
;;; Calculating roots of floating point numbers from one array 
;;; and storing the results in another array
;;; uses assembly function call with floating point arguments

%include "m15.mac"

[SECTION .data]
n	dd	10
fmtn	db	"Enter n (0<n<101) : ",0
fmta	db	"Enter Arr1 element[%d] : ",0
fmti	db	"%d",0
fmtd	db	"%lf",0
fmtf	db	"Arr2 element[%d] is %lf",10,0
err	db	"n must be between 1 and 100!!!",10,0
				
[SECTION .bss]
alignb 8
arr1	resq	800		; 100 double elements max
arr2	resq	800		; 100 double elements max

[SECTION .text]
global main
extern scanf
extern printf

main:	start
	push dword	fmtn	
	call		printf
	add		ESP, 4

	push dword	n
	push dword	fmti
	call		scanf
	add		ESP,8

	mov		EAX, [n]
	cmp		EAX, 0
	jle near	error
	cmp		EAX, 100
	jg near		error
	mov		EBX, 0	; EBX is counter
input_again:
	cmp		EBX, [n]
	jge		input_done
	push		EBX
	push dword	fmta	; enter element
	call		printf
	add		ESP, 8

	mov		ECX, arr1
	lea		EDX, [ECX+8*EBX]; address of next element in arr1
	push		EDX
	push dword	fmtd
	call		scanf
	add		ESP, 8
	inc		EBX
	jmp		input_again
input_done:	
	push dword	[n]	; call roots function
	push dword	arr2
	push dword	arr1
	call		roots
	add		ESP, 12

	mov		EBX, 0	;  print the new array
print_again:	
	cmp		EBX, [n]
	jge		finish
	mov		ECX, arr2; address of arr2
	lea		ESI, [ECX+8*EBX]
	fld qword	[ESI]
	sub		ESP, 8
	fstp qword	[ESP]
	push		EBX
	push dword	fmtf
	call		printf
	add		ESP, 16
	inc		EBX
	jmp		print_again
error:
	put_str [err]
finish:	
	done
	
;;; void roots(double arr1[], double arr2[], int n);
;;; arr1 address at EBP+8
;;; arr2 address at EBP+12
;;; n at EBP+16, we are guaranteed that n is at least 1
roots:	start
	mov		EBX, 0	; counter
roots_again:
	mov		ESI, [EBP+8]; addr of arr1
	lea		EDI, [ESI+8*EBX]; addr of current element of arr1
	mov		ECX, [EBP+12]; addr of arr2
	lea		EDX, [ECX+8*EBX]; addr of current element of arr2
	fld qword	[EDI]
	fsqrt
	fstp qword	[EDX]
	inc		EBX
	cmp		EBX, [EBP+16]
	jl		roots_again
	done