#!/bin/bash

echo -n "Enter file or directory name: "

read file

if [ -f "$file" ]; then
	echo "$file exists and is a file!" # Test for file

elif [ -d "$file" ]; then
	echo "$file exists and is a directory!" # Test for directory

elif [ -e "$file" ]; then
	echo "$file exists but is not a file or directory!" # Failsafe

else
	echo "$file does not exist!" # Does not exist
fi

exit 0