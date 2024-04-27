# Programming From the Ground Up

This repository contains some x86 testprogramms that I developed while reading Jonathan Bartlett's [Programming from the Ground Up](http://savannah.nongnu.org/projects/pgubook).

The programs are meant for learning x86 assembly under Ubuntu and to play around with.

## Environment

I compiled an ran the projects under Ubuntu 22.04 (LTS) with the Linux 6.5.0 Kernel.

## Compile

For compilation and linking used the following commands:

```
as <program>.s -o <program>.o
ld <program>.o -o <program>.bin
```

*Note:* I used the extension ".bin" for the executables, because this makes the
cleanup script easier. (See [cleanup](#clean) below).

## Scripts

For convenience, the following scripts can be used:

### Compile

The `compile.sh` compiles a given program.

```
./compile.sh <program>
```

Attention: The script assumes there is a source file (".s") with the same name
as the program in the current working directory. I.e. if you wish to compile
the file "test.s", the script has to be called as follows:

```
./compile.sh test
```

### Clean

The `clean.sh` script removes all object files (".o") and binaries (".bin") from
the current working directory.

## Status Code

The `status_code.sh` script prints the status code of the last program that ran.