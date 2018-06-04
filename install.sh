#!/bin/bash
#echo "[+] Update repos..."
#apt-get update
#echo "[+] Install ssh server..."
#apt-get -y install openssh-server

echo "[+] Install nmap..."
apt-get -y install nmap
echo "[+] Install strongswan..."
apt-get -y install strongswan iptables-persistent
echo "[+] Install pip..."
apt-get -y install python-pip
echo "[+] Install aws..."
pip install awscli --upgrade --user
echo "[+] Modify path..."
echo "export PATH=~/.local/bin:$PATH" >> ~/.profile
echo "[+] Reload profile..."
source ~/.profile
echo "[+] Configure aws..."
aws configure
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
        fi
}

pass

echo "[+] Setup ipsec connection..."

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

echo "[+] Configure Device-tracking..."
echo "[conf] Enter internal Client IP: "
read CLIENT_IP
echo "[conf] Enter Port Number ( cifs 445, MySQL 3306, SSH 22) : "
read PORT

cat <<EOF>> device-track2.sh
#!/bin/bash
open=\`nmap -p $PORT $CLIENT_IP | grep open\`
if [ -z "\$open" ]; then
        echo "closed"
        exit 1
else
        ping -q -w 1 -c 1 $RExIP > /dev/null && /root/git/polishcloud/encrypt.sh || exit 1
        exit 0
fi

EOF

echo "[+] Installation successfuly finished..."


