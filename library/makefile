string_functions:
	as -g -I "$(LIB)" $(LIB)/string_functions.s -o $(LIB)/string_functions.o

file_functions: string_functions
	as -g -I "$(LIB)" $(LIB)/file_functions.s -o $(LIB)/file_functions.o


file_functions_test: file_functions	
	as -g -I "$(LIB)" $(LIB)/file_functions_test.s -o $(LIB)/file_functions_test.o
	ld $(LIB)/string_functions.o $(LIB)/file_functions.o $(LIB)/file_functions_test.o -o $(LIB)/file_functions_test.bin

library_clean:
	rm -f $(LIB)/*.o
	rm -f $(LIB)/*.bin