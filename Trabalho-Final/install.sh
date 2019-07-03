#!/bin/bash

echo "Installing steam-price.sh..."
mkdir ~/.local/bin/steam-price # Creates a directory for the script to run like any linux command
chmod +x steam-price # Makes the script executable
mv steam-price.sh ~/.local/bin/steam-price # Moves the script to the created directory
echo "Done!"
echo ""

# Install the script's man page
echo "Installing steam-price man page..."
install -g 0 -o 0 -m 0644 steam-price-MAN.1 /usr/local/man/man1/
gzip /usr/local/man/man1/steam-price-MAN.1
echo "Done!"
echo ""

steam-price -u
echo ""

while true; do
    echo "Do you want to download the entire Steam's game/software database?[y/N]"
    echo "Please note that this process will take a couple hours to complete"
    echo -n "> "
    read options
    echo ""
    
    if [ "$options" == "" ] || [[ "$options" == [Nn]* ]]; then
        echo "Instalation finished!"
        echo "Exiting script..."
        break
        
    elif [[ "$options" == [Yy]* ]]; then
        steam-price -g
        
        echo ""
        echo "Instalation finished!"
        echo "Exiting script..."
        break
        
    else
        echo "Invalid option!"
        echo ""
    fi
done
