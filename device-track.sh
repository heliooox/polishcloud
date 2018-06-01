#!/bin/bash

open=`nmap -p 445 192.168.3.57 | grep open`
if [ -z "$open" ]; then
        echo "closed"
        exit 1
else
        encrypt.sh
        exit 0
fi

