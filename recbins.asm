;;; (c) Borce Gjorgjievski
;;; Recursive Binary Search in Assembly

%include "m15.mac"

[SECTION .data]
align   4
printfmt	db	"Enter the search value:	", 0
scanfmt		db	"%d"
success		db	"The value was found at index %d",10,0
failure		db	"The value was NOT found",10,0
a:		dd      11, 22, 99, 222, 333, 999, 1111
N:		dd      6
	
[SECTION .text]
extern	scanf
extern printf

global main

;;; value at EBP-16
main:
	start
	add		ESP, -4 ; make space for value
	
	push dword	printfmt
	call		printf
	add		ESP, 4 

	mov		EBX, EBP
	add		EBX, -16 ; here will be value
	push		EBX	; scanf will store value here
	push dword	scanfmt
	call		scanf
	add		ESP, 8

	push dword	[EBP-16]; push value
	push dword	[N]	; high
	push dword	0	; low
	push dword	a	; address of array a
	call		search
	add		ESP, 16	

	cmp		EAX, -1
	je		not_found
	push		EAX
	push dword	success
	call		printf
	add		ESP, 8
	jmp		main_end
not_found:
	push dword	failure
	call		printf
	add		ESP, 4
main_end:	
	add		ESP, 4	; clean space for value
	done
	
;;; int search(int a[], int low, int high, int value)
;;; address of array a[] at EBP+8
;;; low at EBP+12
;;; high at EBP+16
;;; value at EBP+20

search:
	start
	add		ESP, -8	; make space for mid and pos
	mov		EAX, [EBP+12]; low
	mov		EBX, [EBP+16]; high
	mov		ECX, [EBP+20]; value
	mov		ESI, [EBP+8];  address of a[]

	cmp		EAX, EBX; (low > high)
	jle		calc
	mov		EAX, -1	; value was not found, finish
	jmp		finish
calc:
	add		EAX, EBX; (low + high)
	mov		EDX, 0	; just in case
	mov		EDI, 2
	div		EDI	; mid is in EAX
	mov		EBX, [4*EAX+ESI]	; a[mid]
	cmp		ECX, EBX	; (value == a[mid])
	jl		value_is_less
	jg		value_is_more
	jmp		finish	; mid is the index and is in EAX, so finish
value_is_less:
	dec		EAX	; mid=mid-1
	push dword	[EBP+20]; push value
	push		EAX	; push high
	push dword	[EBP+12]; push low
	push		ESI	; push address of a
	call		search
	add		ESP, 16
	jmp		finish
value_is_more:
	inc		EAX	; mid=mid+1
	push dword	[EBP+20]; push value
	push dword	[EBP+16]; push high
	push		EAX	; push low
	push		ESI	; push address of a
	call		search
	add		ESP, 16
finish:	
	add		ESP, 8	; clean after mid and pos
	done