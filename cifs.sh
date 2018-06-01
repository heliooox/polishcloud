#!/bin/bash

#this script mount's windows cifs share peramanently on reboot
#to refresh working share execute: 
# $ umount -l /share
# $ umount -t /share
# $ mount -a

#apt-get -y update
apt-get -y install cifs-utils

mkdir -p /mnt/backup
mkdir -p /mnt/vpn-core

read -p "Windows username: " User

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

read -p "NAS username: " User2

function pass-nas () {
        read -s -p "[conf] enter NAS password: " NAS1
        echo ""
        read -s -p "[conf] confirm NAS password: " NAS2
        echo ""
        if [ "$NAS1" != "$NAS2" ]; then
                echo ""
                echo "[error] Password's don't match - try again"
                echo ""
                pass-nas
	fi
}
pass-nas

touch /etc/cifspasswd
echo "username=$User" >> /etc/cifspasswd
echo "password=$NAS1" >> /etc/cifspasswd
chown 0.0 /etc/cifspasswd
chmod 600 /etc/cifspasswd

touch /etc/cifspasswdnas
echo "username=$User2" >> /etc/cifspasswdnas
echo "password=$NAS1" >> /etc/cifspasswdnas
chown 0.0 /etc/cifspasswdnas
chmod 600 /etc/cifspasswdnas

read -p "[conf] IP address of windows host: " IP
echo ""
read -p "[conf] Shared folder name: " SH

read -p "[conf] IP address of NAS host: " IP2
echo ""
read -p "[conf] NAS Shared folder name : " SH2

if [ ! -f /etc/fstab.old ]; then
	cp /etc/fstab /etc/fstab.old
fi

echo "//$IP/$SH/ /mnt/backup cifs credentials=/etc/cifspasswd,sec=ntlmssp  0  0" >> /etc/fstab
echo "//$IP2/$SH2/ /mnt/vpn-core cifs credentials=/etc/cifspasswdnas,sec=ntlmssp  0  0" >> /etc/fstab
mount -a

