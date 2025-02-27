#!/bin/bash

# Initializing variables
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip)
MYIP2="s/xxxxxxxxx/$MYIP/g"
NET=$(ip -o route show to default | awk '{print $5}')
source /etc/os-release
ver=$VERSION_ID

# Detail nama perusahaan
country=ID
state=INDONESIA
locality=JAWATENGAH
organization=Blogger
organizationalunit=Blogger
commonname=none
email=admin@sedang.my.id

# Link Hosting
GITHUB="https://raw.githubusercontent.com/Paper890/mysc/main/"

# Simple password minimal
curl -sS ${GITHUB}ssh/password | openssl aes-256-cbc -d -a -pass pass:scvps07gg -pbkdf2 > /etc/pam.d/common-password
chmod +x /etc/pam.d/common-password

# Go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<EOF
[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
EOF

echo '#!/bin/bash' > /etc/rc.local
echo 'exit 0' >> /etc/rc.local
chmod +x /etc/rc.local

# Update system
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt remove --purge ufw firewalld -y
apt remove --purge exim4 -y

# Install dependencies
apt install -y jq shc wget curl figlet ruby nginx certbot python3 python3-pip
gem install lolcat

# Set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# Install SSL
install_ssl() {
    if [ -f "/usr/bin/apt-get" ]; then
        apt install -y nginx certbot
        systemctl stop nginx.service
        certbot certonly --standalone --register-unsafely-without-email -d $domain
    else
        yum install -y nginx certbot
        systemctl stop nginx.service
        certbot certonly --standalone --register-unsafely-without-email -d $domain
    fi
}
install_ssl

# Configure Nginx
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "${GITHUB}ssh/nginx.conf"
wget -O /etc/nginx/sites-available/vps.conf "${GITHUB}ssh/vps.conf"
ln -s /etc/nginx/sites-available/vps.conf /etc/nginx/sites-enabled/
systemctl restart nginx

# Create directories for webserver
mkdir -p /home/vps/public_html
wget -O /home/vps/public_html/index.html "${GITHUB}ssh/multiport"
mkdir -p /home/vps/public_html/ss-ws
mkdir -p /home/vps/public_html/clash-ws

# Install BadVPN
wget -O /usr/bin/badvpn-udpgw "${GITHUB}ssh/newudpgw"
chmod +x /usr/bin/badvpn-udpgw
for port in 7100 7200 7300 7400 7500 7600 7700 7800 7900; do
    screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:$port --max-clients 500
done

# Configure SSH
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 500' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 40000' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 51443' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 58080' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 200' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
systemctl restart ssh

# Install Dropbear
apt install -y dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 50000 -p 109 -p 110 -p 69"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
systemctl restart dropbear

# Install Stunnel
apt install -y stunnel4
cat > /etc/stunnel/stunnel.conf <<EOF
pid = /var/run/stunnel4.pid
cert = /etc/stunnel/stunnel.pem
client = no
[ssh]
accept = 443
connect = 127.0.0.1:22
EOF
openssl req -new -x509 -days 365 -nodes -out /etc/stunnel/stunnel.pem -keyout /etc/stunnel/stunnel.pem \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
systemctl restart stunnel4

# Install Fail2Ban
apt install -y fail2ban

# Install DDOS Deflate
if [ ! -d '/usr/local/ddos' ]; then
    mkdir /usr/local/ddos
    wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
    wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
    wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
    wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
    chmod 0755 /usr/local/ddos/ddos.sh
    ln -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
    /usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
fi

# Configure Banner
wget -q -O /etc/issue.net "${GITHUB}issue.net"
chmod +x /etc/issue.net
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# Cleanup
apt autoclean -y
apt autoremove -y

# Restart services
systemctl restart nginx
systemctl restart ssh
systemctl restart dropbear
systemctl restart fail2ban
systemctl restart stunnel4

# Finish
clear
