#!/bin/bash
echo -e "${GREEN}Voulez vous désactiver l'authentification root? ${RESTORE}"
read -e -i "oui" -r -p "(Oui: o /Non: n)" answer
answer="${answer,,}"
if [[ "$answer" = "o"* ]] ; then
	sudo sed -i '/#PermitRootLogin/c\PermitRootLogin no' /etc/ssh/sshd_config
	sudo service sshd restart
else
	echo -e "${RED} Opération annulée ${RESTORE}"
fi
