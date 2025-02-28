#!/bin/bash

#Link Hosting
REPO="https://raw.githubusercontent.com/Sandhj/R1/main/"

wget -q -O /usr/bin/menu "${REPO}update/menu.sh" && chmod +x /usr/bin/menu
wget -q -O /usr/bin/menu-vmess "${REPO}update/menu-vmess.sh" && chmod +x /usr/bin/menu-vmess
wget -q -O /usr/bin/menu-vless "${REPO}update/menu-vless.sh" && chmod +x /usr/bin/menu-vless
wget -q -O /usr/bin/menu-trojan "${REPO}update/menu-trojan.sh" && chmod +x /usr/bin/menu-trojan
wget -q -O /usr/bin/menu-ssh "${REPO}update/menu-ssh.sh" && chmod +x /usr/bin/menu-ssh

wget -q -O /usr/bin/menu-set "${REPO}update/menu-set.sh" && chmod +x /usr/bin/menu-set 
wget -q -O /usr/bin/menu-backup "${REPO}update/menu-backup.sh" && chmod +x /usr/bin/menu-backup
wget -q -O /usr/bin/mbandwith "${REPO}update/menu-bandwith.sh" && chmod +x /usr/bin/mbandwith
