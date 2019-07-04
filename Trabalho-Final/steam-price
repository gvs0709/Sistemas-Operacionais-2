#!/bin/bash

# Done by gvs0709 and bmeurer1
# github.com/gvs0709
# github.com/bmeurer1
# Hosted on github.com/gvs0709/Sistemas-Operacionais-2/Trabalho-Final

while getopts ":ugqs" opt; do
    case ${opt} in
    u ) # Update data base: Names/ID's
        echo "Updating app list..."

        wget -qO - http://api.steampowered.com/ISteamApps/GetAppList/v2/ > name_ID_list.json

        echo "App list updated!"
        echo ""
    ;;
    
    g ) # Update data base: Names/ID's/Price
        # Search for all game IDs on the database
        game_IDs=$( cat name_ID_list.json | grep -o -e "appid\":[^,]*" | sed "s/appid\"://" )

        # Create a file to store retrieved values if it doesnt exist already
        if [ ! -f "name_ID_price_list.txt" ]; then
            echo "" > name_ID_price_list.txt
        fi

        count=0

        echo "Fetching games... ($count/$( wc -w <<< $game_IDs ))"
            
        # For each game ID on the DB
        for ID in $game_IDs; do
            # Searches for the game on the API
            data=$( wget -qO - https://store.steampowered.com/api/appdetails?appids=$ID )

            count=$( expr $count + 1 )

            # If there is no return goes to the next ID. There are multiple IDs that are not found
            # The reliability of the API is unknown
            if [ -z "$data" ]; then
                echo -en "\r"
                echo "Failed to fetch game. ID: $ID. Game not found"
                echo -n "Fetching games... ($count/$( wc -w <<< $game_IDs ))"
                continue
            fi
            
            # Checks search status. If there's no success, dont update game
            status=$( echo $data | grep -o 'success":[a-z]*' --color=always | sed -n '1p' | cut -b 21- )

            # Removes trash from the end of the string
            status=${status:: -6}

            # Checks if the game fetch was successfull
            if [ $status == "false" ]; then
                echo -en "\r"
                echo -e "Failed to fetch game. ID: $ID. Success status = False"
                echo -n "Fetching games... ($count/$( wc -w <<< $game_IDs ))"
                continue
                
            else # Else update game values
                # O sed é para trazer apenas a primeira linha e o cut é pra tirar o 'name":"' e 
                # 'final":"' da string do nome e do preço
                nome=$( echo $data | grep -o 'name":"[^"]*' --color=always | sed -n '1p' | cut -b 19- )
                
                if [ -z "$nome" ]; then
                    echo -en "\r"
                    echo "Failed to fetch game. ID: $ID. Name not found"
                    echo -n "Fetching games... ($count/$( wc -w <<< $game_IDs ))"
                    continue
                fi
                
                nome=${nome:: -6}
                preco=$( echo $data | grep -o 'final":[0-9]*' --color=always | sed -n '1p' | cut -b 19- )
                
                if [ -z "$preco" ]; then
                    echo -en "\r"
                    echo "Failed to fetch games. ID: $ID. Price not found"
                    echo -n "Fetching games... ($count/$( wc -w <<< $game_IDs ))"
                    continue
                fi
                
                preco=${preco:: -6}
                tmp_id=$( grep -e "^$ID$" name_ID_price_list.txt )
                tmp_preco=$( grep -A1 -e "^$ID$" name_ID_price_list.txt | tail -n 1 )

                #echo $tmp_preco

                # If entry doesnt exists, write it on the file. Otherwise swap the value if it is smaller
                if [ -z "$tmp_id" ]; then
                    # Write game's info  on the file
                    echo ""		>> name_ID_price_list.txt
                    echo $nome  >> name_ID_price_list.txt
                    echo $ID    >> name_ID_price_list.txt
                    echo $preco >> name_ID_price_list.txt
                    
                else
                    if [ "$tmp_preco" -gt "$preco" ]; then
                        # Sobrescreve as informações do jogo que acabou de ser buscado usando o sed
                        # pra substituir as linhas
                        # -0: Lê o arquivo inteiro para permitir substituição em múltiplas linhas
                        # -i: Permite edição para substituir
                        # -p: Pattern matching
                        # -e: Executa comando
                        perl -i -0pe "s/\n.*\n$ID\n.*\n/\n$nome\n$ID\n$preco\n/" name_ID_price_list.txt
                    fi
                fi

                echo -en "\r"
                echo -e "Game successfully updated. ID: $ID, Name: $nome"
                echo -n "Fetching games... ($count/$( wc -w <<< $game_IDs ))"
            fi
        done
        
        echo ""
        #echo $game_IDs
    ;;
    
    q ) # Does a search on the DB for the game's smallest price
        if [ ! -f "name_ID_price_list.txt" ]; then
            echo "History file doesnt exists!"
            echo ""
            
            continue
        fi

        if [ -z "$2" ]; then
            echo "Please inform the game's name: $0 -q <Name>"
            exit
        fi

        max_entries=0 # Show all entries entries by default
        count=1

        # If the user passes a new number of max entries to show, uses that number instead
        if [[ "$3" == [0-9]* ]]; then
            max_entries=$3
        fi

        # Searches how many lines contains the string passed as input
        num_matches=$( grep -c -ie "^.*$2.*$" name_ID_price_list.txt )

        if [ "$num_matches" -eq 0 ]; then
            echo "No matches found!"
            echo ""
            exit
        fi
        
        if [ "$max_entries" -eq 0 ]; then
            max_entries=$num_matches
            #echo "MAX ENTRIES = NUM MATCHES"
        fi

        # Se a consulta for muito pouco específica, vai retornar muitas entradas
        # Seta valor máximo de entradas a serem mostradas como 10. Passível de modificação
        if [ "$num_matches" -gt "$max_entries" ]; then
            echo "Displaying the first $((max_entries)):"
            
            num_matches=$max_entries
            
        else
            echo "Matches Found: $num_matches"
        fi

        let num_matches=num_matches+1

        # For each of the found entries, searches for the game name, ID and price
        while [ ! "$count" -eq "$num_matches" ]; do
            nome=$( grep -ie "^.*$2.*$" name_ID_price_list.txt | sed -n "$count p" )

            id=$( grep -A1 -iF "$nome" name_ID_price_list.txt | sed -n 2p )

            preco=$( grep -A1 -ie "^.*$id.*$" name_ID_price_list.txt | tail -n 1 )

            echo ""
            echo "Game: " $nome
            echo "Steam ID: " $id
            echo "Cheapest Recorded Price: R\$$(($preco/100)).$(($preco - 100*($preco/100)))"

            let count=count+1

        done
    ;;
        
    s )
        if [ -z "$2" ]; then
        echo "Please inform the game's name: $0 -s <Name>"
        exit
        fi
        
        # Search for all game IDs on the database that matches the string the user searched for
        game_IDs=$( cat name_ID_list.json | grep -oe "[^}{]*" | grep -ie "^.*$2.*$"| grep -oe "appid\":[^,]*" | sed "s/appid\"://" )
        
        # Create a file to store retrieved values if it doesnt exist already
        if [ ! -f "name_ID_price_list_2.txt" ]; then
            echo "" > name_ID_price_list_2.txt
        fi
        
        for ID in $game_IDs; do
            # Searches for the game on the API
            data=$( wget -qO - https://store.steampowered.com/api/appdetails?appids=$ID )
            
            # If there is no return goes to the next ID. There are multiple IDs that are not found
            # The reliability of the API is unknown
            if [ -z "$data" ]; then
                echo -en "\r"
                echo "Failed to fetch game. ID: $ID. Game not found"
                #echo -n "Fetching games... ($count/$( wc -w <<< $game_IDs ))"
                continue
            fi
            
            # Checks search status. If there's no success, dont update game
            status=$( echo $data | grep -o 'success":[a-z]*' --color=always | sed -n '1p' | cut -b 21- )

            # Removes trash from the end of the string
            status=${status:: -6}
            
            # Checks if the game fetch was successfull
            if [ $status == "false" ]; then
                echo -en "\r"
                echo -e "Failed to fetch game. ID: $ID. Success status = False"
                #echo -n "Fetching games... ($count/$( wc -w <<< $game_IDs ))"
                continue
                
            else # Else update game values
                # O sed é para trazer apenas a primeira linha e o cut é pra tirar o 'name":"' e 
                # 'final":"' da string do nome e do preço
                nome=$( echo $data | grep -o 'name":"[^"]*' --color=always | sed -n '1p' | cut -b 19- )
                
                if [ -z "$nome" ]; then
                    echo -en "\r"
                    echo "Failed to fetch game. ID: $ID. Name not found"
                    #echo -n "Fetching games... ($count/$( wc -w <<< $game_IDs ))"
                    continue
                fi
                
                nome=${nome:: -6}
                preco=$( echo $data | grep -o 'final":[0-9]*' --color=always | sed -n '1p' | cut -b 19- )
                
                if [ -z "$preco" ]; then
                    echo -en "\r"
                    echo "Failed to fetch games. ID: $ID. Price not found"
                    #echo -n "Fetching games... ($count/$( wc -w <<< $game_IDs ))"
                    continue
                fi
                
                preco=${preco:: -6}
                tmp_id=$( grep -e "^$ID$" name_ID_price_list_2.txt )
                tmp_preco=$( grep -A1 -e "^$ID$" name_ID_price_list_2.txt | tail -n 1 )

                #echo $tmp_preco

                # If entry doesnt exists, write it on the file. Otherwise swap the value if it is smaller
                if [ -z "$tmp_id" ]; then
                    # Write game's info  on the file
                    echo ""		>> name_ID_price_list_2.txt
                    echo $nome  >> name_ID_price_list_2.txt
                    echo $ID    >> name_ID_price_list_2.txt
                    echo $preco >> name_ID_price_list_2.txt
                    
                else
                    if [ "$tmp_preco" -gt "$preco" ]; then
                        # Sobrescreve as informações do jogo que acabou de ser buscado usando o sed
                        # pra substituir as linhas
                        # -0: Lê o arquivo inteiro para permitir substituição em múltiplas linhas
                        # -i: Permite edição para substituir
                        # -p: Pattern matching
                        # -e: Executa comando
                        perl -i -0pe "s/\n.*\n$ID\n.*\n/\n$nome\n$ID\n$preco\n/" name_ID_price_list_2.txt
                    fi
                fi

                echo -en "\r"
                echo -e "Game successfully updated. ID: $ID, Name: $nome"
                #echo -n "Fetching games... ($count/$( wc -w <<< $game_IDs ))"
            fi
        done
        
        echo ""
        
        max_entries=0 # Show all entries by default
        count=1

        # If the user passes a new number of max entries to show, uses that number instead
        if [[ "$3" == [0-9]* ]]; then
            max_entries=$3
        fi

        # Searches how many lines contains the string passed as input
        num_matches=$( grep -c -ie "^.*$2.*$" name_ID_price_list_2.txt )

        if [ "$num_matches" -eq 0 ]; then
            echo "No matches found!"
            echo ""
            exit
        fi
        
        if [ "$max_entries" -eq 0 ]; then
            max_entries=$num_matches
            #echo "MAX ENTRIES = NUM MATCHES"
        fi

        # Se a consulta for muito pouco específica, vai retornar muitas entradas
        # Seta valor máximo de entradas a serem mostradas como 10. Passível de modificação
        if [ "$num_matches" -gt "$max_entries" ]; then
            echo "Displaying the first $((max_entries)):"
            
            num_matches=$max_entries
            
        else
            echo "Matches Found: $num_matches"
        fi

        let num_matches=num_matches+1

        # For each of the found entries, searches for the game name, ID and price
        while [ ! "$count" -eq "$num_matches" ]; do
            nome=$( grep -ie "^.*$2.*$" name_ID_price_list_2.txt | sed -n "$count p" )

            id=$( grep -A1 -iF "$nome" name_ID_price_list_2.txt | sed -n 2p )

            preco=$( grep -A1 -ie "^.*$id.*$" name_ID_price_list_2.txt | tail -n 1 )

            echo ""
            echo "Game: " $nome
            echo "Steam ID: " $id
            echo "Cheapest Recorded Price: R\$$(($preco/100)).$(($preco - 100*($preco/100)))"

            let count=count+1

        done
    ;;
            
    \? ) 
        echo "Invalid option: $OPTARG" 1>&2
        echo "To see valid options please check the man page"
        #echo "Usage: $0 [OPTION]... [PARAMETER]..."
    ;;
    esac
done
