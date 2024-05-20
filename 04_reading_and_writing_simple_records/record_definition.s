# record_definition.s
#
# DESCRIPTION: This file gives the memory layout of a record.
# It should be included in all files handling the records (i.e. reading and
# writing them). In particular, the fields of a given record should only be
# accessed through this file.

.equ RECORD_FIRSTNAME, 0
.equ RECORD_LASTNAME, 40
.equ RECORD_ADDRESS, 80
.equ RECORD_AGE, 160
.equ RECORD_SIZE, 168
