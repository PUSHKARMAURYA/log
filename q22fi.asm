section .bss
    num resd 1                ; Variable to store the input integer
    buffer resb 12            ; Buffer to store the ASCII string (maximum 11 characters + null terminator)

section .text
    global _start             ; Entry point for the program

_start:
    ; Ask the user to enter an integer
    mov eax, 4                 ; Syscall number for write
    mov ebx, 1                 ; File descriptor 1 (stdout)
    lea ecx, [prompt]         ; Load the address of the prompt string
    mov edx, prompt_len       ; Length of the prompt string
    int 0x80                   ; Invoke the syscall to print the prompt

    ; Read the user input (integer) from the console
    mov eax, 3                 ; Syscall number for read
    mov ebx, 0                 ; File descriptor 0 (stdin)
    lea ecx, [num]            ; Load the address of the 'num' variable
    mov edx, 4                ; Number of bytes to read (32-bit integer)
    int 0x80                   ; Invoke the syscall to read the input

    ; Convert the integer to an ASCII string
    mov eax, [num]            ; Load the input integer into EAX
    mov ebx, 10               ; Base 10 for conversion
    mov ecx, buffer           ; Load the address of the buffer to store the ASCII string
    add ecx, 11               ; Move the pointer to the end of the buffer
    mov byte [ecx], 0         ; Null-terminate the string

convert_loop:
    dec ecx                   ; Move the pointer one position back in the buffer
    xor edx, edx              ; Clear EDX for division
    div ebx                   ; Divide EAX by 10, quotient in EAX, remainder in EDX
    add dl, '0'               ; Convert the remainder to ASCII character
    mov [ecx], dl             ; Store the ASCII character in the buffer

    test eax, eax             ; Check if quotient is zero
    jnz convert_loop          ; If not zero, continue the loop

    ; Print the ASCII string
    mov eax, 4                 ; Syscall number for write
    mov ebx, 1                 ; File descriptor 1 (stdout)
    lea ecx, [buffer]         ; Load the address of the ASCII string
    mov edx, 12               ; Length of the ASCII string (including null terminator)
    sub edx, ecx              ; Calculate the number of bytes to print
    int 0x80                   ; Invoke the syscall to print the ASCII string

    ; Exit the program
    mov eax, 1                 ; Syscall number for exit
    xor ebx, ebx               ; Exit status 0
    int 0x80                   ; Invoke the syscall to exit the program

section .data
    prompt db 'Enter an integer: ', 0     ; Null-terminated string for user prompt
    prompt_len equ $ - prompt             ; Length of the prompt string (excluding null terminator)
