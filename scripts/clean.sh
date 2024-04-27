# clean.sh
# Removes all object files and executables in the current working directory.

#!/bin/sh

WORKING_DIR=`pwd`
echo "Cleaning \"${WORKING_DIR}\" ..."
rm ${WORKING_DIR}/*.o
rm ${WORKING_DIR}/*.bin

echo "Done!"
