#!/bin/bash

apt-get -y install rng-tools
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


