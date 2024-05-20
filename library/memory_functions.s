# memory_functions.s
#
# DESCRIPTION: General memory functions.

.section .text

.globl memory_copy

# memory_copy
#
# DESCRIPTION: Copies the data from source to target bytewise
#
# PARAMETERS:
# 1. source - pointer to source memory
# 2. target - pointer to target memory
# 3. size   - number of bytes to copy over
#
# RETURNS: NONE
.type memory_copy, @function
memory_copy:
    push %rbp
    mov %rsp, %rbp

    # retrieve parameter
    # %rax - source
    # %rbx - target
    # %rcx - size
    mov 16(%rbp), %rax
    mov 24(%rbp), %rbx
    mov 32(%rbp), %rcx

    memory_copy_loop:

    cmp $0, %rcx
    jle memory_copy_end

    movb (%rax), %dl
    movb %dl, (%rbx)

    inc %rax
    inc %rbx
    jmp memory_copy_loop

    memory_copy_end:

    mov %rbp, %rsp
    pop %rbp
    ret
