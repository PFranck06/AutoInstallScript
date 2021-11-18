#!/bin/bash
RESTORE='\033[0m'

RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'

LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'
#Debian Version
DebianVersion=$(cat /etc/debian_version)
echo -e "${GREEN}Version Debian: ${RESTORE} $DebianVersion"

#PHP Version
PHPVersion=$(php -v | sed -e 's/PHP //' | sed -e 's/ .*//' | head -n 1 | cut -c 1-3)
echo -e "${GREEN}Version PHP: ${RESTORE} $PHPVersion"

#Current Folder
CurrentFolder=$(echo $PWD)
echo -e "${GREEN}Dossier actuel: ${RESTORE} $CurrentFolder"

#Hostname
HOSTNAME=$(sed -n '1p' /etc/hostname)
echo -e "${GREEN}Votre HOSTNAME est: ${RESTORE} $HOSTNAME"

#SSH Port
SSHPort=$(grep "^Port*" /etc/ssh/sshd_config | sed -e 's/.* //')
if [[ -z "$SSHPort" ]] ; then
	SSHPort=22
fi
echo -e "${GREEN}Votre port SSH est: ${RESTORE} $SSHPort"

#IP V4
IPV4=$(sudo ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -n 1 )
echo -e "${GREEN}IP V4: ${RESTORE} $IPV4"

#IP SSH
SSHIP=$(netstat -tn 2>/dev/null | grep :$SSHPort | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr | head | sed -e 's/.* //')
echo -e "${GREEN}Votre Ip : ${RESTORE} $SSHIP"

#USERNAME
if [ -z $USERNAME ] ; then
        USERNAME=$(whoami)
	echo -e "${GREEN}Votre nom d'utilisateur (USERNAME) est: ${RESTORE} $USERNAME"
        read -e -i "oui" -r -p "Est-ce correct? (Oui: o /Non: n)" answer
	case "$answer" in
		[yY][eE][sS]|[yY]|[oO][uU][iI]|[oO])
			echo -e "${GREEN}Votre nom d'utilisateur (USERNAME) sera: ${RESTORE} $USERNAME"
		;;
		*)
			echo -e "${GREEN}Entrez votre nom d'utilisateur (USERNAME): ${RESTORE}"
			read -p "Nom d'utilisateur:" USERNAME
	                if [ ! -d /home/"$USERNAME" ] ; then
				echo -e "${GREEN}$USERNAME ne semble pas existé ${RESTORE}"
	                        read -p "Voulez vous le creer? (Oui: o /Non: n)" answer
				case "$answer" in
					[yY][eE][sS]|[yY]|[oO][uU][iI]|[oO])
						sudo adduser "$USERNAME"
						answer=o
					;;
					*)
						echo -e "${RED} Erreur nom d'utilisateur ${RESTORE}"
						exit
					;;
				esac
			else
				echo -e "${GREEN}Votre nom d'utilisateur (USERNAME) sera: ${RESTORE} $USERNAME"
				answer=o
			fi
	        ;;
	esac
fi

sudo chown -R $USERNAME:$USERNAME $CurrentFolder
