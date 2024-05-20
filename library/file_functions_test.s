# .include "file_functions.s"

# file_functions_test.s
#
# DESCRIPTION:
# Testcode for the file functions. This file also showcases the intended usage
# of the functions.

.section .data

HELLO_WORLD:
    .ascii "Hello World!\n\0"

FILENAME:
    .ascii "textfile.txt\0"

.section .text
.globl _start
_start:

    # print standard: hello world
    # push $HELLO_WORLD
    # call print_standard
    # add $8, %rsp

    # print error: hello world
    # push $HELLO_WORLD
    # call print_error
    # add $8, %rsp

    # print this file
    push $FILENAME
    call print_file
    add $8, %rsp   

    # exit
    push $0
    call exit
    add $8, %rsp
