#!/bin/bash/
sudo apt install task-lxde-desktop tightvncserver -y
echo -e "${GREEN}Choisissez votre port pour VNC${RESTORE}"
read -e -i "5900" -r -p "Port:" NewVNCPort
NewVNCPort1=$(($NewVNCPort+1))
sudo sed -i "s/5900/$NewVNCPort/g" /usr/bin/vncserver
sudo vncserver -kill :1

if [ -f /etc/init.d/firewall ] ; then
        sudo sed -i "/^echo - Initialisation des regles.*/i # Autoriser TightVNC" /etc/init.d/firewall
        sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A INPUT -p tcp --dport $NewVNCPort1 -j ACCEPT" /etc/init.d/firewall
        sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A OUTPUT -p tcp --dport $NewVNCPort1 -j ACCEPT" /etc/init.d/firewall

        sudo /etc/init.d/firewall stop
        sudo /etc/init.d/firewall start
fi

if [ -f /etc/fail2ban/jail.local ] ; then
	sudo sed -i '/^\[tightvnc-auth\].*/a enabled = true' /etc/fail2ban/jail.local
	sudo sed -i "s/NewVNCPort1/$NewVNCPort1/" /etc/fail2ban/jail.local
	sudo sed -i "s/USERNAME/$USERNAME/" /etc/fail2ban/jail.local
	sudo cp ./Downloads/tightvnc-auth.conf /etc/fail2ban/filter.d/tightvnc-auth.conf
	sudo service fail2ban restart
fi

sudo crontab -l > /tmp/mycron
echo "@reboot su $USERNAME -c "vncserver"" >> /tmp/mycron
sudo crontab /tmp/mycron
sudo rm /tmp/mycron

vncserver
