#!/bin/bash
cmd=(dialog --separate-output --checklist "Select options:" 22 76 16)
options=(1 "Ajouter un utilisateur sudo" off
         2 "Changer port SSH" off
         3 "Changer Hostname" off
         4 "Desactiver authentification root" off
	 5 "Activer un firewall" off
	 6 "Ouvrir un port dans le firewall" off
	 7 "Installer Fail2Ban" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
		source ./Files/Sudoer.sh
            ;;
        2)
		source ./Files/SSHPort.sh
            ;;
        3)
		source ./Files/Hostname.sh
            ;;
        4)
		source ./Files/RootLogin.sh
            ;;
        5)
                source ./Files/Firewall.sh
            ;;
	6)
                source ./Files/OpenPort.sh
            ;;
	7)
		source ./Files/Fail2Ban.sh
	    ;;
    esac
done
