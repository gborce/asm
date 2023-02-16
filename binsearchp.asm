;;; (c) Bruce Gjorgjievski
;;; Binary search of an n-element sorted array for a value "val" (w/ pointers)

%include "m15.mac"
	
[SECTION .data]
align	4
a:	dd	11, 22, 99, 222, 333, 999, 1111
N:	dd	7
val:	dd	0
msg1:	db	'Enter the value you are looking for:	', 0
mfn:	db	'The value was found at position ',0
mnf:	db	'The value was NOT found',10,0
low:	dd	0
high:	dd	0
pos:	dd	0
mid:	dd	0
	
[SECTION .text]
global main
	
main:
	start
	put_str	[msg1]
	get_i	[val]

	mov	EBX, a
	mov	[low], EBX	; pointer to a[0]
	mov	[high], EBX	
	mov	EAX, [N]
	dec	EAX
	mov	ECX, 4
	mul	ECX
	add	[high], EAX	; pointer to a[N-1]
top:
	mov	EAX, [high]
	cmp	[low], EAX
	jle	calc
	mov	dword [pos], -1
	jmp	bot
calc:
	mov	EAX, [low]
	mov	ECX, 2
	div	ECX		; avoid overflow, divide first then add
	mov	[mid], EAX
	mov	EAX, [low]
	div	ECX
	add	[mid], EAX	; got mid, but is it div by 4?
div4:
	mov	EAX, [mid]	
	mov	ECX, 4
	div	ECX
	cmp	EDX, 0		; remainder is in EDX
	je	cont4
	dec	dword [mid]	; decrease it until it's div by 4
	jmp	div4	
cont4:	
	mov	EAX, [mid]
	mov	EBX, [EAX]
	cmp	[val], EBX	;  compare the element at address EBX with val
	jl	val_is_less
	jg	val_is_more
	mov	EAX, [mid]	; found it! get the index
	sub	EAX, a
	mov	ECX, 4
	div	ECX
	mov	[pos], EAX
	jmp	bot
val_is_less:
	mov	EAX, [mid]
	sub	EAX, 4
	mov	[high], EAX	; high = mid - 1
	jmp	top
val_is_more:
	mov	EAX, [mid]
	add	EAX, 4
	mov	[low], EAX	; low = mid + 1 
	jmp	top
bot:
	cmp	[pos], dword -1
	je	not_found
	put_str	[mfn]
	put_i	[pos]
	put_ch	10
	jmp	end_this
not_found:
	put_str	[mnf]
end_this:	
	done
	