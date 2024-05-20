.section .data
START_STRING:
    .ascii "Running record tests...\n\0"

.section .text

.globl _start

_start:
    push %rbp
    mov %rsp, %rbp

    # print starting text
    push $START_STRING
    call print_standard
    add $8, %rbp

    mov %rbp, %rsp
    pop %rbp

    push $0
    call exit
