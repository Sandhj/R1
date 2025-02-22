#!/bin/bash
clear
apt update && apt upgrade -y
cd /root


if [ "${EUID}" -ne 0 ]; then
echo "You need to run this script as root"
exit 1
fi

if [ "$(systemd-detect-virt)" == "openvz" ]; then
echo "OpenVZ is not supported"
exit 1
fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')

if [[ "2" != "2" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi

if [[ ! -f /root/.isp ]]; then
curl -sS ipinfo.io/org?token=44ae7fd0b5d0d5 > /root/.isp
fi
if [[ ! -f /root/.city ]]; then
curl -sS ipinfo.io/city?token=44ae7fd0b5d0d5 > /root/.city
fi
if [[ ! -f /root/.myip ]]; then
curl -sS ipv4.icanhazip.com > /root/.myip
fi

export MYIP=$(cat /root/.myip);
export ISP=$(cat /root/.isp);
export CITY=$(cat /root/.city);
source /etc/os-release


apt install build-essential -y && apt-get install -y jq && apt-get install shc && apt install -y bzip2 gzip coreutils screen curl >/dev/null 2>&1

mkdir -p /var/lib/ >/dev/null 2>&1
echo "IP=" >> /var/lib/ipvps.conf
clear


if [[ "$( uname -m | awk '{print $1}' )" == "x86_64" ]]; then
    echo -ne
else
    echo -e "${r} Your Architecture Is Not Supported ( ${y}$( uname -m )${NC} )"
    exit 1
fi

if [[ ${ID} == "ubuntu" || ${ID} == "debian" ]]; then
    echo -ne
else
    echo -e " ${r}This Script only Support for OS ubuntu 20.04 & debian 10"
    exit 0
fi
clear


cd
echo -e "╭══════════════════════════════════════════╮"
echo -e "│ INSERT YOUR DOMAIN BELOW"
echo -e "╰══════════════════════════════════════════╯"
read -rp "Masukan domain kamu Disini : " -e dnss


rm -rf /etc/xray
rm -rf /etc/v2ray
rm -rf /etc/nsdomain
rm -rf /etc/per
mkdir -p /etc/xray
mkdir -p /etc/v2ray
mkdir -p /etc/nsdomain
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/xray/slwdomain
touch /etc/v2ray/scdomain
echo "$dnss" > /root/domain
echo "$dnss" > /root/scdomain
echo "$dnss" > /etc/xray/scdomain
echo "$dnss" > /etc/v2ray/scdomain
echo "$dnss" > /etc/xray/domain
echo "$dnss" > /etc/v2ray/domain
echo "IP=$dnss" > /var/lib/ipvps.conf
cd
sleep 1
clear

inst_tools(){
cd
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1
clear
wget https://raw.githubusercontent.com/GeKaStore/autoscript-vip/main/tools.sh &> /dev/null
chmod +x tools.sh >/dev/null 2>&1
bash tools.sh >/dev/null 2>&1
clear
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
apt install git curl -y >/dev/null 2>&1
apt install python -y >/dev/null 2>&1
}
inst_ssh(){
  wget https://raw.githubusercontent.com/GeKaStore/autoscript-vip/main/install/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh >/dev/null 2>&1
}
inst_xray(){
  wget https://raw.githubusercontent.com/GeKaStore/autoscript-vip/main/install/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh >/dev/null 2>&1
}
inst_ws(){
  wget https://raw.githubusercontent.com/GeKaStore/autoscript-vip/main/sshws/insshws.sh && chmod +x insshws.sh && ./insshws.sh >/dev/null 2>&1
}
inst_backup(){
  wget https://raw.githubusercontent.com/GeKaStore/autoscript-vip/main/install/set-br.sh && chmod +x set-br.sh && ./set-br.sh >/dev/null 2>&1
}
inst_ohp(){
  wget https://raw.githubusercontent.com/GeKaStore/autoscript-vip/main/sshws/ohp.sh && chmod +x ohp.sh && ./ohp.sh >/dev/null 2>&1
}
inst_extramenu(){
  wget https://raw.githubusercontent.com/GeKaStore/autoscript-vip/main/update.sh && chmod +x update.sh && ./update.sh >/dev/null 2>&1
}
inst_slowdns(){
  wget https://raw.githubusercontent.com/GeKaStore/autoscript-vip/main/slowdns/installsl.sh && chmod +x installsl.sh && bash installsl.sh >/dev/null 2>&1
}
inst_udp(){
  wget https://raw.githubusercontent.com/GeKaStore/autoscript-vip/main/install/udp-custom.sh && chmod +x udp-custom.sh && bash udp-custom.sh >/dev/null 2>&1
}
inst_noobz(){
  wget https://raw.githubusercontent.com/GeKaStore/autoscript-vip/main/noobz/noobzvpns.zip >/dev/null 2>&1
  unzip noobzvpns.zip >/dev/null 2>&1
  chmod +x noobzvpns/*
  cd noobzvpns
  bash install.sh >/dev/null 2>&1
  rm -rf noobzvpns
  systemctl restart noobzvpns
}
inst_limitxray(){
  wget https://raw.githubusercontent.com/GeKaStore/autoscript-vip/main/bin/limit.sh && chmod +x limit.sh && ./limit.sh >/dev/null 2>&1
}
inst_trojan(){
  wget https://raw.githubusercontent.com/GeKaStore/autoscript-vip/main/install/ins-trgo.sh && chmod +x ins-trgo.sh && ./ins-trgo.sh >/dev/null 2>&1
}

start_instalasi

}

function start_instalasi(){
lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}         PROCCESS INSTALL TOOLS         ${NC}${BIBlue} │${NC}"
lane_bawah
fun_bar 'inst_tools'

lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}     PROCCESS INSTALL SSH & OVPN        ${NC}${BIBlue} │${NC}"
lane_bawah
fun_bar 'inst_ssh'

lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}         PROCCESS INSTALL XRAY          ${NC}${BIBlue} │${NC}"
lane_bawah
fun_bar 'inst_xray'

lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}     PROCCESS INSTALL WEBSOCKET SSH     ${NC}${BIBlue} │${NC}"
lane_bawah
fun_bar 'inst_ws'

lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}      PROCCESS INSTALL BACKUP MENU      ${NC}${BIBlue} │${NC}"
lane_bawah
fun_bar 'inst_backup'

lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}          PROCCESS INSTALL OHP          ${NC}${BIBlue} │${NC}"
lane_bawah
fun_bar 'inst_ohp'

lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}      PROCCESS INSTALL EXTRA MENU       ${NC}${BIBlue} │${NC}"
lane_bawah
fun_bar 'inst_extramenu'
clear
lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}      PROCCESS INSTALL BACKUP MENU      ${NC}${BIBlue} │${NC}"
lane_bawah
fun_bar 'inst_backup'

lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}       PROCCESS INSTALL SLOW DNS        ${NC}${BIBlue} │${NC}"
lane_bawah
fun_bar 'inst_slowdns'

lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}      PROCCESS INSTALL UDP CUSTOM       ${NC}${BIBlue} │${NC}"
lane_bawah
fun_bar 'inst_udp'

lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}       PROCCESS INSTALL NOOBZVPNS       ${NC}${BIBlue} │${NC}"
lane_bawah
fun_bar 'inst_noobz'

lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}      PROCCESS INSTALL LIMIT XRAY       ${NC}${BIBlue} │${NC}"
lane_bawah
fun_bar 'inst_limitxray'

lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}       PROCCESS INSTALL TROJAN-GO       ${NC}${BIBlue} │${NC}"
lane_bawah
fun_bar 'inst_trojan'
}
instalasi
function iinfo(){
domain=$(cat /etc/xray/domain)
TIMES="10"
CHATID="6686272246"
KEY="8010185416:AAHQrlhGH1UmNKvQGFkOvhncHH3_FfwGnes"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TIME=$(date '+%d %b %Y')
RAMMS=$(free -m | awk 'NR==2 {print $2}')
MODEL2=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')
MYIP=$(curl -sS ipv4.icanhazip.com)
IZIN=$(curl -sS https://raw.githubusercontent.com/GeKaStore/permission/main/ip | grep $MYIP | awk '{print $3}' )
d1=$(date -d "$IZIN" +%s)
d2=$(date -d "$today" +%s)
USRSC=$(wget -qO- https://raw.githubusercontent.com/GeKaStore/permission/main/ip | grep $MYIP | awk '{print $2}')
EXPSC=$(wget -qO- https://raw.githubusercontent.com/GeKaStore/permission/main/ip | grep $MYIP | awk '{print $3}')
TEXT="
<code>🧿───────────────────🧿</code>
<b> INSTALL AUTOSCRIPT PREMIUM</b>
<code>🧿───────────────────🧿</code>
<code>ID   : </code><code>$USRSC</code>
<code>Date : </code><code>$TIME</code>
<code>Exp  : </code><code>$EXPSC</code>
<code>ISP  : </code><code>$ISP</code>
<code>🧿───────────────────🧿</code>
<i>Automatic Notification from Github</i>
"'&reply_markup={"inline_keyboard":[[{"text":"ᴏʀᴅᴇʀ","url":"https://t.me/WuzzSTORE"},{"text":"WA","url":"https://wa.me/6287760204418"}]]}'

curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
clear
}

cat> /root/.profile << END
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
if [ -f "/root/log-install.txt" ]; then
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-user.log" ]; then
echo "Log All Account " > /etc/log-create-user.log
fi
history -c
serverV=$( curl -sS https://raw.githubusercontent.com/GeKaStore/autoscript-vip/main/versi  )
echo $serverV > /opt/.ver
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi
cd
rm /root/setup.sh >/dev/null 2>&1
rm /root/slhost.sh >/dev/null 2>&1
rm /root/ssh-vpn.sh >/dev/null 2>&1
rm /root/ins-xray.sh >/dev/null 2>&1
rm /root/insshws.sh >/dev/null 2>&1
rm /root/set-br.sh >/dev/null 2>&1
rm /root/ohp.sh >/dev/null 2>&1
rm /root/update.sh >/dev/null 2>&1
rm /root/slowdns.sh >/dev/null 2>&1
rm -rf /etc/noobz
mkdir -p /etc/noobz
echo "" > /etc/xray/noob

cat <<EOF>> /etc/rmbl/theme/green
BG : \E[40;1;42m
TEXT : \033[0;32m
EOF
cat <<EOF>> /etc/rmbl/theme/yellow
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
cat <<EOF>> /etc/rmbl/theme/red
BG : \E[40;1;41m
TEXT : \033[0;31m
EOF
cat <<EOF>> /etc/rmbl/theme/blue
BG : \E[40;1;44m
TEXT : \033[0;34m
EOF
cat <<EOF>> /etc/rmbl/theme/magenta
BG : \E[40;1;45m
TEXT : \033[0;35m
EOF
cat <<EOF>> /etc/rmbl/theme/cyan
BG : \E[40;1;46m
TEXT : \033[0;36m
EOF
cat <<EOF>> /etc/rmbl/theme/lightgray
BG : \E[40;1;47m
TEXT : \033[0;37m
EOF
cat <<EOF>> /etc/rmbl/theme/darkgray
BG : \E[40;1;100m
TEXT : \033[0;90m
EOF
cat <<EOF>> /etc/rmbl/theme/lightred
BG : \E[40;1;101m
TEXT : \033[0;91m
EOF
cat <<EOF>> /etc/rmbl/theme/lightgreen
BG : \E[40;1;102m
TEXT : \033[0;92m
EOF
cat <<EOF>> /etc/rmbl/theme/lightyellow
BG : \E[40;1;103m
TEXT : \033[0;93m
EOF
cat <<EOF>> /etc/rmbl/theme/lightblue
BG : \E[40;1;104m
TEXT : \033[0;94m
EOF
cat <<EOF>> /etc/rmbl/theme/lightmagenta
BG : \E[40;1;105m
TEXT : \033[0;95m
EOF
cat <<EOF>> /etc/rmbl/theme/lightcyan
BG : \E[40;1;106m
TEXT : \033[0;96m
EOF
cat <<EOF>> /etc/rmbl/theme/color.conf
lightcyan
EOF

sleep 3
echo  ""
cd
iinfo
rm -rf *
lane_atas
echo -e "${BIBlue}│ ${BGCOLOR} INSTALL SCRIPT SELESAI..                 ${NC}${BIBlue} │${NC}"
lane_bawah
echo  ""
sleep 4
clear
reboot
