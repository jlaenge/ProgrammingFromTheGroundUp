# to_upper.s
#
# DESCRIPTION: Converts a text file to uppercase.
# In particular, the program runs over a file,
# interpreting it as ascii characters and
# converts every lowercase character (a - z) to the respective uppercase one
# (A - Z).

.section .data

# LINUX SYSTEMCALLS
.equ SYSCALL_INTERRUPT, 0x80

.equ SYSCALL_EXIT, 1
.equ SYSCALL_READ, 3
.equ SYSCALL_WRITE, 4
.equ SYSCALL_OPEN, 5
.equ SYSCALL_CLOSE, 6

# LINUX FILEDESCRIPTORS
.equ FD_STDIN, 0
.equ FD_STDOUT, 1
.equ FD_STDERR, 2

.equ BUFFER_SIZE, 12
BUFFER:
    .ascii "Hello world\n"

.section .bss
# .equ BUFFER_SIZE, 512
# buffer:
#    .lcomm BUFFER, BUFFER_SIZE

.section .text
.globl _start
_start:
    # print hello world
    push $BUFFER_SIZE
    push $BUFFER
    push $FD_STDOUT
    call write
    add $24, %rsp

    # exit
    push $0
    call exit
    add $8, %rsp

    # unreachable

    # convert
    push $5
    push $BUFFER
    call to_upper
    add $16, %rsp

    # quit
    mov $1, %rax
    mov $0, %rbx
    int $0x80

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

# open
#
# PARAMETERS:
# 1. filename - name of file to be opened
# 2. intentions - mode of file (read-only, read-write, etc.)
# 3. permissions - permission octet (only relevant, if file is created)
#
# RETURNS:
# filedescriptor, or error code
.type open, @function
open:
    push %rbp
    mov %rsp, %rbp

    mov $SYSCALL_OPEN, %rax
    mov 16(%rbp), %rbx
    mov 24(%rbp), %rcx
    mov 32(%rbp), %rdx
    int $SYSCALL_INTERRUPT

    mov %rbp, %rsp
    pop %rbp
    ret

# close
#
# PARAMETERS:
# 1. filedescriptor - file to close
#
# RETURNS:
# zero, or error code
.type close, @function
close:
    push %rbp
    mov %rsp, %rbp

    mov $SYSCALL_CLOSE, %rax
    mov 16(%rbp), %rbx
    int $SYSCALL_INTERRUPT

    mov %rbp, %rsp
    pop %rbp
    ret

# read
#
# PARAMETERS:
# 1. filedescriptor - file to read
# 2. buffer - to write data to
# 3. size - size of buffer / number of bytes to read
#
# RETURNS:
# number of bytes read, or error code
.type read, @function
read:
    push %rbp
    mov %rsp, %rbp

    mov $SYSCALL_READ, %rax
    mov 16(%rbp), %rbx
    mov 24(%rbp), %rcx
    mov 32(%rbp), %rdx
    int $SYSCALL_INTERRUPT

    mov %rbp, %rsp
    pop %rbp
    ret

# write
#
# PARAMETERS:
# 1. filedescriptor - file to write
# 2. buffer - to read data from
# 3. size - size of buffer / number of bytes to write
#
# RETURNS:
# number of bytes written, or error code
.type write, @function
write:
    push %rbp
    mov %rsp, %rbp

    mov $SYSCALL_WRITE, %rax
    mov 16(%rbp), %rbx
    mov 24(%rbp), %rcx
    mov 32(%rbp), %rdx
    int $SYSCALL_INTERRUPT

    mov %rbp, %rsp
    pop %rbp
    ret

# to_upper
#
# DESCRIPTION: Converts a given input buffer to uppercase.
# In particular, the buffer is interpreted as ascii characters,
# every lowercase character (a - z) is converted to the respective uppercase one
# (A - Z).
#
# INPUT:
# 1. pointer to buffer
# 2. length of buffer
#
# OUTPUT: NONE
.type to_upper, @function
to_upper:
    # create stack frame
    push %rbp
    mov %rsp, %rbp

    # retrieve parameters:
    # - rax: pointer to buffer
    # - rbx: length of buffer
    mov 16(%rbp), %rax
    mov 24(%rbp), %rbx

    # check that length is not zero
    cmp $0, %rbx
    je to_upper_exit

    # loop over buffer
    # back to front, when length is zero we exit
    to_upper_loop:

    # decrement length, as index starts at zero
    dec %rbx

    # load the current character
    # cl: current character
    movb (%rax, %rbx, 1), %cl

    # test: 'a' <= cl <= 'z'
    cmp $'a', %cl
    jl to_upper_next_iteration
    cmp $'z', %cl
    jg to_upper_next_iteration

    # convert to uppercase
    add $('A' - 'a'), %cl
    movb %cl, (%rax, %rbx, 1)

    to_upper_next_iteration:
    # check that length is not zero
    cmp $0, %rbx
    jne to_upper_loop

    to_upper_exit:
    # destroy stack frame
    mov %rbp, %rsp
    pop %rbp
    ret
