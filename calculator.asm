; nasm -f elf32 calculator.asm -o a.o
; gcc -m32 a.o -o a

SECTION .data
    name_msg DB "What is your name? "
    name_msg_len EQU $-name_msg
    welcome_msg DB "Welcome to our boring calculator, "
    welcome_msg_len EQU $-welcome_msg
    exclamation DB "!", 0
    exclamation_len EQU 2

    newline DB 10

    addition DB "Addition!", 0
    addition_len EQU $-addition
    numbers_prompt DB "Enter two numbers to add.", 0
    numbers_prompt_len EQU $-numbers_prompt
    number1_prompt DB "number 1: "
    number1_prompt_len EQU $-number1_prompt
    number2_prompt DB "number 2: "
    number2_prompt_len EQU $-number2_prompt

    answer_msg DB "Answer: "
    answer_msg_len EQU $-answer_msg
    plus_sign DB "+"
    plus_sign_len EQU 1
    equals_sign DB "="
    equals_sign_len EQU 1

SECTION .bss
    number1 RESB 1
    number2 RESB 1
    name RESB 100
    name_len RESB 1
    answer RESB 1

SECTION .text
global main
main: 
    ; ask user for their name
    ; print the question
    mov eax, 4                  ; what we're doing
    mov ebx, 1                  ; where we're doing it
    mov ecx, name_msg           ; what we're printing
    mov edx, name_msg_len       ; how long the string is
    int 0x80                    ; sys call

    ; get the name from input
    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 100                ; we did not save the length allotted for the name in memory, so we hardcode the value.
    int 0x80

    ; Despite reserving 100 bytes for the name, the user likely isn't using all of them.
    ; So we will find the actual length of the name to use when we print it.
    ; When getting user input, the number of bytes entered will be returned in EAX after the sys call.

    ; So actual name length is in eax
    ; eax = lenghth of name + enter character
    dec eax                                     ; subtract 1 to remove or ignore the enter character
    mov [name_len], eax                         ; move the length of the name from eax to the reserved memory

    ; print a newlineget two numbers
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; print the start of the welcome message
    mov eax, 4
    mov ebx, 1
    mov ecx, welcome_msg
    mov edx, welcome_msg_len      1  ; declared using EQU, so welcome_msg_len is a constant and does not need dereferenced.
    int 0x80

    ; print the user's name
    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, [name_len]             ; declared using RESB, so name_len is a label. We need to deference it to access the value.
    int 0x80

    ; print the exclamation point
    mov eax, 4
    mov ebx, 1
    mov ecx, exclamation 
    mov edx, exclamation_len
    int 0x80

    ; print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; print the addition label
    mov eax, 4
    mov ebx, 1
    mov ecx, addition
    mov edx, addition_len
    int 0x80

    ; print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Get the two numbers from the user
    ; print the prompt to enter numbers
    mov eax, 4
    mov ebx, 1
    mov ecx, numbers_prompt
    mov edx, numbers_prompt_len
    int 0x80

    ; print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; print the prompt for number 1
    mov eax, 4
    mov ebx, 1
    mov ecx, number1_prompt
    mov edx, number1_prompt_len
    int 0x80

    ; get user input for number 1
    ; we have to read in 2 bytes despite only needing one.
    ; when the user hits enter after the number, that enter is stored.
    ; If we don't anticipate this, the computer will store the enter for number 2.
    mov eax, 3
    mov ebx, 0
    mov ecx, number1
    mov edx, 2
    int 0x80

    ; print prompt for number 2
    mov eax, 4
    mov ebx, 1
    mov ecx, number2_prompt
    mov edx, number2_prompt_len
    int 0x80

    ; get user input for number 2
    mov eax, 3
    mov ebx, 0
    mov ecx, number2
    mov edx, 2
    int 0x80

    ; CONVERT USER INPUT NUMBERS FROM STRINGS TO INTEGERS FOR CALCULATIONS

    ; originally we tried "sub [number1], '0'
    ; This caused an error that read "operation size not specified".
    ; This is because our destination is a place in memory which has no set size. 
    ; We can add a directive to the instruction to specify the size:
    ;       sub BYTE [number1], '0'
    ;           or
    ;       sub [number1], BYTE '0'
    ; instead, I used an intermediate register to retrieve the value, convert it, then rewrite to memory

    mov al, [number1]
    sub al, '0'
    mov [number1], al

    mov al, [number2]
    sub al, '0'
    mov [number2], al

    ; perform addition
    ; we cannot add two places in memory, so we have to use intermediary registers
    mov al, [number1]
    mov bl, [number2]
    
    ; al = al + bl
    add al, bl

    ; move answer from al to reserved space in memory
    mov [answer], al

    ; CONVERT NUMBERS BACK TO STRINGS TO PRINT
    mov al, [number1]
    add al, '0'
    mov [number1], al

    mov al, [number2]
    add al, '0'
    mov [number2], al 

    ; CONVERT SUM TO STRING FOR PRINTING
    mov al, [answer]
    add al, '0'
    mov [answer], al

    ; print answer label
    mov eax, 4
    mov ebx, 1
    mov ecx, answer_msg
    mov edx, answer_msg_len
    int 0x80

    ; print first number
    mov eax, 4
    mov ebx, 1
    mov ecx, number1
    mov edx, 1
    int 0x80

    ; print addition sign 
    mov eax, 4
    mov ebx, 1
    mov ecx, plus_sign
    mov edx, plus_sign_len
    int 0x80

    ; print second number
    mov eax, 4
    mov ebx, 1
    mov ecx, number2 
    mov edx, 1
    int 0x80

    ; print equals sign 
    mov eax, 4
    mov ebx, 1
    mov ecx, equals_sign
    mov edx, equals_sign_len
    int 0x80

    ; print sum 
    mov eax, 4
    mov ebx, 1
    mov ecx, answer
    mov edx, 1
    int 0x80

    ; print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80