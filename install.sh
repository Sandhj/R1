#!/bin/bash

#// Warna
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'

# // Buat Direktori Utama
cd /root
mkdir -p /etc/xray

# SET DOMAIN
echo -e "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
    echo -e "${red}    ♦️${NC} ${green} CUSTOM SETUP DOMAIN VPS     ${NC}"
    echo -e "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
    read -rp "Enter Your Domain : " domen 
    echo $domen > /root/domain
    echo "$domen" > /root/domain
    echo "$domen" > /root/scdomain
    echo "$domen" > /etc/xray/domain
    echo "$domen" > /etc/xray/scdomain
    cp /root/domain /etc/xray/domain
    clear
 
# // Cek Root
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi

# // Ambil Informasi VPS
localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi

# // Set Local Time GMT +7
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# // Disable Ipv6
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

# // Install GoTop & BBR Plus
    # > pasang gotop
    gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v"$gotop_latest"_linux_amd64.deb"
    curl -sL "$gotop_link" -o /tmp/gotop.deb
    dpkg -i /tmp/gotop.deb >/dev/null 2>&1

    # > Pasang BBR Plus
    wget -qO /tmp/bbr.sh "${REPO}server/bbr.sh" >/dev/null 2>&1
    chmod +x /tmp/bbr.sh && bash /tmp/bbr.sh

# // Install Dependencies
wget -q https://raw.githubusercontent.com/Paper890/mysc/main/dependencies.sh;chmod +x dependencies.sh;./dependencies.sh
rm dependencies.sh
clear
    
# // Install SSH
echo -e "$green[INFO]$NC Install SSH"
sleep 2
clear
wget https://raw.githubusercontent.com/Paper890/mysc/main/ssh/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
clear

# // Instal Xray
echo -e "$green[INFO]$NC Install XRAY!"
sleep 2
clear
wget https://raw.githubusercontent.com/Paper890/mysc/main/xray/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
clear

# // Install Set BR
echo -e "$green[INFO]$NC Install SET-BR!"
wget https://raw.githubusercontent.com/Paper890/mysc/main/backup/set-br.sh && chmod +x set-br.sh && ./set-br.sh
clear

# // Install Websocket
echo -e "$green[INFO]$NC Install WEBSOCKET!"
wget https://raw.githubusercontent.com/Paper890/mysc/main/websocket/insshws.sh && chmod +x insshws.sh && ./insshws.sh
clear
wget https://raw.githubusercontent.com/Paper890/mysc/main/websocket/nontls.sh && chmod +x nontls.sh && ./nontls.sh
clear

# // Install Menu
echo -e "$green[INFO]$NC Download Menu"
sleep 2
wget https://raw.githubusercontent.com/Paper890/mysc/main/update/update.sh && chmod +x update.sh && ./update.sh
rm -f update.sh
clear

# // Setting Default Menu
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END
chmod 644 /root/.profile

curl -sS ifconfig.me > /etc/myipvps

# // Informasi Script 
TEXT="
**********************************************
*                                            *
*   🚀 TERIMA KASIH TELAH MENGGUNAKAN        *
*       SCRIPT INI!                          *
*                                            *
*   © 2025 - Script By San                   *
*                                            *
**********************************************
"

echo -e "$TEXT"

# // Hapus File Instalasi 
rm /root/*

# // Reboot Atau Tidak
echo -e "[ ${yell}WARNING${NC} ] Do you want to reboot now ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
fi
