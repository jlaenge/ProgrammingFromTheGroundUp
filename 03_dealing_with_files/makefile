LIB=../library

-include ../library/makefile

to_upper: file_functions
	as -g -I "$(LIB)" to_upper.s -o to_upper.o
	ld $(LIB)/string_functions.o $(LIB)/file_functions.o to_upper.o -o to_upper

clean:
	rm *.o
	rm *.bin
	cd $(LIB)
	rm *.o
	rm *.bin