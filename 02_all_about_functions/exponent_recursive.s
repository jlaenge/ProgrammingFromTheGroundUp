# exponent_recursive.s
#
# DESCRIPTION: Computes the exponential function, in a recursive fashion.
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

    # load base and exponent
    mov 16(%rbp), %rax  # base
    mov 24(%rbp), %rbx  # exponent

    # base case: exponent = 1 -> base
    cmp $1, %rbx
    je exponent_end

    # step case: base * exponent(base, exponent - 1)
    dec %rbx
    push %rbx
    push %rax
    call exponent
    add $16, %rsp
    mov 16(%rbp), %rbx
    imul %rbx, %rax

    exponent_end:
    # tear down stack frame
    mov %rbp, %rsp
    pop %rbp
    ret
