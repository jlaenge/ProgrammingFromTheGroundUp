.include "record_definition.s"

.section .data
STRING_STARTUP_MSG:
    .ascii "Running record tests...\n\0"
STRING_SUCCESS_MSG:
    .ascii "[DONE]\n\0"

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
    add $8, %rsp
    mov %rax, ST_DATABASE_FD(%rbp)

    # prompt action
    call action_loop

    # close database file
    mov ST_DATABASE_FD(%rbp), %rax
    push %rax
    call db_close
    add $8, %rsp

    # exit program
    push $0
    call exit

    mov %rbp, %rsp
    pop %rbp





# ==============================================================================
# PROMPT FUNCTIONS
# ==============================================================================

# action loop
#
# DESCRIPTION: Repeatedly requests actions from user, until an exit is requested
# or an error occurrs.
#
# PARAMETER: NONE
#
# RETURNS: NONE
.section .text
.type action_loop, @function
action_loop:
    push %rbp
    mov %rsp, %rbp

    action_loop_loop:
        call prompt_action
        cmp $0, %rax
        je action_loop_loop

    mov %rbp, %rsp
    pop %rbp
    ret

# prompt_action
#
# DESCRIPTION: Prompts the user for an action on the record database and
# executes this action.
#
# PARAMETER: NONE
#
# RETURNS: error_code
# - 0,         function executed without errors
# - otherwise, error occurred or exit was requested
.section .data
STRING_PROMPT_ACTION:
    .ascii "Please specify action (? for help)...\0"
STRING_INVALID_INPUT:
    .ascii "Invalid input.\n\0";
STRING_HELP:
    .ascii "\te - Exit the program\n\ti - Input new entry\n\tp - Print all entries\n\t? - Display this help text.\n\0"

.section .text
.type prompt_action, @function
prompt_action:
    push %rbp
    mov %rsp, %rbp

    push $STRING_PROMPT_ACTION
    call print_standard
    add $8, %rsp

    # prompt for input
    call read_char

    # compare input
    cmp $'e', %al
    je prompt_action_exit
    cmp $'i', %al
    je prompt_action_input
    cmp $'p', %al
    je prompt_action_print
    cmp $'?', %al
    je prompt_action_help
    jmp prompt_action_invalid

    prompt_action_exit:
    mov $1, %rax
    jmp prompt_action_end

    prompt_action_input:
    # prompt record
    push $MY_RECORD
    call record_prompt
    add $8, %rsp

    # write record
    mov ST_DATABASE_FD(%rbp), %rax
    push %rax           # FD of database
    push $MY_RECORD     # Record to write
    call record_write
    add $16, %rsp

    mov $0, %rax
    jmp prompt_action_end

    prompt_action_print:

    mov $0, %rax
    jmp prompt_action_end

    prompt_action_invalid:
    push $STRING_INVALID_INPUT
    call print_standard
    add $8, %rsp

    prompt_action_help:
    push $STRING_HELP
    call print_standard
    add $8, %rsp

    mov $0, %rax
    jmp prompt_action_end

    prompt_action_end:
    mov %rsp, %rbp
    pop %rbp
    ret





# ==============================================================================
# DATABASE_FUNCTIONS
# ==============================================================================

# db_open
#
# DESCRIPTION: The db_open function attempts to open the given database file.
# In case this is not possible, an error is reported and the program exists.
#
# PARAMETERS:
# filename - pointer to filename of database file
#
# RETURNS: filedescriptor of database
# In case the database could not be openend successfully, the program prints an
# error message and exits.
.section .data
STRING_LOADDB_MSG:
    .ascii "Loading database...\0"
STRING_DB_OPEN_ERROR:
    .ascii "Error opening database file!\0"

.section .text
.type db_open, @function
db_open:

    # create stack frame
    push %rbp
    mov %rsp, %rbp
    sub $8, %rsp

    push $STRING_LOADDB_MSG
    call print_standard
    add $8, %rsp

    # retrieve parameter: filename
    mov 16(%rbp), %rax

    # attempt to open database
    push $0666  # Permissions: RWX for Owner, Group and Everyone
    push $01101 # CREATE, TRUNCATE, WRITE
    push %rax   # Filename
    call open
    add $24, %rsp
    mov %rax, -8(%rbp)

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

    # print success message
    push $STRING_SUCCESS_MSG
    call print_standard
    add $8, %rsp

    # retrieve filedescriptor
    mov -8(%rbp), %rax

    # clean up stack frame
    mov %rbp, %rsp
    pop %rbp
    ret

# db_open
#
# DESCRIPTION: Attempts to open the given database file.
# In case this is not possible, an error is reported and the program exists.
#
# PARAMETERS:
# filedescriptor - of the open database file
.section .data
STRING_CLOSEDB_MSG:
    .ascii "Closing database...\0"
STRING_DB_CLOSE_ERROR:
    .ascii "Error closing database file!\0"

.section .text
.type db_close, @function
db_close:
    push %rbp
    mov %rsp, %rbp

    # print closing message
    push $STRING_CLOSEDB_MSG
    call print_standard
    add $8, %rsp

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
    push $1
    call exit
    add $8, %rsp

    db_close_end:

    # print closing message
    push $STRING_SUCCESS_MSG
    call print_standard
    add $8, %rsp

    mov %rbp, %rsp
    pop %rbp
    ret
