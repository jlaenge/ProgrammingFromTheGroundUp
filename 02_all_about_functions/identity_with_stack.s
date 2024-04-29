# identity.s
#
# DESCRIPTION: 
# To understand function calls, this file implements a recursive function.
# In contrast to "without_stack" implementation, this file uses the stack for
# passing the arguments (see CALLING CONVENTIONS below).
#
# The identity function:
# 
# ```
#   id(x) = x
# ```
#
# is implemented as follows:
#
# ```
# int identity(x) {
#   if(x == 0) return x;
#   else return 1 + identity(x-1);
# }
# ```
#
# CALLING CONVENTION:
# Following the C Calling Convention, all arguments are passed on the stack
# (in reverse order). While the return value is stored in %eax (as before).

.section .data

.section .text
.globl _start

_start:
    push $2
    call identity
    sub $8, %rsp

    movl %eax, %ebx
    movl $1, %eax
    int $0x80

identity:
    # construct stack frame
    push %rbp
    mov %rsp, %rbp

    # load parameter
    mov 16(%rbp), %rax

    # base case: x = 0 -> return x
    cmp $0, %rax
    je identity_end

    # step case: x > 0 -> return identity(x-1) + 1
    sub $1, %rax

    push %rax
    call identity
    sub $8, %rsp

    add $1, %rax

    # tear down stack frame
    identity_end:
    mov %rbp, %rsp
    pop %rbp
    ret
