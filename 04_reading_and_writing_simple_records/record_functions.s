# record_functions.s
#
# DESCRIPTION: Functions to
# - access properties of a given record,
# - read a given record from a file and
# - write a given record to a file

.include "record_definition.s"

.section .data
STRING_PROMPT_RECORD:
    .ascii "Please enter record...\n\0"
STRING_FIRSTNAME:
    .ascii "Firstname: \0"
STRING_LASTNAME:
    .ascii "Lastname: \0"
STRING_ADDRESS:
    .ascii "Address: \0"
STRING_AGE:
    .ascii "Age: \0"
STRING_LINEBREAK:
    .ascii "\n\0"

.section .text

.globl record_create
.globl record_prompt
.globl record_print
.globl record_write

# record_create
#
# DESCRIPTION: Constructor of a record. Given the attributes that make up a
# record as parameters, and a buffer, this function fills the buffer as
# required by the record memory layout.
#
# PARAMETERS:
# 1. buffer - pointer to buffer to fill with data
# 2. firstname - first name of record entry
# 3. lastname  - last name of record entry
# 4. address   - address of record entry
# 5. age       - age of record entry
.type record_create, @function
record_create:
    push %rbp
    mov %rsp, %rbp

    # copy firstname
    mov 24(%rbp), %rax
    mov 16(%rbp), %rbx
    add $RECORD_FIRSTNAME, %rbx
    push $RECORD_LASTNAME - RECORD_FIRSTNAME
    push %rbx
    push %rax
    call string_copy
    add $16, %rsp

    # copy lastname
    mov 32(%rbp), %rax
    mov 16(%rbp), %rbx
    add $RECORD_LASTNAME, %rbx
    push $RECORD_ADDRESS - RECORD_LASTNAME
    push %rbx
    push %rax
    call string_copy
    add $16, %rsp

    # copy address
    mov 40(%rbp), %rax
    mov 16(%rbp), %rbx
    add $RECORD_ADDRESS, %rbx
    push $RECORD_AGE - RECORD_ADDRESS
    push %rbx
    push %rax
    call string_copy
    add $16, %rsp

    # copy age
    mov 48(%rbp), %rax
    mov 16(%rbp), %rbx
    add $RECORD_AGE, %rbx
    push $RECORD_SIZE - RECORD_AGE
    push %rbx
    push %rax
    call string_copy
    add $16, %rsp

    mov %rbp, %rsp
    pop %rbp
    ret

# record_prompt
#
# DESCRIPTION: Prompts the input of a record via STDIN.
#
# PARAMETERS:
# 1. record - pointer to record to populate
#
# RETURNS: NONE
.type record_prompt, @function
record_prompt:
    push %rbp
    mov %rsp, %rbp

    # prompt
    push $STRING_PROMPT_RECORD
    call print_standard
    add $8, %rsp

    # firstname
    push $STRING_FIRSTNAME
    call print_standard
    add $8, %rsp

    mov 16(%rbp), %rax
    add $RECORD_FIRSTNAME, %rax
    push $RECORD_LASTNAME - RECORD_FIRSTNAME
    push %rax
    call read_line_standard
    add $16, %rsp

    # lastname
    push $STRING_LASTNAME
    call print_standard
    add $8, %rsp

    mov 16(%rbp), %rax
    add $RECORD_LASTNAME, %rax
    push $RECORD_ADDRESS - RECORD_LASTNAME
    push %rax
    call read_line_standard
    add $16, %rsp

    # address
    push $STRING_ADDRESS
    call print_standard
    add $8, %rsp

    mov 16(%rbp), %rax
    add $RECORD_ADDRESS, %rax
    push $RECORD_AGE - RECORD_ADDRESS
    push %rax
    call read_line_standard
    add $16, %rsp

    # age
    push $STRING_AGE
    call print_standard
    add $8, %rsp

    mov 16(%rbp), %rax
    add $RECORD_AGE, %rax
    push $RECORD_SIZE - RECORD_AGE
    push %rax
    call read_line_standard
    add $16, %rsp

    mov %rbp, %rsp
    pop %rbp
    ret

# record_print
#
# DESCRIPTION: Prints a given record to STDOUT.
#
# PARAMETERS:
# 1. record - pointer to record to print
#
# RETURNS: NONE
.type record_print, @function
record_print:
    push %rbp
    mov %rsp, %rbp

    # print firstname
    push $STRING_FIRSTNAME
    call print_standard
    add $8, %rsp
    mov 16(%rbp), %rax
    add $RECORD_FIRSTNAME, %rax
    push %rax
    call print_standard
    add $8, %rsp
    push $STRING_LINEBREAK
    call print_standard
    add $8, %rsp

    # print lastname
    push $STRING_LASTNAME
    call print_standard
    add $8, %rsp
    mov 16(%rbp), %rax
    add $RECORD_LASTNAME, %rax
    push %rax
    call print_standard
    add $8, %rsp
    push $STRING_LINEBREAK
    call print_standard
    add $8, %rsp

    # print address
    push $STRING_ADDRESS
    call print_standard
    add $8, %rsp
    mov 16(%rbp), %rax
    add $RECORD_ADDRESS, %rax
    push %rax
    call print_standard
    add $8, %rsp
    push $STRING_LINEBREAK
    call print_standard
    add $8, %rsp

    # print age
    push $STRING_AGE
    call print_standard
    add $8, %rsp
    mov 16(%rbp), %rax
    add $RECORD_AGE, %rax
    push %rax
    call print_standard
    add $8, %rsp
    push $STRING_LINEBREAK
    call print_standard
    add $8, %rsp

    mov %rbp, %rsp
    pop %rbp
    ret

# record_write
#
# DESCRIPTION: Writes a given record to a given file.
# NOTE: The record is appended to the file.
#
# PARAMETERS:
# 1. record - pointer to beginning of record
# 2. filedescriptor - of the file to write the record to
#
# RETURNS: error_code from write operation
.type record_write, @function
record_write:
    push %rbp
    mov %rsp, %rbp

    # retrieve parameters:
    # %rax - pointer to record
    # %rbx - filedescriptor
    mov 16(%rbp), %rax
    mov 24(%rbp), %rbx

    # write record to file
    push $RECORD_SIZE
    push %rax
    push %rbx
    call write
    add $16, %rsp

    mov %rbp, %rsp
    pop %rbp
    ret
