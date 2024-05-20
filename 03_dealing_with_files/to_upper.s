# to_upper.s
#
# DESCRIPTION: Converts a text file to uppercase.
# In particular, the program runs over a file,
# interpreting it as ascii characters and
# converts every lowercase character (a - z) to the respective uppercase one
# (A - Z).

.section .data
FILENAME:
    .ascii "textfile.txt\0"

.section .bss
.equ BUFFER_SIZE, 512
buffer:
    .lcomm BUFFER, BUFFER_SIZE

.section .text
.globl _start
_start:

    push %rbp
    mov %rsp, %rbp
    sub $8, %rsp

    # open file for reading
    push $0666      # PERMISSIONS
    push $0         # READ-ONLY
    push $FILENAME  # FILENAME
    call open
    add $24, %rsp
    mov %rax, 8(%rbp)

    # test if file opened
    cmp $0, %rax
    jl exit_program

    # loop over file and print it out in uppercase
    loop_start:

        # read from file
        mov 8(%rbp), %rax
        push $BUFFER_SIZE-1
        push $BUFFER
        push %rax
        call read
        add $24, %rsp

        # check for EOF
        cmp $0, %rax
        jle loop_end

        # add null terminator
        movb $0, BUFFER(%rax, 1)

        # convert to uppercase
        push $BUFFER_SIZE-1
        push $BUFFER
        call to_upper
        add $16, %rsp

        # print to STDOUT
        push $BUFFER
        call print_standard
        add $8, %rsp

        # loop
        jmp loop_start

    loop_end:

    # close the file
    mov 8(%rbp), %rax
    push %rax
    call close
    add $8, %rsp

    exit_program:

    # restore stack frame
    mov %rbp, %rsp
    pop %rbp

    # exit the program
    push $0
    call exit
    add $8, %rsp





# ==============================================================================
# HELPER FUNCTIONS
# ==============================================================================

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
