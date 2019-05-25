#!/bin/bash

num=0

for var in "$@" #Para cada parâmetro do script
do
	num=$(($num + 1)) #Incrementa a variável e mostra na tela seu valor + parâmetro
	echo "Parâmetro $num: $var"
done