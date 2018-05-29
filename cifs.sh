#!/bin/bash

#this script mount's windows cifs share peramanently on reboot
#to refresh working share execute: 
# $ umount -l /share
# $ umount -t /share
# $ mount -a

apt-get -y update
apt-get -y install cifs-utils

mkdir -p /mnt/win

read -p "Username: " User

function pass () {
        read -s -p "[conf] enter windows password: " PSK1
        echo ""
        read -s -p "[conf] confirm windows password: " PSK2
        echo ""
        if [ "$PSK1" != "$PSK2" ]; then
                echo ""
                echo "[error] Password's don't match - try again"
                echo ""
                pass
	fi
}
pass

touch /etc/cifspasswd
echo "username=$User" >> /etc/cifspasswd
echo "password=$PSK1" >> /etc/cifspasswd
chown 0.0 /etc/cifspasswd
chmod 600 /etc/cifspasswd

read -p "[conf] IP address of windows host: " IP
echo ""
read -p "[conf] Shared folder name: " SH

if [ ! -f /etc/fstab.old ]; then
	cp /etc/fstab /etc/fstab.old
fi

echo "//$IP/$SH/ /mnt/win cifs credentials=/etc/cifspasswd,sec=ntlmssp  0  0" >> /etc/fstab 
mount -a

