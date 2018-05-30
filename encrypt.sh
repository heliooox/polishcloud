#!/bin/bash
Nameconst=WWW.$(date +%F_%R)
zip -r /mnt/backup/$Nameconst /mnt/backup 
gpg --yes --encrypt --recipient "WWW" "/mnt/backup/$Nameconst"
cp "/mnt/backup/$Nameconst" /mnt/vpn-core/
echo "$Nameconst" >> /var/log/polishcloud.log

