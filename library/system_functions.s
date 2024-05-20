# system_functions.s
#
# DESCRIPTION:
# Defines standard system functions such as exiting the program.

.include "linux_syscalls.s"

.section .text

.globl exit

# ==============================================================================
# FILE FUNCTIONS
# ==============================================================================

# exit
#
# PARAMETERS:
# 1. exitcode - to return
#
# RETURNS: does not return
.type exit, @function
exit:
    push %rbp
    mov %rsp, %rbp

    mov $SYSCALL_EXIT, %rax
    mov 16(%rbp), %rbx
    int $SYSCALL_INTERRUPT

    # unreachable
    mov %rbp, %rsp
    pop %rbp
    ret
