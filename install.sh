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
read RInSub

echo "[conf] enter Right ID (an email format): "
read RightID
echo "[conf] enter Left ID (an email format): "
read LeftID

#password  PSK

function pass () {
        read -s -p "[conf] enter PSK Key: " PSK1
        echo ""
        read -s -p "[conf] confirm PSK Key: " PSK2
        echo ""
        if [ "$PSK1" != "$PSK2" ]; then
                echo ""
		echo "PSK don't match - try again"
		echo ""
                pass
        else
                exit
        fi
}

pass

echo "[+] Setup ipsec connection..."

cat "" /etc/ipsec.conf
cat <<EOF>> /etc/ipsec.conf

conn %defult
	ikelifetime=28800s
	lifetime=3600s
	keyingtries=1
	keyexchange=ikev2

conn vpn-core
	authby=secret
	ike=3des-sha1-modp1024
	esp=3des-sha1
	left=%defaultroute
	leftsourceip=%config
	leftfirewall=yes
	right=$RExIP
	rightsubnet=$RInSub
	leftid=$LeftID
	rightid=$RightID
	auto=add

EOF

cat <<EOF>> /etc/ipsec.secrets

$RightID : PSK "$PSK1"

EOF


