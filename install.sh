#!/bin/bash
apt install sudo
sudo apt update && sudo apt upgrade -y
sudo apt install screen dialog -y
clear
source ./Files/Variables.sh

cmd=(dialog --separate-output --checklist "Select options:" 22 76 16)
options=(1 "Securité" off
         2 "Apache Mysql PHP" off
         3 "ProFTPD" off
         4 "Wordpress" off
	 5 "VPN" off
	 6 "LXDE VNC" off
	 7 "Squid Proxy" off
	 8 "Webmin" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
		source ./Files/Securite.sh
	;;
        2)
		cd "$CurrentFolder"
		source ./Files/ApacheMysqlPHP.sh
	;;
        3)
		cd "$CurrentFolder"
		source ./Files/ProFTPD.sh
	;;
        4)
		cd "$CurrentFolder"
		source ./Files/Wordpress.sh
	;;
        5)
                cd "$CurrentFolder"
                source ./Files/OpenVPN.sh
	;;
        6)
                cd "$CurrentFolder"
		source ./Files/LXDEVNC.sh
	;;
	7)
		cd "$CurrentFolder"
                source ./Files/Squid.sh
	;;
        8)
                cd "$CurrentFolder"
                source ./Files/Webmin.sh
        ;;
    esac
done
