# file_functions.s
#
# DESCRIPTION:
# Defines functions for the standard operations on files (i.e. open, close,
# read and write).

# ==============================================================================
# CONSTANTS & BUFFERS
# ==============================================================================

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

.section .bss
.equ BUFFER_SIZE, 512
.lcomm BUFFER, BUFFER_SIZE





# ==============================================================================
# HIGHER-LEVEL PRINT FUNCTIONS
# ==============================================================================

.section .text

.globl print_file
.globl print_standard
.globl print_error
.globl exit

# print_file
#
# DESCRIPTION: Prints the given file to standard output
#
# PARAMETERS:
# 1. filename - name of file to read
#
# RETURNS: NONE
.type print_file, @function
print_file:
    push %rbp
    mov %rsp, %rbp
    sub $8, %rsp

    # load parameters
    # - rax: pointer to filename
    mov 16(%rbp), %rax

    # open file readonly
    push $0666      # all permissions
    push $0         # readonly
    push %rax       # filename
    call open
    add $24, %rsp

    mov %rax, -8(%rbp)  # store filedescriptor

    # read/write loop
    print_file_loop:

        # load local variables
        mov -8(%rbp), %rax

        # read chunk
        push $BUFFER_SIZE   # buffer size
        push $BUFFER        # buffer
        push %rax           # filedescriptor
        call read
        add $24, %rsp

        # check for error / EOF
        cmp $0, %rax
        jle print_file_end

        # write chunk
        push %rax       # length (number of bytes read)
        push $BUFFER    # buffer
        push $FD_STDOUT # standard output
        call write
        add $24, %rsp

        jmp print_file_loop

    print_file_end:

    # close file
    mov -8(%rbp), %rax
    push %rax           # filedescriptor
    call close
    add $8, %rsp

    # exit function
    mov %rbp, %rsp
    pop %rbp
    ret

# print_standard
#
# DESCRIPTION: prints to standard output
#
# PARAMETERS:
# 1. pointer - string to print
#
# RETURNS:
# error code from write call
.type print_standard, @function
print_standard:
    push %rbp
    mov %rsp, %rbp

    push $FD_STDOUT     # STDOUT filedescriptor
    mov 16(%rbp), %rax
    push %rax           # string to print
    call print_helper
    add $16, %rsp

    mov %rbp, %rsp
    pop %rbp
    ret

# print_error
#
# DESCRIPTION: prints to standard error
#
# PARAMETERS:
# 1. pointer - string to print
#
# RETURNS:
# error code from write call
.type print_error, @function
print_error:
    push %rbp
    mov %rsp, %rbp

    push $FD_STDERR     # STDERR filedescriptor
    mov 16(%rbp), %rax
    push %rax           # string to print
    call print_helper
    add $16, %rsp

    mov %rbp, %rsp
    pop %rbp
    ret

# print_helper
#
# DESCRIPTION:
# Prints the given string to the given filedescriptor
# NOTE: This is intended as a helper function for print_standard and print_error
# this function should not be called directly.
#
# PARAMETERS:
# 1. pointer - to string to be printed
# 2. filedescriptor - on which to print (i.e. write) the string
#
# RETURNS:
# error code from write function call
.type print_helper, @function
print_helper:
    push %rbp
    mov %rsp, %rbp

    sub $8, %rsp    # make space for local variables

    # load parameters:
    # rax - string pointer
    mov 16(%rbp), %rax

    # compute length of string
    push %rax
    call string_length
    add $8, %rsp

    # call write on STDOUT
    push %rax       # number of bytes to write
    mov 16(%rbp), %rax
    push %rax       # pointer to string
    mov 24(%rbp), %rax
    push %rax       # filedescriptor to print/write to
    call write
    add $24, %rsp

    mov %rbp, %rsp
    pop %rbp
    ret





# ==============================================================================
# STRING FUNCTIONS
# ==============================================================================

# string_length
#
# DESCRIPTION: computes the number of characters in the string
#
# PARAMETERS:
# 1. pointer - to start of string
#
# RETURNS:
# length of string
.type string_length, @function
string_length:
    push %rbp
    mov %rsp, %rbp

    mov $0, %rax
    mov 16(%rbp), %rbx

    string_length_loop:
        # load current character
        movb (%rbx, %rax, 1), %cl

        # check for null terminator
        cmp $0, %cl
        je string_length_end

        # increment length and loop
        inc %rax
        jmp string_length_loop

    string_length_end:

    mov %rbp, %rsp
    pop %rbp
    ret





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