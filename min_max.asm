; nasm -f elf32 division_solution.asm -o a.o
; gcc -m32 a.o -o a

; Write an assembly program that asks the user if they want to find the min or max of an array.
; Then do that.

; array = [85, 68, 17, 04, 07, 10, 13, 81, 86, 50, 42, 33, 90, 91, 51, 38, 62, 04, 03, 84, 67, 31, 21, 38, 83, 49, 73, 82, 98, 93, 48, 02, 72, 27, 63, 18, 65, 54, 05, 07, 06, 81, 84, 96, 87, 32, 64, 58]

SECTION .data
welcome_msg DB "Welcome to our thingy majig. Enter 1 to find the minimum. Enter 2 to find the maximum.", 0
welcome_msg_len EQU $-welcome_msg
choice_msg DB "Choice: "
choice_msg_len EQU $-choice_msg

array DB 85, 68, 17, 04, 07, 10, 13, 81, 86, 50, 42, 33, 90, 91, 51, 38, 62, 04, 03, 84, 67, 31, 21, 38, 83, 49, 73, 82, 98, 93, 48, 02, 72, 27, 63, 18, 65, 54, 05, 07, 06, 81, 84, 96, 87, 32, 64, 58
array_len EQU $-array

min_msg DB "Min: "
max_msg DB "Max: "
min_max_msg_len EQU $-max_msg

newline DB 10

SECTION .bss
user_input RESB 2
result RESB 1

SECTION .text
global main
main:

; print welcome MESSAGE
mov eax, 4
mov ebx, 1
mov ecx, welcome_msg
mov edx, welcome_msg_len
int 0x80

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 0x80

; print choice
mov eax, 4
mov ebx, 1
mov ecx, choice_msg
mov edx, choice_msg_len
int 0x80

; get user input -> user_input
mov eax, 3
mov ebx, 0
mov ecx, user_input
mov edx, 2
int 0x80

; if user_input == 1, find min
cmp BYTE [user_input], '1'
jne max

min:
    ; print "min: "
    mov eax, 4
    mov ebx, 1
    mov ecx, min_msg
    mov edx, min_max_msg_len 
    int 0x80    

    ; set min variable = 100
    mov al, 100

    ; for index 0-array_len
        ; if min > array[index], min = array[index]

    ; set result = al
    mov [result], al

    ; jump to end of program
    jmp end

; else, find max
max: 
    ; print "max: "
    mov eax, 4
    mov ebx, 1
    mov ecx, max_msg
    mov edx, min_max_msg_len
    int 0x80

        ; set max variable = -1
        mov al, -1

        ; for index 0-array_len
            ; if max < array[index], max = array[index]

        ; set result = al
        mov [result], al

end: 
; print result
mov eax, 4
mov ebx, 1
mov ecx, result
mov edx, 1 
int 0x80

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 0x80

; kick rocks/terminate
mov eax, 1
mov ebx, 0
int 0x80