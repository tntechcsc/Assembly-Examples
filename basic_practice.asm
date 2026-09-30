; (a+b^2)-c

; first: declare our data
; second: prompt for numbers
; third: do calculations
; fourth: print answer

SECTION .data
; welcome prompt, a prompt, b prompt, c prompt, answer label
name_prompt DB "What's your name? ", 0
name_prompt_len EQU $-name_prompt
welcome_msg DB "Welcome, ",0
welcome_len EQU $-welcome_msg
exclamation DB "!", 0
exclamation_len EQU 2

SECTION .bss
; a, b, c, answer, name
name RESB 10
; 10 is the allowed length
; name_len will be the actual length
name_len RESB 1

SECTION .text
global main
main: 
	mov eax, 4
	mov ebx, 1
	mov ecx, name_prompt
	mov edx, name_prompt_len
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, name
	mov edx, 10
	int 0x80

	; after input, actual bytes read is stored in eax
	; eax = actual length of name
	sub eax, 1
	mov [name_len], eax
	
	; print welcome message + name
	mov eax, 4
	mov ebx, 1
	mov ecx, welcome_msg
	mov edx, welcome_len
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, name
	mov edx, [name_len]
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, exclamation
	mov edx, 2
	int 0x80

	mov eax, 1
	mov ebx, 0
	int 0x80






