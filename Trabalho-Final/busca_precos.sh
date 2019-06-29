#!/bin/bash

while getopts ":ugq" opt; do
  case ${opt} in
    u ) # Atualiza o banco de dados: Nomes/ID's
	wget -qO - http://api.steampowered.com/ISteamApps/GetAppList/v0001/ > name_ID_list.json
      ;;
    g ) # Atualiza o banco de dados: Nomes/ID's/Preço

	# Busca todos os ID's dos jogos no banco de dados
	game_IDs=$( cat name_ID_list.json | grep 'appid' | grep -oP '[^\D]*' )
	
	# Cria um arquivo para guardar os valores encontrados, se o mesmo já não existir
	if [ ! -f "name_ID_price_list.txt" ]; then
		echo "" > name_ID_price_list.txt
	fi

	count=0

	echo "Buscando jogos... ($count/$( wc -w <<< $game_IDs ))"
		
	# Para cada um dos ID's dos jogos no banco de dados
	for ID in $game_IDs; do

		# Faz a busca pelo jogo na API
		data=$( wget -qO - https://store.steampowered.com/api/appdetails?appids=$ID )

		count=$( expr $count + 1 )

		# Se não retornou nada, parte para o próximo ID. Muitos não são encontrados mesmo
		# Não sabemos a qualidade da API com que estamos lidando
		if [ -z "$data" ]; then
			echo -en "\r"
			echo "Falha ao buscar jogo. ID: $ID. Jogo não encontrado"
			echo -n "Buscando jogos... ($count/$( wc -w <<< $game_IDs ))"
			continue
		fi
		
		# Checa o status da busca. Se não houve êxito, não atualiza jogo
		status=$( echo $data | grep -o 'success":[a-z]*' --color=always | sed -n '1p' | cut -b 21- )

		# Remove lixo do fim da string
		status=${status:: -6}

		# Checa se houve sucesso na hora de buscar o jogo
		if [ $status == "false" ]; then
			echo -en "\r"
			echo -e "Falha ao buscar jogo. ID: $ID. Success status == False"
			echo -n "Buscando jogos... ($count/$( wc -w <<< $game_IDs ))"
			continue
		else

			#echo "$ID"

			# Caso contrário, atualiza valores do jogo

			# O sed é para trazer apenas a primeira linha e o cut é pra tirar o 'name":"' e 
			# 'final":"' da string do nome e do preço

			nome=$( echo $data | grep -o 'name":"[^"]*' --color=always | sed -n '1p' | cut -b 19- )
			if [ -z "$nome" ]; then
				echo -en "\r"
				echo "Falha ao buscar jogo. ID: $ID. Nome não encontrado"
				echo -n "Buscando jogos... ($count/$( wc -w <<< $game_IDs ))"
				continue
			fi
			nome=${nome:: -6}

			preco=$( echo $data | grep -o 'final":[0-9]*' --color=always | sed -n '1p' | cut -b 19- )
			if [ -z "$preco" ]; then
				echo -en "\r"
				echo "Falha ao buscar jogo. ID: $ID. Preço não encontrado"
				echo -n "Buscando jogos... ($count/$( wc -w <<< $game_IDs ))"
				continue
			fi
			preco=${preco:: -6}


			tmp_id=$( grep -e "^$ID$" name_ID_price_list.txt )
			tmp_preco=$( grep -A1 -e "^$ID$" name_ID_price_list.txt | tail -n 1 )

			#echo $tmp_preco

			# Se entrada ainda não existir, insere ela no arquivo. Caso contrário
			# substitui o valor, se for menor
			if [ -z "$tmp_id" ]; then
				#Insere infos do jogo no arquivo
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
			echo -e "Jogo atualizado com sucesso. ID: $ID, Nome: $nome"
			echo -n "Buscando jogos... ($count/$( wc -w <<< $game_IDs ))"
		fi
	done
	echo ""
		#echo $game_IDs
      ;;
    q ) # Faz uma busca no banco de dados pelo menor preço do jogo. To be implemented


	if [ ! -f "name_ID_price_list.txt" ]; then
		echo "Arquivo de histórico não existe"
	fi

	if [ -z "$2" ]; then
		echo "Favor informar o nome do Jogo: $0 -q <Nome>"
		exit
	fi

	# Busca quantidade de linhas que contém a string passada como input
	num_matches=$( grep -c -ie "^.*$2.*$" name_ID_price_list.txt )

	let num_matches=num_matches+1

	# Se a consulta for muito pouco específica, vai retornar muitas entradas
	# Seta valor máximo de entradas a serem mostradas como 10. Passível de modificação
	if [ "$num_matches" -gt 10 ]; then
		echo "Too many matches. Please be more specific with your search"
		exit
	fi

	echo $num_matches "Matches Found:"

	count=1
	p="p"

	# Para cada uma das entradas encontradas, buasca o nome, ID e preço do jogo
	while [ ! "$count" -eq "$num_matches" ]; do

		nome=$( grep -ie "^.*$2.*$" name_ID_price_list.txt | sed -n "$count p" )

		id=$( grep -A1 -ie "^.*$nome.*$" name_ID_price_list.txt | tail -n 1 )

		preco=$( grep -A1 -ie "^.*$id.*$" name_ID_price_list.txt | tail -n 1 )

		echo ""
		echo "Game: " $nome
		echo "Steam ID: " $id
		echo "Cheapest Recorded Price: R\$$(($preco/100)).$(($preco - 100*($preco/100)))"

		let count=count+1

	done

      ;;
    \? ) echo "Como usar: cmd [-u] [-g] [-q]"
		 echo "Opção Inválida: $OPTARG" 1>&2
      ;;
  esac
done