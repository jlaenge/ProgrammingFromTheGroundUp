# factorial_recursive.s
#
# DESCRIPTION: Computes the factorial of a given number in an iterative fashion,
# With factorial(n), or n!, being defined as:
#
# ```
#   n! := 1 * 2 * ... * (n-1) * n = PI_{i=1}^n i
# ```

.section .data

.section .text
.globl _start

_start:
    # call factorial(4)
    push $4
    call factorial
    add $8, %rsp

    # exit with result as status code
    mov %rax, %rbx
    mov $1, %rax
    int $0x80

.type factorial, @function
factorial:
    # construct stack frame
    push %rbp
    mov %rsp, %rbp

    mov $1, %rax        # rax is the accumulator, i.e. the computed value so far
    mov 16(%rbp), %rbx  # rbx is the current i being multiplied

    factorial_loop:

    # once we reach a value of 1, we are done
    cmp $1, %rbx
    je factorial_end

    imul %rbx, %rax
    dec %rbx
    jmp factorial_loop

    factorial_end:
    # tear down stack frame & exit
    mov %rbp, %rsp
    pop %rbp
    ret
