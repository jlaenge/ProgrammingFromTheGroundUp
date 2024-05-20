# string_functions.s
#
# DESCRIPTION:
# Defines functions on c-strings, i.e. contiguous sequences of ascii characters
# that are null-terminated.

# ==============================================================================
# CONSTANTS
# ==============================================================================

.equ NULL_TERMINATOR, 0





# ==============================================================================
# STRING FUNCTIONS
# ==============================================================================

.section .text

.globl string_length
.globl to_upper

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
        cmp $NULL_TERMINATOR, %cl
        je string_length_end

        # increment length and loop
        inc %rax
        jmp string_length_loop

    string_length_end:

    mov %rbp, %rsp
    pop %rbp
    ret

# to_upper
#
# DESCRIPTION: Converts a given string to uppercase.
# In particular, every lowercase character (a - z) is converted to the
# respective uppercase one (A - Z).
#
# INPUT:
# 1. pointer to a null-terminated ascii string
#
# OUTPUT: NONE
.type to_upper, @function
to_upper:
    # create stack frame
    push %rbp
    mov %rsp, %rbp

    # retrieve string
    mov 16(%rbp), %rax

    # loop over buffer
    to_upper_loop:

    # load the current character
    # cl: current character
    movb (%rax), %cl

    # test for null terminator
    cmp $NULL_TERMINATOR, %cl
    je to_upper_exit

    # test: 'a' <= cl <= 'z'
    cmp $'a', %cl
    jl to_upper_next_iteration
    cmp $'z', %cl
    jg to_upper_next_iteration

    # convert to uppercase
    add $('A' - 'a'), %cl
    movb %cl, (%rax)

    to_upper_next_iteration:
    inc %rax
    jmp to_upper_loop

    to_upper_exit:
    # destroy stack frame
    mov %rbp, %rsp
    pop %rbp
    ret
