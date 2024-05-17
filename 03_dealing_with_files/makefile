string_functions:
	as -g string_functions.s -o string_functions.o

file_functions: string_functions
	as -g file_functions.s -o file_functions.o

file_functions_test: file_functions	
	as -g file_functions_test.s -o file_functions_test.o
	ld string_functions.o file_functions.o file_functions_test.o -o file_functions_test.bin

to_upper: file_functions
	as -g to_upper.s -o to_upper.o
	ld string_functions.o file_functions.o to_upper.o -o to_upper

clean:
	rm *.o
	rm *.bin
