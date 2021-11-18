#!/bin/bash
echo -e "${GREEN}Voulez vous ajouter un firewall? ${RESTORE}"
read -e -i "oui" -r -p "(Oui: o /Non: n)" answer
answer="${answer,,}"
if [[ "$answer" = "o"* ]] ; then
	sudo cp ./Downloads/firewall /etc/init.d
	sudo chmod +x /etc/init.d/firewall

	if [[ ! -z $SSHPort ]] ; then
		sudo sed -i "s/ 22 / $SSHPort /" /etc/init.d/firewall
	fi
	sudo /etc/init.d/firewall start
	sudo crontab -l > /tmp/mycron
	echo "@reboot sudo /etc/init.d/firewall start" >> /tmp/mycron
	sudo crontab /tmp/mycron
	sudo rm /tmp/mycron
else
	echo -e "${RED} Opération annulée ${RESTORE}"
fi
