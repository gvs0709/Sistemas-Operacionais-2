#!/bin/bash

#Para cada linha, utiliza o awk para remover os ":" separadores e 
#utiliza o printf para mostrar a saída na formatação desejada

cat /etc/passwd | awk -F ':' '{printf "%s\n", $7}' | sort | uniq