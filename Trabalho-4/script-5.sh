#!/bin/bash

if [ "$1" = "" ]; then
    exit 0
    
fi

if [[ "$2" == *"$1"* ]]; then
    echo "$1 está contida em $2"
    
fi

exit 0
