# linux_syscalls.s
#
# DESCRIPTION:
# This file defines constants for the linux systemcalls. The constant has to be
# placed in the %rax register and the SYSCALL_INTERRUPT needs to be triggered,
# in order to call the respective function.

# SYSCALL INTERRUPT
# The number of the systemcall interrupt.
.equ SYSCALL_INTERRUPT, 0x80

# SYSCALL CONSTANTS
# These constants need to be placed in the %rax register,
# before calling the SYSCALL_INTERRUPT.
.equ SYSCALL_EXIT, 1
.equ SYSCALL_READ, 3
.equ SYSCALL_WRITE, 4
.equ SYSCALL_OPEN, 5
.equ SYSCALL_CLOSE, 6
