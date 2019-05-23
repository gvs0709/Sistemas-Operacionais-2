#!/bin/bash

while true; do # Main options loop
	
	echo "Choose an option:"
	echo "1 - Date and Time"
	echo "2 - Partition Information"
	echo "3 - User Information"
	echo "4 - Exit"
	echo -n "> "
	read option # Reads user input


	if [ "$option" = "1" ]; then
		echo "\nCurrent Date and Time:"
		date
		echo "" # New line after text

	elif [ "$option" = "2" ]; then
		echo "\nDisk Usage Information:"
		df -h | grep -i Filesystem && df -h | grep -i /dev/sd # Get first line and every line starting with /dev/sd
		echo ""

	elif [ "$option" = "3" ]; then
		echo "\nUser information:"
		finger
		echo ""

	elif [ "$option" = "4" ]; then
		echo "\nExiting script..."
		break

	else
		echo "\nInvalid Option!"
		echo ""
	fi

done

exit 0