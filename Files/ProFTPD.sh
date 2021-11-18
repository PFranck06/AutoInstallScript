#!/bin/bash
sudo apt-get install proftpd openssl -y
sudo addgroup ftpgroup
sudo adduser $USERNAME ftpgroup
sudo rm /etc/proftpd/proftpd.conf
sudo cp ./Downloads/proftpd.conf /etc/proftpd/

if [ -f /etc/init.d/firewall ] ; then
        sudo sed -i "/^echo - Initialisation des regles.*/i # Autoriser PassivePorts" /etc/init.d/firewall
        sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A INPUT -p tcp --dport 49152:65535 -j ACCEPT" /etc/init.d/firewall
        sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A OUTPUT -p tcp --dport 49152:65535 -j ACCEPT" /etc/init.d/firewall
        sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A INPUT -p udp --dport 49152:65535 -j ACCEPT" /etc/init.d/firewall
        sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A OUTPUT -p udp --dport 49152:65535 -j ACCEPT" /etc/init.d/firewall

	sudo /etc/init.d/firewall stop
	sudo /etc/init.d/firewall start
fi

if [ -f /etc/fail2ban/jail.local ] ; then
	sudo sed -i '/^\[proftpd\].*/a enabled = true' /etc/fail2ban/jail.local
	sudo service fail2ban restart
fi

sudo service proftpd restart
