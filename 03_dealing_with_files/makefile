file_functions:
	as -g file_functions.s -o file_functions.o

file_functions_test: file_functions	
	as -g file_functions_test.s -o file_functions_test.o
	ld file_functions.o file_functions_test.o -o file_functions_test.bin

clean:
	rm *.o
	rm *.bin
