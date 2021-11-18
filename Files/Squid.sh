#!/bin/bash
sudo apt install squid -y

sudo cp /etc/squid/squid.conf sudo cp /etc/squid/squid.conf.old
sudo cp ./Downloads/squid.conf /etc/squid/squid.conf

echo -e "${GREEN}Choisissez votre port pour Squid${RESTORE}"
read -e -i "3128" -r -p "Port:" SQUIDPORT
sudo sed -i "s/http_port 3128/http_port $IPV4:$SQUIDPORT/g" /etc/squid/squid.conf

echo "$SSHIP" | sudo tee -a /etc/squid/allowed_ips.txt
echo -e "${GREEN}Voulez vous ajouter une adresse Ip autorisée a Squid?${RESTORE}"
echo -e "${GREEN}(en plus de $SSHIP) ${RESTORE}"
read -e -i "oui" -r -p "(Oui: o /Non: n)" answer
answer="${answer,,}"
while [[ "$answer" = "o"* ]] ; do
        read -r -p "Ip:" SquidIP
	echo "$SquidIP" | sudo tee -a /etc/squid/allowed_ips.txt

        echo -e "${GREEN}Voulez vous ouvrir un port dans le firewall? ${RESTORE}"
        read -e -i "oui" -r -p "(Oui: o /Non: n)" answer
done

echo -e "${GREEN}Choisissez votre mot de passe pour l'utilisateur $USERNAME ${RESTORE}"
read -e -i "Password:" PASSWORD
sudo printf "$USERNAME:$(openssl passwd -crypt "$PASSWORD")\n" | sudo tee -a /etc/squid/htpasswd

sudo systemctl restart squid

#Firewall
if [ -f /etc/init.d/firewall ] ; then
        sudo sed -i "/^echo - Initialisation des regles.*/i #Squid" /etc/init.d/firewall
        sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A INPUT -p tcp --dport $SQUIDPORT -j ACCEPT" /etc/init.d/firewall
        sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A OUTPUT -p tcp --dport $SQUIDPORT -j ACCEPT" /etc/init.d/firewall

        sudo /etc/init.d/firewall stop
        sudo /etc/init.d/firewall start
fi

#Fail2Ban
if [ -f /etc/fail2ban/jail.local ] ; then
	sudo sed -i '/^\[squid\].*/a enabled = true' /etc/fail2ban/jail.local
	sudo sed -i "s/80,443,3128,8080/80,443,$SQUIDPORT,8080" /etc/fail2ban/jail.local
	sudo service fail2ban restart
fi
