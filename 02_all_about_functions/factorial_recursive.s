# factorial_recursive.s
#
# DESCRIPTION: Computes the factorial of a given number in a recursive fashion,
# With factorial(n), or n!, being defined as:
#
# ```
#   n! := 1 * 2 * ... * (n-1) * n = PI_{i=1}^n i
# ```
#
# The recursive computation is defined as follows:
# factorial(n) =
#   1,                      if n = 1
#   n * factorial(n-1),     if n > 1

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

    # base case: factorial(1) -> 1
    mov 16(%rbp), %rax
    cmp $1, %rax
    je factorial_end

    # step case: factorial(n+1) -> (n+1) * factorial(n)
    dec %rax
    push %rax
    call factorial
    add $8, %rsp
    mov 16(%rbp), %rbx
    imul %rbx, %rax

    factorial_end:
    # tear down stack frame & exit
    mov %rbp, %rsp
    pop %rbp
    ret
