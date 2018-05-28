#!/bin/bash
echo "[+] Update repos..."
apt-get update
echo "[+] Install ssh server..."
apt-get -y install openssh-server
echo "[+] Install strongswan..."
apt-get -y install strongswan
