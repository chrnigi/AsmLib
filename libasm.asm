; All global declarations first:
global printstr                     ; int printstr(const char*)

section .text
printstr:                           ; int printstr(const char*)
    push rbp
    mov rbp, rsp

    xor edx, edx                    ; Zero rdx.
lenLoop:
    mov bl, byte [rdi+rdx]          ; Move byte in string at index rdx to bl.
    inc rdx                         ; Increment rdx.
    cmp bl, byte 0                  ; Compare bl to null-terminator.
    jne lenLoop                     ; If bl != \0, then loop.
                                    ; rdx should now hold the string length.

    sub rsp, rdx                    ; Push bytes matching the string length to the stack.
    mov rcx, rdx                    ; Move string length to rcx.
    dec rcx                         ; Decrement rcx.
    mov [rsp+rcx], byte 0xA         ; Move newline character to the lowest of the just pushed bytes.
pushLoop:
    dec rcx
    mov bl, [rdi+rcx]               ; Move byte in string at index rdx to bl.
    mov [rsp+rcx], byte bl          ; Move byte in bl to rsp + rcx.
    cmp rcx, 0                      ; Compare rcx to 0.
    jg pushLoop                     ; If not 0, then loop.

    mov rax, 1                      ; sys_write.
    mov rdi, 1                      ; stdout.
    mov rsi, rsp                    ; rsi points to stack.
    syscall                         ; Syscall - rdx already holds string length
exit:
    mov rsp, rbp
    pop rbp