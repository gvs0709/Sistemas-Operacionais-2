#!/bin/bash

x=$1

#Loop that decrements value on each iteration
while [ "$x" -gt -1 ]; do
	echo -n "$x "
	x=$(($x-1))

done

echo "" # New line at the end

exit 0 