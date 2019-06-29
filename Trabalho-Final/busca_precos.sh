#!/bin/bash

while getopts ":ugq" opt; do
  case ${opt} in
    u ) # Atualiza o banco de dados: Nomes/ID's
	wget -qO - http://api.steampowered.com/ISteamApps/GetAppList/v0001/ > name_ID_list.json
      ;;
    g ) # Atualiza o banco de dados: Nomes/ID's/Preço

	# Busca todos os ID's dos jogos no banco de dados
	game_IDs=$( cat name_ID_list.json | grep 'appid' | grep -oP '[^\D]*' )
	
	# Cria um arquivo para guardar os valores encontrados
	# A ideia é depois substituir valores, não sobrescrever o arquivo
	# mas por enquanto está assim
	echo "" > name_ID_price_list.txt
		
	# Para cada um dos ID's dos jogos no banco de dados
	for ID in $game_IDs; do

		# Faz a busca pelo jogo na API
		data=$( wget -qO - https://store.steampowered.com/api/appdetails?appids=$ID )

		# Se não retornou nada, parte para o próximo ID. Muitos não são encontrados mesmo
		# Não sabemos a qualidade da API com que estamos lidando
		if [ -z "$data" ]; then
			echo "Falha o buscar jogo. ID: $ID. Jogo não encontrado"
			continue
		fi
		
		# Checa o status da busca. Se não houve êxito, não atualiza jogo
		status=$( echo $data | grep -o 'success":[a-z]*' --color=always | sed -n '1p' | cut -b 21- )

		# Remove lixo do fim da string
		status=${status:: -6}

		# Checa se houve sucesso na hora de buscar o jogo
		if [ $status == "false" ]; then
			echo "Falha ao buscar jogo. ID: $ID. Success status == False"
			continue
		else

			#echo "$ID"

			# Caso contrário, atualiza valores do jogo

			# O sed é para trazer apenas a primeira linha e o cut é pra tirar o 'name":"' e 
			# 'final":"' da string do nome e do preço

			nome=$( echo $data | grep -o 'name":"[^"]*' --color=always | sed -n '1p' | cut -b 19- )
			if [ -z "$nome" ]; then
				echo "Falha o buscar jogo. ID: $ID. Nome não encontrado"
				continue
			fi
			nome=${nome:: -6}

			preco=$( echo $data | grep -o 'final":[0-9]*' --color=always | sed -n '1p' | cut -b 19- )
			if [ -z "$preco" ]; then
				echo "Falha o buscar jogo. ID: $ID. Preço não encontrado"
				continue
			fi
			preco=${preco:: -6}

			# Insere infos do jogo no arquivo
			echo $nome  >> name_ID_price_list.txt
			echo $ID    >> name_ID_price_list.txt
			echo $preco >> name_ID_price_list.txt
			echo ""		>> name_ID_price_list.txt

			echo "Jogo atualizado com sucesso. ID: $ID, Nome: $nome"
		fi
	done
		#echo $game_IDs
      ;;
    q ) # Faz uma busca no banco de dados pelo menor preço do jogo. To be implemented
	echo $2
      ;;
    \? ) echo "Como usar: cmd [-u] [-g] [-q]"
		 echo "Opção Inválida: $OPTARG" 1>&2
      ;;
  esac
done