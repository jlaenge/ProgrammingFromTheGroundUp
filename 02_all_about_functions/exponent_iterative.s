# exponent_iterative.s
#
# DESCRIPTION: Computes the exponential function, in an iterative fashion.
# The exponent exponent(base, exponent) is defined as follows:
#
# ```
#   base ^ exponent = base * base * ... * base
#                       |                   |
#                       v                   v
#                          exponent - times
# ```
#
# RESTRICTIONS: The exponent has to be an integer above 0, i.e.:
# exponent in N\{0}

.section .data

.section .text
.globl _start

_start:
    # call exponent(2, 5), i.e. 2^5 = 32
    # ATTENTION: parameters pushed in reverse order
    push $5
    push $2
    call exponent
    add $16, %rsp

    # exit program
    mov %rax, %rbx
    mov $1, %rax
    int $0x80

.type exponent, @function
exponent:
    # construct stack frame
    push %rbp
    mov %rsp, %rbp

    # load accumulator, base and exponent
    mov $1, %rax        # accumulator
    mov 16(%rbp), %rbx  # base
    mov 24(%rbp), %rcx  # exponent

    exponent_loop:

    # exponent = 0 -> end
    cmp $0, %rcx
    je exponent_end

    # exponent > 1 -> multiply by base and decrement exponent
    imul %rbx, %rax
    dec %rcx
    jmp exponent_loop

    exponent_end:
    # tear down stack frame
    mov %rbp, %rsp
    pop %rbp
    ret
