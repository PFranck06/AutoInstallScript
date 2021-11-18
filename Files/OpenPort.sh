#!/bin/bash
echo -e "${GREEN}Voulez vous ouvrir un port dans le firewall? ${RESTORE}"
read -e -i "oui" -r -p "(Oui: o /Non: n)" answer
answer="${answer,,}"
while [[ "$answer" = "o"* ]] ; do
	echo -e "${GREEN}Entrez le nom du service? ${RESTORE}"
	read -r -p "Service:" PortTitle
        echo -e "${GREEN}Entrez le numero du port? ${RESTORE}"
        read -r -p "Port:" NewPort

	sudo sed -i "/^echo - Initialisation des regles.*/i # Autoriser $PortTitle" /etc/init.d/firewall
	sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A INPUT -p tcp --dport $NewPort -j ACCEPT" /etc/init.d/firewall
	sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A OUTPUT -p tcp --dport $NewPort -j ACCEPT" /etc/init.d/firewall

	echo -e "${GREEN}Voulez vous ouvrir un port dans le firewall? ${RESTORE}"
	read -e -i "oui" -r -p "(Oui: o /Non: n)" answer
done

sudo /etc/init.d/firewall stop
sudo /etc/init.d/firewall start
