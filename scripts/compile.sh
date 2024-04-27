# compile.sh
# Compiles a given assembly program into an executable binary.
# 
# PARAMETERS: Provide the name of the program
# Attention: The script assumes that the source file ends with ".s"
#   i.e. if the program name "test" is provided, it searches for the
#   source file "test.s"

#!/bin/sh

echo "Compiling \"$1\" ..."

as $1.s -o $1.o
ld $1.o -o $1.bin

echo "Compiled successfully! To execute the binary, run: \"./$1.bin\""
