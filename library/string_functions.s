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
