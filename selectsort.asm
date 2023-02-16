;;; (c) Bruce Gjorgjievski
;;; Applying SelectSort to a 10 element array

%include "m8.mac"

[SECTION .data]
credit:	db	"****** Bruce Gjorgjievski, Pentium Assembly Language",10,0
title:	db	"Sorting a 10 element array with SelectSort",10,0
before:	db	"Array before sorting: ",0
after:	db	"Array after sorting: ",0
ptrAi:	dd	0
ptrAj:	dd	0
ptrMIN:	dd	0
temp1:	dd	0
temp2:	dd	0
copyAi:	dd	0
copyAj:	dd	0
a:	dd	1, 10, 2, 9, 3, 8, 4, 7, 5, 6 ; sample array
fin:	


[SECTION .text]

global main
	
main:
	start
	put_str [credit]	
	put_str [title]
	put_ch 10
	put_str [before]
	move [ptrAi], a
print_ini:	
	compare [ptrAi], a+40
	jae print_outi
	loaddw [temp2], [ptrAi]
	put_i [temp2]
	put_ch 32
	iadd [ptrAi], 4
	jmp print_ini
print_outi:	
	put_ch 10
	move [ptrAi], a
	;; outer loop
top1:	compare [ptrAi], a+36
	jae near next1
	move [ptrAj], [ptrAi]
	move [ptrMIN], [ptrAi]
top2:	iadd [ptrAj], 4		; start from j = i+1
	compare [ptrAj], a+40	; j <= N
	jae next2
	loaddw [copyAi], [ptrMIN]
	loaddw [copyAj], [ptrAj]
	compare [copyAi], [copyAj]; a[min] <= a[j]
	jbe top2
	move [ptrMIN], [ptrAj]
	jmp top2
next2:	
	loaddw [temp1], [ptrAi]	; swap a[min] and a[i]
	loaddw [temp2], [ptrMIN]
	storedw [ptrAi], [temp2]
	storedw [ptrMIN], [temp1]
	iadd [ptrAi], 4
	jmp top1
	
next1:				; print after sorting
	move [ptrAi], a
	put_str [after]
print_in:	
	compare [ptrAi], fin
	jae print_out
	loaddw [temp2], [ptrAi]
	put_i [temp2]
	put_ch 32
	iadd [ptrAi], 4
	jmp print_in
print_out:	
	put_ch 10
	
	done
	