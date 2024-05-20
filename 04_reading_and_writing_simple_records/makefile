LIB=../library

-include ../library/makefile

record_functions: file_functions memory_functions system_functions
	as -g -I "$(LIB)" record_functions.s -o record_functions.o

record_tests: record_functions
	as -g -I "$(LIB)" record_tests.s -o record_tests.o
	ld $(LIB)/file_functions.o $(LIB)/memory_functions.o $(LIB)/string_functions.o $(LIB)/system_functions.o record_functions.o record_tests.o -o record_tests.bin

clean: library_clean
	rm -f *.o
	rm -f *.bin