# exit_code.s
#
# DESCRIPTION:
# This program sets an exit code.
# After the program is run, the exit code can be viewed from the shell via
# `echo $?`

.section .data

.section .text
.globl _start

_start:

	movl $1, %eax
	movl $0, %ebx
	int $0x80
