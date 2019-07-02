#!/bin/bash

echo "Installing steam-price.sh..."
mkdir ~/.local/bin/steam-price # Creates a directory for the script to run like any linux command
chmod +x steam-price # Makes the script executable
mv steam-price.sh ~/.local/bin/steam-price # Moves the script to the created directory

# Install the script's man page
echo "Installing steam-price man page..."
install -g 0 -o 0 -m 0644 steam-price-MAN.1 /usr/local/man/man1/
gzip /usr/local/man/man1/steam-price-MAN.1
echo ""

while true; do
    echo "Do you want to download Steam's game database now?[Y/n]"
    echo -n "> "
    read option

    if [ "$option" == "" ] || [[ "$option" == [Yy]* ]]; then
        steam-price -u
        break
        
    elif [[ "$options" == [Nn]* ]]; then
        break
        
    else
        echo "Invalid option!"
        echo ""
    fi
done

while true; do
    if [[ "$options" == [Nn]* ]]; then
        break
    fi
    
    echo "Do you want to Lembrar de mudar -q pra buscar e fazer as requisições!!!"
    break
done
