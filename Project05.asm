TITLE Sorting Random Integers    (Project05.asm)

; Author: Ryan Wallerius
; Course / Project ID	CS 271 / Project 5              Date: 5/24/17
; Description: I am suppose to ask the user to generate numbers in a certain range (100-999)
; I need to display the original list, in whatever order it was generated, then sort the list
; calculate the median value and then sort the list again in descending order

INCLUDE Irvine32.inc



.data

lo = 100;
hi = 999;
min = 10;
max = 200;

introduction	BYTE	"Sorting Random Integers				Programmed by Ryan Wallerius", 0
description		BYTE	"This program will ask the user how many numbers they would like to generate in the range of [10,200],", 0
description1	BYTE	"display the original list, sort the list, calculate the median value and then display the list in descending order", 0
instruction1	BYTE	"How many numbers do you want generated? [10..200]: ", 0
wrong_error		BYTE	"The number you entered is invalid. Enter again!", 0
number_numbers	DWORD	?
count			BYTE	0
number			BYTE	"You asked to generate: ", 0
array DWORD max DUP(?)
space			BYTE	"   ", 0
unsortedList	BYTE	"The unsorted random numbers: ", 0
sortedList		BYTE	"The sorted random numbers: ", 0
medianValue		BYTE	"The median value: ", 0

val1 DWORD 12
val2 DWORD 16	

.code
main PROC

	push val1
	push val2
	call changeColor			;borrowed code from online to change color

call intro

push OFFSET number_numbers		;Parameter for getData
call getData


push  OFFSET array
push  number_numbers
call  fillArray

mov edx, OFFSET unsortedList
call WriteString
call CrLf
push OFFSET array
push number_numbers
call displayList
call CrLf
call CrLf

push OFFSET array
push number_numbers
call sortList

call CrLf
;push OFFSET array
;push number_numbers
;call displayMedian
call CrLf

mov edx, OFFSET sortedList
call WriteString
call CrLf
push OFFSET array
push number_numbers
call displayList
call CrLf



	exit	; exit to operating system
main ENDP

changeColor PROC

		push ebp										;borrowed this code online in order to change the text color in the window
		mov	 ebp, esp
		mov  eax, [ebp + 8] ; val 1
		imul eax, 16
		add  eax, [ebp + 12] ; val 2
		call setTextColor
		pop	 ebp
		ret  8	; Clean up the stack
changeColor	ENDP

intro	PROC

mov edx, OFFSET introduction
call WriteString
call CrLf
call CrLf
mov edx, OFFSET description
call WriteString
call CrLf
mov edx, OFFSET description1
call WriteString
call CrLf
call CrLf

	ret

intro	ENDP

getData		PROC
	push ebp
	mov	 ebp, esp

	userData:
	mov	 edx, OFFSET instruction1
	call WriteString
	call ReadDec
	mov	 number_numbers, eax			;Store result

	cmp  number_numbers, max			;Error check for range
	JG	 error
	cmp  number_numbers, min
	JL   error
	pop	 ebp							;Passes range, now get value off stack
	ret			

error:
	mov edx, OFFSET wrong_error
	call WriteString
	call CrLf
	jmp  userData

getData		ENDP

fillArray	PROC
	push  ebp
	mov   ebp, esp						;set up stack life above
	mov	  esi, [ebp+12]					;get @ of array
	mov	  ecx, [ebp+8]					;get count for loop
	cmp	  ecx, 0
	JE	  endHello
	mov  edx, hi 
	sub  edx, lo						;I watched lecture 20 and it gave me code for filling array like this

hello:
	mov  eax, edx
	call RandomRange					;This is the template I was given from lecture 20 on getting random range
	add  eax,lo
	mov [esi], eax						;cur element
	add  esi, 4							;next element
	loop hello	

endHello:
	pop	 ebp
	ret	 8

fillArray	ENDP



displayList PROC						;Got the template for this from lecture 20 (register indirect)

	push ebp
	mov ebp, esp 
	mov esi, [ebp+12]
	mov ecx, [ebp+8]

	print:
		mov eax, [esi]					;current element
		call WriteDec					;display current element
		add count, 1
		mov edx, OFFSET space			;get space between the numbers
		call WriteString
		cmp count, 10					;look for when count is equal to 10 and break to a new line
		je newLine
		jmp next

	newLine:
		call CrLf
		mov count, 0
		jmp next

	next:
		add esi, 4						;go to next element in array
		loop print						;loop back to print to display elements

	endPrint:
		pop ebp							;restore stack
		ret 8							
	 

displayList ENDP

sortList	PROC
	push  ebp
	mov   ebp, esp						;This bubble sort algorithm was taken from the book pp 375
	mov	  ecx, [ebp+8]					; get count for loop

	loop1:
	push ecx							;save count
	mov esi,[ebp+12]					;point to first value in array

	loop2:
	mov eax, [esi]						;cur value
	cmp [esi+4], eax					;compare cur to next value
	jl loop3							;if greater jump to loop 3
	xchg  eax, [esi+4]					;if not exchange the values
	mov [esi], eax						;save value

	loop3:
	add esi, 4							;go to next element
	loop loop2

	pop ecx
	loop loop1

	loop4:
	pop ebp
	ret 8

sortList	ENDP

displayMedian	PROC

;I could not figure out what to do here
;After setting up the stack frame I couldn't figure out what I was suppose to do

displayMedian	ENDP

END main
