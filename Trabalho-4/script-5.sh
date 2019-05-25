#!/bin/bash

if [ "$1" = "" ]; then
    exit 0
    
fi

if [[ "$2" == *"$1"* ]]; then #Utiliza wildcard * para expandir a substring para ambos os lados
    echo "$1 está contida em $2" #Se der um match, a substring existe na string 
    
fi

exit 0
