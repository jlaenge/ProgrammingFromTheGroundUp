.include "record_definition.s"

.section .data
STRING_STARTUP_MSG:
    .ascii "Running record tests...\n\0"

STRING_DB_OPEN_ERROR:
    .ascii "Error opening database file!\0"

STRING_DB_CLOSE_ERROR:
    .ascii "Error closing database file!\0"

DB_FILE_NAME:
    .ascii "record.dat\0"

# TODO: These fields are only temporarily hard-coded. Later we want to read
# them in from the command line.
MY_FIRSTNAME:
    .ascii "Firstname\0"
MY_LASTNAME:
    .ascii "Lastname\0"
MY_ADDRESS:
    .ascii "Somestreet 42\0"
MY_AGE:
    .ascii "123\0"

.section .bss
.lcomm MY_RECORD, RECORD_SIZE

.section .text

.globl _start

.equ ST_DATABASE_FD, -8

_start:
    push %rbp
    mov %rsp, %rbp
    
    # local variables:
    # 8 - filedescriptor of database file (write)
    sub $8, %rsp

    # print starting text
    push $STRING_STARTUP_MSG
    call print_standard
    add $8, %rbp

    # open database file for writing
    push $DB_FILE_NAME     # Filename
    call db_open
    mov %rax, ST_DATABASE_FD(%rbp)

    # TODO: create and write record

    # create record
    push $MY_AGE
    push $MY_ADDRESS
    push $MY_LASTNAME
    push $MY_FIRSTNAME
    push $MY_RECORD
    call record_create
    add $40, %rsp

    # write record
    mov ST_DATABASE_FD(%rbp), %rax
    push %rax           # FD of database
    push $MY_RECORD     # Record to write
    call record_write
    add $16, %rsp

    # close database file
    mov ST_DATABASE_FD(%rbp), %rax
    push %rax
    call db_close
    add $8, %rsp

    # exit program
    mov %rbp, %rsp
    pop %rbp

    push $0
    call exit

# db_open
#
# DESCRIPTION: The db_open function attempts to open the given database file.
# In case this is not possible, an error is reported and the program exists.
#
# PARAMETERS:
# filename - pointer to filename of database file
#
# RETURNS: filedescriptor of the database file
# The function does not have a return code, however it may exit the program,
# in case the database could not be openend successfully
.type db_open, @function
db_open:

    # create stack frame
    push %rbp
    mov %rsp, %rbp

    # retrieve parameter: filename
    mov 16(%rbp), %rax

    # attempt to open database
    push $0666  # Permissions: RWX for Owner, Group and Everyone
    push $01101 # CREATE, TRUNCATE, WRITE
    push %rax   # Filename
    call open
    add $24, %rsp

    # check return code
    cmp $0, %rax
    jge db_open_end

    # print error message
    push $STRING_DB_OPEN_ERROR
    call print_error
    add $8, %rsp

    # exit program
    push $1
    call exit       # NOTE: This call should not return
    add $8, %rsp

    db_open_end:

    # clean up stack frame
    mov %rbp, %rsp
    pop %rbp
    ret

.type db_close, @function
db_close:
    push %rbp
    mov %rsp, %rbp

    # retrieve parameter: filedescriptor
    mov 16(%rbp), %rax

    # close file
    push %rax
    call close
    add $8, %rsp

    # check return code
    cmp $0, %rax
    je db_close_end

    # print error message
    push $STRING_DB_CLOSE_ERROR
    call print_error
    add $8, %rsp

    db_close_end:

    mov %rbp, %rsp
    pop %rbp
    ret
