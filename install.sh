#!/bin/bash

#Link Hosting
REPO="https://raw.githubusercontent.com/Sandhj/R1/main/"

cd /root
mkdir -p /etc/xray
# SET DOMAIN
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "     .:: Enter Your Domain Below ::.      " 
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e""
read -rp "Enter Your Domain : " domen 
echo "$domen" > /root/domain
echo "$domen" > /root/scdomain
echo "$domen" > /etc/xray/domain
echo "$domen" > /etc/xray/scdomain
echo "IP=$domen" > /var/lib/ssnvpn-pro/ipvps.conf

clear
 
#Set Local Time 
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

#Disable IPv6
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

#Instal Dependencies
apt install git curl -y

apt update -y
apt install python -y
apt update -y
apt dist-upgrade -y
apt install sudo -y
apt-get remove --purge ufw firewalld -y 
apt-get remove --purge exim4 -y 
apt-get install nodejs -y


apt install -y screen curl jq bzip2 gzip coreutils rsyslog iftop \
htop zip unzip net-tools sed gnupg gnupg1 \
bc sudo apt-transport-https build-essential dirmngr libxml-parser-perl neofetch screenfetch git lsof \
openssl openvpn easy-rsa fail2ban tmux \
stunnel4 vnstat squid3 \
dropbear  libsqlite3-dev \
socat cron bash-completion ntpdate xz-utils sudo apt-transport-https \
gnupg2 dnsutils lsb-release chrony

apt install -y libnss3-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev libcap-ng-utils libselinux1-dev libcurl4-nss-dev flex bison make libnss3-tools libevent-dev xl2tpd pptpd

#Install Gotop
gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v"$gotop_latest"_linux_amd64.deb"
curl -sL "$gotop_link" -o /tmp/gotop.deb
dpkg -i /tmp/gotop.deb >/dev/null 2>&1

#Install BBR
wget -q -O /usr/bin/bbr "${REPO}ssh/bbr.sh"
chmod +x /usr/bin/bbr
bbr >/dev/null 2>&1
rm /usr/bin/bbr >/dev/null 2>&1

    
#Instal Paket Vpn
wget ${REPO}ssh/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
wget ${REPO}xray/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
wget ${REPO}websocket/insshws.sh && chmod +x insshws.sh && ./insshws.sh
wget ${REPO}websocket/nontls.sh && chmod +x nontls.sh && ./nontls.sh

#Install Tools
wget ${REPO}update/update.sh && chmod +x update.sh && ./update.sh

#Buat Default Menu
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

#Install Vnstat
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


echo -e " SUKSES INSTALASI"

#Hapus Semua File Instalasi
rm /root/* >/dev/null 2>&1
