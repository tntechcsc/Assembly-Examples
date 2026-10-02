; nasm -f elf32 division.asm -o a.o
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
    space db " "
    space_len equ 1

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
; take user input for name
; set name length mov [name_len], eax
; subtract one from name to ignore 'enter' character

; print a newline

; print hey_msg
; print their name
; print the nibbles_msg

; print a newline

; ======================= GET NUMBERS FROM USER ========================

; print please_msg

; print a_msg
; take input for a
; print b_msg
; take input for b
; print c_msg
; take input for c

; =======================   DO MATH   ========================

; Each number is only 1 byte, so we need to think ahead for division.
; div takes only one operand, the divisor (the thing we are dividing by)
; the dividend (what we are dividing) is always in 
;       EDX:EAX if operand is a doubleword (4 bytes)
;       DX:AX if operand is a word (2 bytes)
;       AX if operand is a byte
; since we are dividing  by c which is a byte, we need to divide all of ax.

; set AX to 0
; since a is only a byte, this will pad the rest of the register
; with 0 to make sure our numbers stay accurate.

; set al = a
; set bl = b 
; set cl = c 

; convert each register from strings to integers
; By moving them to registers first, we leave the numbers in memory as 
; strings since we want to print them again later.

; add al and bl
; since we made sure to zero out ax before, ax = a + b

; divide by c 
; the quotient should be in al
; the remainder should be in ah

; convert both to strings to print later
; store in their respective memory locations

; ======================= PRINT OUR ANSWER ========================

; print a newline
; print calc_msg
; print a newline

; print 1 space
; print a
; print plus
; print b

; print a newline

; print line
; print q
; print r_msg
; print r

; print a newline

; print 3 spaces
; this centers the c under the + sign (the middle of a + b)
; it accounds for the space before a, a, and the space after a

; print c

; print a newline

; terminate