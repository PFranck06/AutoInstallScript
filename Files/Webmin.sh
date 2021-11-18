#!/bin/bash
echo "deb http://download.webmin.com/download/repository sarge contrib" | sudo tee -a /etc/apt/sources.list
cd /tmp
wget http://www.webmin.com/jcameron-key.asc
sudo apt-key add jcameron-key.asc
sudo apt update
sudo apt install webmin -y

echo -e "${GREEN}Choisissez votre port pour Webmin${RESTORE}"
read -e -i "10000" -r -p "Port:" WEBMINPORT

sudo sed -i "s/port=10000/port=$WEBMINPORT/" /etc/webmin/miniserv.conf
sudo /etc/init.d/webmin restart

#Firewall
if [ -f /etc/init.d/firewall ] ; then
        sudo sed -i "/^echo - Initialisation des regles.*/i #Webmin" /etc/init.d/firewall
        sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A INPUT -p tcp --dport $WEBMINPORT -j ACCEPT" /etc/init.d/firewall
        sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A OUTPUT -p tcp --dport $WEBMINPORT -j ACCEPT" /etc/init.d/firewall

        sudo /etc/init.d/firewall stop
        sudo /etc/init.d/firewall start
fi

#Fail2Ban
if [ -f /etc/fail2ban/jail.local ] ; then
	sudo sed -i '/^\[webmin-auth\].*/a enabled = true' /etc/fail2ban/jail.local
	sudo sed -i "s/= 10000/= $WEBMINPORT/" /etc/fail2ban/jail.local
	sudo service fail2ban restart
fi
