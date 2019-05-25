#!/bin/bash

#Para cada linha, utiliza o awk para remover os ":" separadores, 
#utiliza o printf para mostrar a saída na formatação desejada e 
#remove "," do final da linha

#cat /etc/passwd | awk -F ':' '{printf "%s\t%s\n", $1, $5}' | tr -d ,
getent passwd | awk -F ':' '{printf "%s\t%s\n", $1, $5}' | tr -d ,
