#!/bin/bash

echo "Installing steam-price.sh..."

if [ ! -d $HOME/.local/bin ]; then # If ~/.local/bin directory doesnt exists already
    mkdir $HOME/.local/bin # Create it
fi

if [ ! -d $HOME/.local/bin/steam-price ]; then # If steam-price directory doesnt exists already
    mkdir $HOME/.local/bin/steam-price # Creates a directory for the script and the files it downloads
fi

chmod +x steam-price.sh # Makes the script executable
cp steam-price.sh $HOME/.local/bin/steam-price # Moves the script to the created directory

if [ $SHELL == "/bin/bash" -o $SHELL == "/bin/zsh" ]; then
    # Exports the script path to both config files if possible
    if [ -f "$HOME/.bashrc" ]; then
        echo "" >> $HOME/.bashrc
        echo "#------- BEGIN ADDED BY STEAM-PRICE INSTALLER -------#" >> $HOME/.bashrc
        echo "export PATH=$PATH:$HOME/.local/bin/steam-price" >> $HOME/.bashrc # Export the script path so that its executable from any directory
        echo "#-------- END ADDED BY STEAM-PRICE INSTALLER --------#" >> $HOME/.bashrc
    fi

    if [ -f "$HOME/.zshrc" ]; then
        echo "" >> $HOME/.zshrc
        echo "#------- BEGIN ADDED BY STEAM-PRICE INSTALLER -------#" >> $HOME/.zshrc
        echo "export PATH=$PATH:$HOME/.local/bin/steam-price" >> $HOME/.zshrc # Export the script path so that its executable from any directory
        echo "#-------- END ADDED BY STEAM-PRICE INSTALLER --------#" >> $HOME/.zshrc
    fi

else 
    echo ""
    echo "Your default shell is not bash or zsh. Please pass the full path to your shell config file."
    echo "e.g. full/path/to/file/configFile"
    echo "You can also just press 'Enter' to skip this step"
    echo -n "> "
    read newPath
    
    #while true; do
    if [ "$newPath" == "" ]; then # If user hits 'Enter' does nothing else
        echo ""
        echo " Skipping..."
        
        #break
        
    else
        if [ -f "$newPath" ]; then # Checks if newPath exists and is a file
            echo "" >> $newPath
            echo "#------- BEGIN ADDED BY STEAM-PRICE INSTALLER -------#" >> $newPath
            echo "export PATH=$PATH:$HOME/.local/bin/steam-price" >> $newPath # Export the script path so that its executable from any directory
            echo "#-------- END ADDED BY STEAM-PRICE INSTALLER --------#" >> $newPath
            echo ""
            
            #break
            
        else
            echo ""
            echo "The passed path is not a file or doesnt exists!"
            #echo "Please enter the path again or press 'Enter' to skip"
            #echo -n "> "
            #read newPath
        fi
    fi
    #done
fi

echo "Done!"
echo ""

# Install the script's man page
echo "Installing steam-price man page..."

install -g 0 -o 0 -m 0644 steam-price-MAN.1 /usr/local/man/man1/
gzip /usr/local/man/man1/steam-price-MAN.1

echo "Done!"
echo ""

cd $HOME/.local/bin/steam-price

./steam-price -u
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
        ./steam-price -g
        
        echo ""
        echo "Instalation finished!"
        echo "Exiting script..."
        break
        
    else
        echo "Invalid option!"
        echo ""
    fi
done
