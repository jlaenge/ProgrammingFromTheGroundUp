# identity.s
#
# DESCRIPTION: 
# To understand function calls, this file implements a recursive function.
# To simplify the implementation, the stack is only used for the return address,
# all arguments are passed via registers (see CALLING CONVENTIONS below).
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
# Only single argument functions are supported.
# The single parameter, as well as the return value
# are stored in %eax

.section .data

.section .text
.globl _start

_start:
    movl $2, %eax
    call identity

    movl %eax, %ebx
    movl $1, %eax
    int $0x80

identity:
    # construct stack frame
    push %rbp
    mov %rsp, %rbp

    # base case: x = 0 -> return x
    cmp $0, %rax
    je identity_end

    # step case: x > 0 -> return identity(x-1) + 1
    sub $1, %rax
    call identity
    add $1, %rax

    # tear down stack frame
    identity_end:
    mov %rsp, %rbp
    pop %rbp
    ret
