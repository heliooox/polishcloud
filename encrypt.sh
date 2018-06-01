#!/bin/bash
Nameconst=TEST.OGRODOWA.$(date +%F_%R)
zip -r /mnt/backup/$Nameconst /mnt/backup 
gpg --yes --encrypt --recipient "TEST.OGRODOWA" "/mnt/backup/$Nameconst"
cp "/mnt/backup/$Nameconst" /mnt/vpn-core/
echo "$Nameconst" >> /var/log/polishcloud.log

