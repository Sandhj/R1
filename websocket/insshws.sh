#!/bin/bash

#Link Hosting
REPO="https://raw.githubusercontent.com/Sandhj/R1/main/"


wget -O /usr/local/bin/ws-dropbear ${REPO}websocket/dropbear-ws.py
wget -O /usr/local/bin/ws-stunnel ${REPO}websocket/ws-stunnel

chmod +x /usr/local/bin/ws-dropbear
chmod +x /usr/local/bin/ws-stunnel

wget -O /etc/systemd/system/ws-dropbear.service ${REPO}websocket/service-wsdropbear && chmod +x /etc/systemd/system/ws-dropbear.service

wget -O /etc/systemd/system/ws-stunnel.service ${REPO}websocket/ws-stunnel.service && chmod +x /etc/systemd/system/ws-stunnel.service

systemctl daemon-reload
systemctl enable ws-dropbear.service
systemctl start ws-dropbear.service
systemctl restart ws-dropbear.service
systemctl enable ws-stunnel.service
systemctl start ws-stunnel.service
systemctl restart ws-stunnel.service

