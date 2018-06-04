#!/bin/bash

apt-get -y install rng-tools
apt-get -y install zip
echo "HRNGDEVICE=/dev/urandom" >> /etc/default/rng-tools
service rng-tools restart

: > gen-key-script

read -p "[config] Company name: " Name
read -p "[config] Company Email: " Email

echo "[+] Generating config file..."

cat <<EOF>> gen-key-script
Key-Type: 1
Key-Length: 2048
Subkey-Type: 1
Subkey-Length: 2048
Name-Real: $Name
Name-Email: $Email
Expire-Date: 0

EOF

gpg --batch --gen-key gen-key-script

service rng-tools stop

echo "[+] Generate encryption script..."

: > encrypt.sh
: > /var/log/polishcloud.log


cat <<EOF>> encrypt.sh
#!/bin/bash
ipsec up vpn-core
sleep 10
mount -a
sleep 10
Nameconst=$Name.\$(date +%F_%R)
zip -r /mnt/backup/\$Nameconst /mnt/backup
sleep 10
gpg --yes --encrypt --recipient "$Name" "/mnt/backup/\$Nameconst"
if cp /mnt/backup/\$Nameconst.gpg /mnt/vpn-core/
then
        echo "Copy Success"
        echo "$Nameconst" >> /var/log/polishcloud.log
        ipsec down vpn-core
else
        echo "Copy Failure, exit status \$?"
        ipsec down vpn-core
fi

EOF

echo "[+] Finished..."

