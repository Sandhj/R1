#!/bin/bash

# // Buat Folder Xray
cd /root
mkdir -p /etc/xray

# // Setup Domain
echo -e "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
    echo -e "${red}    ♦️${NC} ${green} CUSTOM SETUP DOMAIN VPS     ${NC}"
    echo -e "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
    read -rp "Enter Your Domain : " domen 
    echo $domen > /root/domain
    echo "$domen" > /root/domain
    echo "$domen" > /root/scdomain
    echo "$domen" > /etc/xray/domain
    echo "$domen" > /etc/xray/scdomain
   
# // Set Local Time
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# // Disable Ipv6
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

# // Install Dependencies
apt install git curl -y >/dev/null 2>&1
apt update -y
apt install python -y
apt update -y
apt dist-upgrade -y
apt install sudo -y
apt-get remove --purge ufw firewalld -y 
apt-get remove --purge exim4 -y 

apt install -y screen curl jq bzip2 gzip coreutils rsyslog iftop \
htop zip unzip net-tools sed gnupg gnupg1 \
bc sudo apt-transport-https build-essential dirmngr libxml-parser-perl neofetch screenfetch git lsof \
openssl openvpn easy-rsa fail2ban tmux \
stunnel4 vnstat squid3 \
dropbear  libsqlite3-dev \
socat cron bash-completion ntpdate xz-utils sudo apt-transport-https \
gnupg2 dnsutils lsb-release chrony

# // Install Vnstat
/etc/init.d/vnstat restart
wget -q https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz >/dev/null 2>&1
rm -rf /root/vnstat-2.6 >/dev/null 2>&1

apt install -y libnss3-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev libcap-ng-utils libselinux1-dev libcurl4-nss-dev flex bison make libnss3-tools libevent-dev xl2tpd pptpd

# // End Dependencies
    
#install ssh ovpn
echo -e "Install SSH"
wget https://raw.githubusercontent.com/Paper890/mysc/main/ssh/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
#Instal Xray
echo -e "Install Xray"
wget https://raw.githubusercontent.com/Paper890/mysc/main/xray/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
#Install Websocket
echo -e "Install WEBSOCKET!"
wget https://raw.githubusercontent.com/Paper890/mysc/main/websocket/insshws.sh && chmod +x insshws.sh && ./insshws.sh
wget https://raw.githubusercontent.com/Paper890/mysc/main/websocket/nontls.sh && chmod +x nontls.sh && ./nontls.sh
#Install Menu
echo -e "Install Menu"
wget https://raw.githubusercontent.com/Paper890/mysc/main/update/menu.sh && chmod +x menu.sh && ./menu.sh
# // Setup Default Menu
clear


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

echo -e " ISNTALL BERHASIL"
rm /root/*
