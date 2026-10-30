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
tens_digit RESB 1
ones_digit RESB 1

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

    ; for (i=0; i<array_len; i++)
    ; Here we move the address of array into edx and the index into cl.
    ; This way we can iterate directly over the elements in the array
    ; without the issue of finding the offset. At the end of each loop,
    ; we will increment both the index and the element "pointer" (edx)
    ; to move onto the next element. Since each element is only 1 byte,
    ; we only increase edx by 1 each loop. Since EDX holds an address, 
    ; incrementing it means it will hold the next address now.
    ; We have to use the full EDX rather than dl because a full address 
    ; is 32 bits long, so dl won't be large enough to hold an entire address. 
    mov cl, 0
    mov edx, array
    min_loop:
        cmp cl, array_len                             ; compare cl to array_len
        jge min_end
        
        ; while edx is 4 bytes long, it is being dereferenced. So rather than
        ; comparing 1 byte in al to 4 bytes in edx, we are actually comparing
        ; 1 byte in al to 1 byte in memory (at the address in edx).
        cmp al, [edx]                              ; if min > array[index], min = array[index]
        jl end_min_if                                  ; if al < [array+cl]: nothing
        mov al, [edx]                              ; if al > [array+cl]: found a new min
        end_min_if:

        inc cl
        inc edx
        jmp min_loop

    min_end:
        jmp end

; else, find max
max: 
    ; print "max: "
    mov eax, 4
    mov ebx, 1
    mov ecx, max_msg
    mov edx, min_max_msg_len
    int 0x80
        mov al, -1                          ; set max

        mov cl, 0
        mov edx, array
        max_loop:
            cmp cl, array_len
            je max_end

            cmp al, [edx]
            jg end_max_if                          ; if al > [array+cl]: nothing
            mov al, [edx]
            end_max_if:

            inc cl
            inc edx
            jmp max_loop
        
        max_end:


end: 
; split result into two digits
; ax / operand = al R ah
mov ah, 0
mov bl, 0xA
div bl

; Convert each digit from int to str
add al, '0'
add ah, '0'

mov [tens_digit], al
mov [ones_digit], ah

; print result
mov eax, 4
mov ebx, 1
mov ecx, tens_digit
mov edx, 1 
int 0x80

mov eax, 4
mov ebx, 1
mov ecx, ones_digit
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