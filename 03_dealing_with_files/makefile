LIB=../library

-include ../library/makefile

to_upper: file_functions system_functions
	as -g -I "$(LIB)" to_upper.s -o to_upper.o
	ld $(LIB)/string_functions.o $(LIB)/file_functions.o $(LIB)/system_functions.o to_upper.o -o to_upper.bin

clean: library_clean
	rm -f *.o
	rm -f *.bin