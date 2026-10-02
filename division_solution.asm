; nasm -f elf32 division_solution.asm -o a.o
; gcc -m32 a.o -o a

section .data
    prompt_msg db "Who are you? ", 0
    prompt_msg_len equ $-prompt_msg
    hey_msg db "Hey "
    hey_msg_len equ $-hey_msg
    nibbles_msg db ", this is the division calculator :(", 0
    nibbles_msg_len equ $-nibbles_msg
    newline db 10
    please_msg db "Please enter each number: ", 0
    please_msg_len equ $-please_msg
    a_msg db "a: "
    a_msg_len equ $-a_msg
    b_msg db "b: "
    b_msg_len equ $-b_msg
    c_msg db "c: "
    c_msg_len equ $-c_msg
    calc_msg db "Your calculation is: ", 0
    calc_msg_len equ $-calc_msg
    space db " "
    space_len equ 1
    plus db " + "
    plus_len equ $-plus
    line db "-------  = "
    line_len equ $-line
    r_msg db " R "
    r_msg_len equ 3

section .bss
    name resb 10
    name_len resb 1
    a resb 2
    b resb 2
    c resb 2
    q resb 4
    r resb 2

section .text
global main
main:
; ======================= PRINT OUR WELCOME MESSAGES ========================
; print our name prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg
    mov edx, prompt_msg_len
    int 0x80
; take user input for name
    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 10         ; hardcoded since we didn't save the amount reserved
    int 0x80

; actual length of name entered is in eax
; subtract one from eax to ignore 'enter' character
    sub eax, 1
; set name length mov [name_len], eax
    mov [name_len], eax

; print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1          ; hardcoded since length is always 1 byte
    int 0x80

; print hey_msg
    mov eax, 4
    mov ebx, 1
    mov ecx, hey_msg
    mov edx, hey_msg_len
    int 0x80
; print their name
    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, [name_len]
    int 0x80
; print the nibbles_msg
    mov eax, 4
    mov ebx, 1
    mov ecx, nibbles_msg
    mov edx, nibbles_msg_len
    int 0x80

; print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1          
    int 0x80

; ======================= GET NUMBERS FROM USER ========================

; print please_msg
    mov eax, 4
    mov ebx, 1
    mov ecx, please_msg
    mov edx, please_msg_len
    int 0x80

; print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

; print a_msg
    mov eax, 4
    mov ebx, 1
    mov ecx, a_msg
    mov edx, a_msg_len
    int 0x80
; take input for a
    mov eax, 3
    mov ebx, 0
    mov ecx, a
    mov edx, 2              ; hardcoded
    int 0x80

; print b_msg
    mov eax, 4
    mov ebx, 1
    mov ecx, b_msg
    mov edx, b_msg_len
    int 0x80
; take input for b
    mov eax, 3
    mov ebx, 0
    mov ecx, b
    mov edx, 2              ; hardcoded
    int 0x80

; print c_msg
    mov eax, 4
    mov ebx, 1
    mov ecx, c_msg
    mov edx, c_msg_len
    int 0x80
; take input for c
    mov eax, 3
    mov ebx, 0
    mov ecx, c
    mov edx, 2              ; hardcoded
    int 0x80

; =======================   DO MATH   ========================

; Each number is only 1 byte, so we need to think ahead for division.
; div takes only one operand, the divisor (the thing we are dividing by)
; the dividend (what we are dividing) is always in 
;       EDX:EAX if operand is a doubleword (4 bytes)
;       DX:AX if operand is a word (2 bytes)
;       AX if operand is a byte
; since we are dividing  by c which is a byte, we need to divide all of ax.

; set AX to 0
    mov ax, 0

; since a is only a byte, this will pad the rest of the register
; with 0 to make sure our numbers stay accurate.

; set al = a
    mov al, [a]
; set bl = b 
    mov bl, [b]
; set cl = c 
    mov cl, [c]

; convert each register from strings to integers
; By moving them to registers first, we leave the numbers in memory as 
; strings since we want to print them again later.
    sub al, '0'
    sub bl, '0'
    sub cl, '0'

; add al and bl
; since we made sure to zero out ax before, ax = a + b
    add al, bl

; divide by c (in cl)
    div cl
; the quotient should be in al
; the remainder should be in ah

; convert both to strings to print later
    add al, '0'
    add ah, '0'
; store in their respective memory locations
    mov [q], al
    mov [r], ah

; ======================= PRINT OUR ANSWER ========================

; print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1          
    int 0x80
; print calc_msg
    mov eax, 4
    mov ebx, 1
    mov ecx, calc_msg
    mov edx, calc_msg_len
    int 0x80
; print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1          
    int 0x80

; print 1 space
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, space_len
    int 0x80
; print a
    mov eax, 4
    mov ebx, 1
    mov ecx, a
    mov edx, 1              ; despite allotting 2 bytes we only print 1 to ignore 'enter'
    int 0x80
; print plus
    mov eax, 4
    mov ebx, 1
    mov ecx, plus
    mov edx, plus_len
    int 0x80
; print b
    mov eax, 4
    mov ebx, 1
    mov ecx, b
    mov edx, 1
    int 0x80

; print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1          
    int 0x80

; print line
    mov eax, 4
    mov ebx, 1
    mov ecx, line
    mov edx, line_len
    int 0x80
; print q
    mov eax, 4
    mov ebx, 1
    mov ecx, q
    mov edx, 1
    int 0x80
; print r_msg
    mov eax, 4
    mov ebx, 1
    mov ecx, r_msg
    mov edx, r_msg_len
    int 0x80
; print r
    mov eax, 4
    mov ebx, 1
    mov ecx, r
    mov edx, 1
    int 0x80

; print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1          
    int 0x80

; print 3 spaces
; this centers the c under the + sign (the middle of a + b)
; it accounds for the space before a, a, and the space after a
    ; print first space
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, space_len
    int 0x80
    ; print second space
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, space_len
    int 0x80
    ; print third space
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, space_len
    int 0x80

; print c
    mov eax, 4
    mov ebx, 1
    mov ecx, c
    mov edx, 1
    int 0x80

; print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1          
    int 0x80

; terminate
    mov eax, 1
    mov ebx, 0
    int 0x80