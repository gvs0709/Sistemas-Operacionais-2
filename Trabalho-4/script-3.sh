#!/bin/bash

# Test if value 1 is greater, smaller or equal to value 2
if [ "$1" -gt "$2" ]; then
	echo "$1 is greater than $2"

elif [ "$1" -lt "$2" ]; then
	echo "$1 is smaller than $2"

elif [ "$1" -eq "$2" ]; then
	echo "$1 and $2 are the same"

else
	echo "Invalid comparison"
fi

exit 0