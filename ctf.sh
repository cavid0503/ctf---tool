#!/bin/bash

# Rənglər
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

clear

echo -e "${BOLD}${BLUE}"
echo "  ██████╗████████╗███████╗     █████╗ ███╗   ██╗██████╗ "
echo " ██╔════╝╚══██╔══╝██╔════╝    ██╔══██╗████╗  ██║██╔══██╗"
echo " ██║        ██║   █████╗      ███████║██╔██╗ ██║██║  ██║"
echo " ██║        ██║   ██╔══╝      ██╔══██║██║╚██╗██║██║  ██║"
echo " ╚██████╗   ██║   ██║         ██║  ██║██║ ╚████║██████╔╝"
echo "  ╚═════╝   ╚═╝   ╚═╝         ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ "
echo ""
echo " ██████╗ ██████╗ ██╗██╗   ██╗    ███████╗███████╗ ██████╗"
echo " ██╔══██╗██╔══██╗██║██║   ██║    ██╔════╝██╔════╝██╔════╝"
echo " ██████╔╝██████╔╝██║██║   ██║    █████╗  ███████╗██║     "
echo " ██╔═══╝ ██╔══██╗██║╚██╗ ██╔╝    ██╔══╝  ╚════██║██║     "
echo " ██║     ██║  ██║██║ ╚████╔╝     ███████╗███████║╚██████╗"
echo " ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝      ╚══════╝╚══════╝ ╚═════╝"
echo -e "${NC}"

echo -e "${CYAN}        ════════════════════════════════════════════${NC}"
echo -e "${YELLOW}                  TryHackMe CTF Helper v2.0${NC}"
echo -e "${CYAN}        ════════════════════════════════════════════${NC}"
echo ""

# Pilləkən çıxan Pinqvin
echo -e "                                            ${YELLOW}[ ROOT ELDE EDILDI ]${NC}"
echo -e "                                                       |"
echo -e "                                           .-----------'"
echo -e "                                           |"
echo -e "                               .-----------'"
echo -e "                               |"
echo -e "                   .-----------'        ${RED} .--. ${NC}"
echo -e "                   |                   ${RED}|o_o |${NC}"
echo -e "                   |                   ${RED}|:_/ |${NC}"
echo -e "         ${GREEN}[user]${NC}    |                  ${RED}//   \ \ ${NC}"
echo -e "           |       |                 ${RED}(|     | )${NC}"
echo -e "    -------'       '-------         ${RED}/'\\_   _/'\\ ${NC}"
echo -e "                                    ${RED}\\___)=(___/${NC}"
echo ""
echo -e "${BLUE}    ════════════════════════════════════════════════════${NC}"
echo -e "    ${YELLOW}1)${NC} SUDO & SUID Hunter          ${YELLOW}2)${NC} Global Flag Sniffer"
echo -e "    ${YELLOW}3)${NC} Cron Job & Writable Scripts ${YELLOW}4)${NC} Port Scanner"
echo -e "    ${YELLOW}5)${NC} Çıxış"
echo -e "${BLUE}    ════════════════════════════════════════════════════${NC}"
echo ""
read -p "    Seçim edin: " choice

# ──────────────────────────────────────────
sudo_hunter() {
    echo -e "\n${YELLOW}[*] Sudo və SUID yoxlanılır...${NC}"
    echo "────────────────────────────────────────"

    echo -e "${GREEN}[+] Sudo icazələri:${NC}"
    sudo -l -n 2>/dev/null || echo -e "${RED}[-] Sudo icazəsi yoxdur.${NC}"

    echo -e "\n${GREEN}[+] Kritik SUID faylları:${NC}"
    find / -perm -4000 -type f 2>/dev/null | grep -vE "^/usr/bin/|^/bin/|^/lib"

    echo -e "\n${GREEN}[+] Yazıla bilən PATH qovluqları:${NC}"
    echo "$PATH" | tr ':' '\n' | while read -r dir; do
        [ -w "$dir" ] && echo -e "  ${RED}[WRITABLE]${NC} $dir"
    done
}

# ──────────────────────────────────────────
flag_sniffer() {
    echo -e "\n${YELLOW}[*] Bütün sistemdə Flag-lər axtarılır...${NC}"
    echo "────────────────────────────────────────"

    find / -type f \( -name "*flag*" -o -name "user.txt" -o -name "root.txt" \) 2>/dev/null | while read -r line; do
        echo -e "${GREEN}[FOUND]:${NC} $line"
        head -c 60 "$line" 2>/dev/null && echo -e "\n..."
    done

    echo -e "\n${YELLOW}[*] Faylların daxilində flag formatları axtarılır...${NC}"
    grep -rE "(THM|HTB|CTF|FLAG)\{[^}]+\}" /home /var/www /opt /tmp 2>/dev/null
}

# ──────────────────────────────────────────
cron_watcher() {
    echo -e "\n${YELLOW}[*] Cron Job-lar və Yazıla bilən skriptlər...${NC}"
    echo "────────────────────────────────────────"

    echo -e "${GREEN}[+] /etc/crontab:${NC}"
    cat /etc/crontab 2>/dev/null

    echo -e "\n${GREEN}[+] /etc/cron.d/:${NC}"
    ls -la /etc/cron.d/ 2>/dev/null

    echo -e "\n${GREEN}[+] /etc/cron.hourly & daily:${NC}"
    ls -la /etc/cron.hourly/ /etc/cron.daily/ 2>/dev/null

    echo -e "\n${GREEN}[+] Redaktə edilə bilən .sh faylları:${NC}"
    find / -writable -name "*.sh" 2>/dev/null | grep -v "proc"
}

# ──────────────────────────────────────────
port_scanner() {
    echo -e "\n${YELLOW}[*] Lokal açıq portlar skan edilir...${NC}"
    echo "────────────────────────────────────────"

    echo -e "${GREEN}[+] Dinləyən TCP portları (ss):${NC}"
    ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null || \
        echo -e "${RED}[-] ss/netstat mövcud deyil.${NC}"

    echo -e "\n${GREEN}[+] Dinləyən UDP portları:${NC}"
    ss -ulnp 2>/dev/null

    echo -e "\n${GREEN}[+] Loopback-də açıq portlar (127.0.0.1):${NC}"
    for port in 21 22 23 25 80 443 3306 5432 6379 8080 8443 8888 9090 27017; do
        (echo >/dev/tcp/127.0.0.1/$port) 2>/dev/null && \
            echo -e "  ${RED}[OPEN]${NC} 127.0.0.1:$port"
    done

    echo -e "\n${GREEN}[+] Şəbəkə interfeyslərı:${NC}"
    ip a 2>/dev/null | grep -E "inet |inet6 "
}

# ──────────────────────────────────────────
case $choice in
    1) sudo_hunter  ;;
    2) flag_sniffer ;;
    3) cron_watcher ;;
    4) port_scanner ;;
    5) echo -e "\n${CYAN}Çıxılır...${NC}\n"; exit 0 ;;
    *) echo -e "\n${RED}[!] Yanlış seçim!${NC}" ;;
esac

echo -e "\n${BLUE}════════════════════════════════════════════════════${NC}\n"
