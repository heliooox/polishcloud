#!/bin/bash
echo "[+] Update repos..."
apt-get update
echo "[+] Install ssh server..."
apt-get -y install openssh-server
echo "[+] Install strongswan..."
apt-get -y install strongswan iptables-persistent
echo "[+] Install pip..."
apt-get -y install python-pip
echo "[+] Install aws..."
pip install awscli
echo "[+] configure strongswan..."
echo "[conf] enter Right External IP: "
read RExIP
echo "[conf] enter Right Internal subnet: "
read RInIP

#password  PSK

function pass () {
        read -s -p "[conf] enter PSK Key: " PSK1
        echo ""
        read -s -p "[conf] confirm PSK Key: " PSK2
        echo ""
        if [ $PSK1 != $PSK2 ]; then
                echo ""
		echo "PSK don't match - try again"
		echo ""
                pass
        else
                exit
        fi
}

pass





