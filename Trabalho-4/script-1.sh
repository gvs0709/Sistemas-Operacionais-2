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
		echo ""
		echo "Current Date and Time:"
		date
		echo "" # New line after text

	elif [ "$option" = "2" ]; then
		echo ""
		echo "Disk Usage Information:"
		df -h | grep -i Filesystem && df -h | grep -i /dev/sd # Get first line and every line starting with /dev/sd
		echo ""

	elif [ "$option" = "3" ]; then
		echo ""
		echo "User information:"
		finger
		echo ""

	elif [ "$option" = "4" ]; then
		echo ""
		echo "Exiting script..."
		break

	else
		echo ""
		echo "Invalid Option!"
		echo ""
	fi

done

exit 0