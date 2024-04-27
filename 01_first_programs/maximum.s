# maximum.s
#
# DESCRIPTION:
# This program computes the maximum value in a given list of values,
# and returns that value via the status code (see script/status_code.sh).
# 
# ASSUMPTIONS:
# - the list may only contail positive values larger than 0,
# - the list is terminated by a value of 0
#
# REGISTERS:
# %edi - `index` in the list
# %ebx - `current_maximum` value (because ebx is also the status code)
# %eax - `current_value` indexed by the list

.section .data
my_list:
    .long 12, 18, 222, 255, 13, 12, 18, 0

.section .text
.globl _start

_start:

    movl $0, %edi # initialize `index` to 0
    movl $0, %ebx # initialize `current_maximum` to 0

    loop:
        movl my_list(, %edi, 4), %eax # load `current_value` with my_list[index]
        incl %edi # increment `index`

        # check for termination
        cmp $0, %eax
        je end

        # check for new maximum
        cmp %ebx, %eax
        jle loop

        # update maximum
        movl %eax, %ebx

        jmp loop

    end:
        movl $1, %eax
        # %ebx already contains the maximum, so no movl is needed here
        int $0x80
