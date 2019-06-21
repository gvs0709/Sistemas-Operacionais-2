#!/bin/bash

if [ "$1" = "" ]; then
    echo "É necessário pelo menos 1 parâmetro!"
    echo "Uso: $0 [nº de zombies] [tempo do daemon em segundos]"
    exit 0
fi

echo "Rodando zombie com parâmetro $1..."

./zombie $1 # Roda o executável zombie

nZombie=1

if [ "$2" = "" ]; then
    echo "Rodando daemon sem parâmetro..."
    echo ""
    
    ./daemon # Roda o executável daemon com tempo padrão
    
else
    echo "Rodando daemon com parâmetro $2..."
    echo ""
    
    ./daemon $2 # Roda o executável daemon com tempo passado
fi

while true; do
    echo "Escolha uma opção:"
    echo "z - cria mais $1 zombies"
    echo "k - mata $1 zombies"
    echo "d - mata daemon e encerra este script"
    echo -n "> "
    read op
    echo ""
    
    if [ "$op" = "z" ]; then
        ./zombie $1
        nZombie=$(($nZombie+1))
        
        echo "Feito. $nZombie (x $1) zombies para matar"
        echo ""
    
    elif [ "$op" = "k" ]; then
        PID=$(ps axo comm,pid | grep ^"zombie" | grep -v ">$" | head -n 1 | grep -Eo [0-9]*$) # Pega o pid dos zombies n ordem em que foram criados
        
        kill -15 ${PID} >/dev/null 2>&1 # Mata os zombies na ordem em que foram criados
        nZombie=$(($nZombie-1))
        echo "Feito. $nZombie (x $1) zombies para matar"
        echo ""
    
    elif [ "$op" = "d" ]; then
        PID=$(ps axo comm,pid | grep ^"daemon" | head -n 1 | grep -Eo [0-9]*$) # Pega o pid do daemon
        
        kill -15 $PID >/dev/null 2>&1 # Mata o daemon
        echo "Saindo..."
        
        while [ "$nZombie" -gt 0 ]; do
            PID=$(ps axo comm,pid | grep ^"zombie" | grep -v ">$" | head -n 1 | grep -Eo [0-9]*$)
            
            kill -15 ${PID} >/dev/null 2>&1
            nZombie=$(($nZombie-1))
        done
        
        break # Sai do loop e encerra o script
        
    else
        echo "Opção invalida!"
        echo ""
    fi
done

exit 0
