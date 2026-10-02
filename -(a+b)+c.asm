; -(a+b)+c

global main

section .data
welcome_msg db "#$%^&**&^%$#@!!", 0
welcome_len equ $-welcome_msg

a_msg db "Please enter a value for a: ", 0
a_len equ $-a_msg

b db 3
c db 8

newline db 10

e1_msg db "The answer to your first equation is: ", 0
e1_len equ $-e1_msg

section .bss
a resb 1
answer resb 1

section .text

main:
mov eax, 4
mov ebx, 1
mov ecx, welcome_msg
mov edx, welcome_len
int 0x80

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 0x80

mov eax, 4
mov ebx, 1
mov ecx, a_msg
mov edx, a_len
int 0x80

mov eax, 3
mov ebx, 0
mov ecx, a
mov edx, 2
int 0x80

mov al, [a]
sub al, '0'

add al, [b]

neg al

add al, [c]

mov [a], al

add BYTE [a], '0'

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 0x80

mov eax, 4
mov ebx, 1
mov ecx, e1_msg
mov edx, e1_len
int 0x80

mov eax, 4
mov ebx, 1
mov ecx, a
mov edx, 1
int 0x80

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 0x80

mov eax, 1
xor ebx, ebx
int 0x80
