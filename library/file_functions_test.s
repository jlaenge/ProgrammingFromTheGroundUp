# .include "file_functions.s"

# file_functions_test.s
#
# DESCRIPTION:
# Testcode for the file functions. This file also showcases the intended usage
# of the functions.

.section .data

FILENAME:
    .ascii "textfile.txt\0"

.section .text
.globl _start
_start:

    # print a given file
    # NOTE: This testcase tests most of the helper functions, as it
    # - opens the file for reading
    # - reads the file
    # - prints to standard output (i.e. write)
    # - and closes the given file
    push $FILENAME
    call print_file
    add $8, %rsp

    # exit
    push $0
    call exit
    add $8, %rsp
