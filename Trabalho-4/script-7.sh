#!/bin/bash

cat /etc/passwd | while read line #Lê cada linha do arquivo
do
	#Para cada linha, utiliza o awk para remover os ":" separadores 
	#e utiliza o printf para mostrar a saída na formatação desejada
	echo "$line" | awk -F ':' '{printf "%s\t%s\n", $1, $5}' | tr ',' ' '
done