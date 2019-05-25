#!/bin/bash

echo "$*" | tr -d [:blank:] #Utiliza a opção -d do tr para remover todos os whitespaces da entrada
