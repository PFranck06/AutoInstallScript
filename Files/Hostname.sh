#!/bin/bash
echo -e "${GREEN}Voulez vous changer votre HOSTNAME? ${RESTORE}"
read -e -i "oui" -r -p "(Oui: o /Non: n)" answer
answer="${answer,,}"
if [[ "$answer" = "o"* ]] ; then
	echo -e "${GREEN}Entrez votre nom de domaine: ${RESTORE}"
	read -r -p "(ex: google.fr)" HOSTNAME
	NDD=$(echo "$HOSTNAME" | sed -e 's/\.[^.]*$//')
	sudo sed -i "/127.0.1.1/c\127.0.1.1	$HOSTNAME	$NDD" /etc/hosts
	sudo sed -i "1 s/.*/$HOSTNAME/" /etc/hostname
	sudo hostnamectl
else
	echo -e "${RED} Opération annulée ${RESTORE}"
fi
