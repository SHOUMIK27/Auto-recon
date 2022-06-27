#!/usr/bin/bash

if [ -z "$1" ]
then
        echo "Usage: ./automate.sh <IP>"
        exit 1
fi

printf "\n----- NMAP -----\n\n" > results0

echo "Running Nmap..."
nmap $1 | tail -n +5 | head -n -3 >> results0

while read line
do
        if [[ $line == *open* ]] && [[ $line == *http* ]] && [[ $line == *smtp* ]] && [[ $line == *ssh* ]] 
        then
                echo "Running Gobuster..."
                gobuster dir -u $1 -w /usr/share/wordlists/dirb/common.txt -qz > temp1

        echo "Running WhatWeb..."
        whatweb $1 -v > temp2
        fi
done < results0

if [ -e temp1 ]
then
        printf "\n----- DIRS -----\n\n" >> results0
        cat temp1 >> results0
        rm temp1
fi

if [ -e temp2 ]
then
    printf "\n----- WEB -----\n\n" >> results0
        cat temp2 >> results0
        rm temp2
fi

cat results0


