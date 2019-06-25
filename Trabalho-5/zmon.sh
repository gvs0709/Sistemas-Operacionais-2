#!/bin/bash

if [ "$1" = "" ]; then
    echo "É necessário pelo menos 1 parâmetro!"
    echo "Uso: $0 [nº de zombies] [tempo do daemon em segundos] (opcional)"
    echo ""
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
    echo "z - cria mais zombies"
    echo "k - mata zombies"
    echo "d - mata daemon e encerra este script"
    echo -n "> "
    read op
    echo ""
    
    if [ "$op" = "z" ]; then
        echo -n "Quantos zombies? "
        read nZ
        
        if [[ "$nZ" = [^0-9]* ]]; then
            ./zombie $1
            nZombie=$(($nZombie+1))
        
            echo "Feito. $nZombie zombies para matar (usado argumento padrão: $1)"
            echo ""
            
        else
            ./zombie $nZ
            nZombie=$(($nZombie+1))
            
            echo "Feito. $nZombie zombies para matar (usado $nZ)"
            echo ""
        fi
    
    elif [ "$op" = "k" ]; then
        if [ "$nZombie" -gt 0 ]; then
            PID=$(ps axo comm,pid | grep ^"zombie" | grep -v "zombie".*"<" | head -n 1 | grep -Eo [0-9]*$) # Pega o pid dos zombies na ordem em que foram criados
            
            kill -15 ${PID} >/dev/null 2>&1 # Mata os zombies na ordem em que foram criados
            nZombie=$(($nZombie-1))
            echo "Feito. $nZombie zombies para matar"
            echo ""
            
        else
            echo "Não há zombies para matar!"
            echo ""
        fi
    
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
