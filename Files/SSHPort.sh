#!/bin/bash
echo -e "${GREEN}Voulez vous changer le port de connexion SSH? ${RESTORE}"
read -e -i "oui" -r -p "(Oui: o /Non: n)" answer
answer="${answer,,}"
if [[ "$answer" = "o"* ]] ; then
	echo -e "${GREEN}Entrez le nouveau port de connexion SSH? ${RESTORE}"
	read -r -p "Port numero:" SSHPort
	sudo sed -i "s/#Port 22/Port $SSHPort/" /etc/ssh/sshd_config
	sudo service ssh restart
else
	echo -e "${RED} Opération annulée ${RESTORE}"
fi
