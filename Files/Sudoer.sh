#!/bin/bash
echo -e "${GREEN}Nom de l'utilisateur à ajouter aux sudoers; ${RESTORE}"
read -e -i "$USERNAME" -r -p "Nom" USERNAME
UserTest=$(grep $USERNAME /etc/passwd)
if [ -z $UserTest ] ; then
	sudo adduser "$USERNAME"
fi
UserTest=$(grep $USERNAME /etc/passwd)
if [ ! -z $UserTest ] ; then
	sudo usermod -a -G sudo "$USERNAME"
	sudo sed -i "/# User privilege specification/a $USERNAME	ALL=(ALL) NOPASSWD:ALL" /etc/sudoers
	sudo sed -i 's/ALL=(ALL:ALL) ALL/ALL=(ALL:ALL) NOPASSWD:ALL/g' /etc/sudoers
	sudo /etc/init.d/sudo restart
else
	echo -e "${RED} Opération annulée ${RESTORE}"
fi
unset UserTest

