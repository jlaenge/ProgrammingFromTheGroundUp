# to_upper.s
#
# DESCRIPTION: Converts a text file to uppercase.
# In particular, the program runs over a file,
# interpreting it as ascii characters and
# converts every lowercase character (a - z) to the respective uppercase one
# (A - Z).

.include "filedescriptors.s"

.section .data

.equ BUFFER_SIZE, 12
BUFFER:
    .ascii "Hello world\n\0"

.section .bss
# .equ BUFFER_SIZE, 512
# buffer:
#    .lcomm BUFFER, BUFFER_SIZE

.section .text
.globl _start
_start:
    # print hello world
    push $BUFFER
    call print_standard
    add $24, %rsp

    # exit
    push $0
    call exit
    add $8, %rsp

# to_upper
#
# DESCRIPTION: Converts a given input buffer to uppercase.
# In particular, the buffer is interpreted as ascii characters,
# every lowercase character (a - z) is converted to the respective uppercase one
# (A - Z).
#
# INPUT:
# 1. pointer to buffer
# 2. length of buffer
#
# OUTPUT: NONE
.type to_upper, @function
to_upper:
    # create stack frame
    push %rbp
    mov %rsp, %rbp

    # retrieve parameters:
    # - rax: pointer to buffer
    # - rbx: length of buffer
    mov 16(%rbp), %rax
    mov 24(%rbp), %rbx

    # check that length is not zero
    cmp $0, %rbx
    je to_upper_exit

    # loop over buffer
    # back to front, when length is zero we exit
    to_upper_loop:

    # decrement length, as index starts at zero
    dec %rbx

    # load the current character
    # cl: current character
    movb (%rax, %rbx, 1), %cl

    # test: 'a' <= cl <= 'z'
    cmp $'a', %cl
    jl to_upper_next_iteration
    cmp $'z', %cl
    jg to_upper_next_iteration

    # convert to uppercase
    add $('A' - 'a'), %cl
    movb %cl, (%rax, %rbx, 1)

    to_upper_next_iteration:
    # check that length is not zero
    cmp $0, %rbx
    jne to_upper_loop

    to_upper_exit:
    # destroy stack frame
    mov %rbp, %rsp
    pop %rbp
    ret
