#!/bin/bash

open=`nmap -p 445 192.168.3.57 | grep open`
if [ -z "$open" ]; then
        echo "closed"
        exit 1
else
	ping -q -w 1 -c 1 212.14.7.25 > /dev/null && /root/git/polishcloud/encrypt.sh || exit 1
	exit 0
fi

