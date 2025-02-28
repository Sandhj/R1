#!/bin/bash
NC="\e[0m"
RED="\033[0;31m" 
COLOR1="\033[1;36m"
COLBG1="\e[1;97;101m"                 
# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

clear
echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " ${COLBG1}            • MENU BACKUP •             ${NC} "
echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;93m〔 ⎆〕  ${GREEN}1.${NC} \033[0;36mInstall Auto Backup BOT${NC}"
echo -e "\033[1;93m〔 ⎆〕  ${GREEN}2.${NC} \033[0;36mRemove Auto Backup${NC}"
echo -e "\033[1;93m〔 ⎆〕  ${GREEN}0.${NC} \033[0;36mMenu${NC}"
echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Select menu :  "  opt
echo -e ""
case $opt in
  1) clear ; wget -q https://raw.githubusercontent.com/Paper890/mysc/main/backup/auto.sh && chmod +x auto.sh && ./auto.sh ;;
  2) clear ; rm /opt/autobackup/auto.py ; rm /etc/systemd/system/auto.service ;;
  0) clear ; menu ;;
  *) clear ; menu-backup ;;
esac
