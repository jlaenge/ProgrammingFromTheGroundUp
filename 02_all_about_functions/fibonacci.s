# fibonacci.s
#
# DESCRIPTION: Computes the fibonacci numbers in the standard recursive
# algorithm (naive implementation, without caching).
# The fibonacci fibonacci(n) function is recursively defined as follows:
#
# ```
#   fibonacci(n) = {
#       0,                                  if n = 0,
#       1,                                  if n = 1,
#       fibonacci(n-1) + fibonacci(n-2),    if n > 1
#   }
# ```
#
# RESTRICTIONS:
# The input value must be an integer.

.section .data

.section .text
.globl _start

_start:
    # call fibonacci(5)
    push $6
    call fibonacci
    add $8, %rsp

    # return status code
    mov %rax, %rbx
    mov $1, %rax
    int $0x80

.type fibonacci, @function
fibonacci:
    # build stack frame
    push %rbp
    mov %rsp, %rbp
    sub $8, %rsp    # make space for local variable

    # retrieve parameter
    mov 16(%rbp), %rax

    # base case:
    #   0 -> 0
    #   1 -> 1
    cmp $1, %rax
    jle fibonacci_end

    # step case: fibonacci(n) = fibonacci(n-1) + fibonacci(n-2)

        # call fibonacci(n-1)
        sub $1, %rax
        push %rax
        call fibonacci
        add $8, %rsp    # store result locally

        # call fibonacci(n-2)
        mov %rax, -8(%rbp)
        mov 16(%rbp), %rax
        sub $2, %rax
        push %rax
        call fibonacci
        add $8, %rsp

        # sum up results
        mov -8(%rbp), %rbx  # retrieve local result
        add %rbx, %rax

    fibonacci_end:
    # tear down stack frame
    mov %rbp, %rsp
    pop %rbp
    ret
