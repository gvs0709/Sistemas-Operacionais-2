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
		date "+%a %d %b %Y%t%H:%M:%S"
		echo "" # New line after text

	elif [ "$option" = "2" ]; then
		echo ""
		echo "Disk Usage Information:"
		#df -h | grep -i Filesystem && df -h | grep -i /dev/sd # Get first line and every line starting with /dev/sd
		df -h /dev/sd* | grep -v ^[^/]*"dev"
		echo ""

	elif [ "$option" = "3" ]; then
		echo ""
		echo "Currently logged users information:"
		#users
		w -f | sed "s/ [0-9][0-9]:[0-9][0-9]:[0-9][0-9]//" # Shows logged users information, system uptime and load average for the past 1, 5 and 15 min
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
