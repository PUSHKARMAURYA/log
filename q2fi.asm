section .data
    buffer db 21        ; Buffer to store the ASCII string (adjust size as needed)
    newline db 0x0A     ; Newline character for printing

section .bss
    num resq 1          ; Input integer (reserved space, using quadword for 64-bit)

section .text
    global _start

_start:
    ; Get input integer from the user
    mov rax, 1          ; System call number for sys_write
    mov rdi, 1          ; File descriptor 1 (stdout)
    mov rsi, input_msg  ; Message to prompt for input
    mov rdx, input_msg_len ; Message length
    syscall             ; Execute the system call

    ; Read the integer from the user
    mov rax, 0          ; System call number for sys_read
    mov rdi, 0          ; File descriptor 0 (stdin)
    mov rsi, num        ; Address to store the integer
    mov rdx, 8          ; Number of bytes to read (using quadword for 64-bit)
    syscall             ; Execute the system call

    ; Convert the integer to ASCII
    mov rax, qword [num] ; Load the input integer into rax (using quadword for 64-bit)
    mov rbx, 10         ; Divide by 10 (decimal)
    lea rdi, [buffer + 19] ; Start of buffer (from the end)

convert_loop:
    xor rdx, rdx       ; Clear rdx to prepare for division
    div rbx            ; Divide rax by 10, result in rax, remainder in rdx
    add dl, '0'        ; Convert the remainder (0-9) to ASCII
    dec rdi            ; Move rdi to the previous character in buffer
    mov [rdi], dl      ; Store the ASCII character in the buffer

    test rax, rax      ; Check if quotient is zero
    jnz convert_loop   ; If not zero, continue the loop

    ; Print the ASCII string
    mov rax, 1          ; System call number for sys_write
    mov rdi, 1          ; File descriptor 1 (stdout)
    lea rsi, [rdi + 1] ; Load the address of the first character in the buffer
    sub rdx, 19        ; Calculate the length of the ASCII string
    syscall            ; Execute the system call

    ; Print a newline
    mov rax, 1          ; System call number for sys_write
    mov rdi, 1          ; File descriptor 1 (stdout)
    mov rsi, newline    ; Newline character to print
    mov rdx, 1          ; Length of the newline character
    syscall            ; Execute the system call

    ; Exit the program
    mov rax, 60         ; System call number for sys_exit
    xor rdi, rdi        ; Return status 0
    syscall            ; Execute the system call

section .data
    input_msg db 'Enter an integer: ', 0
    input_msg_len equ $ - input_msg
