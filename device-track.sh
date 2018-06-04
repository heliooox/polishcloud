#!/bin/bash

open=`nmap -p 445 CLIENT-IP | grep open`
if [ -z "$open" ]; then
        echo "closed"
        exit 1
else
	ping -q -w 1 -c 1 OUR-IP > /dev/null && /root/git/polishcloud/encrypt.sh || exit 1
	exit 0
fi

