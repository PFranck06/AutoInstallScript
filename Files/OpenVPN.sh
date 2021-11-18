#!/bin/bash/
cd $CurrentFolder/Downloads/
sudo wget https://raw.githubusercontent.com/Angristan/openvpn-install/master/openvpn-install.sh
sudo chmod +x openvpn-install.sh
sudo ./openvpn-install.sh

OpenVPNPort=$(grep "port" /etc/openvpn/server.conf | sed -e 's/.* //')
echo -e "${GREEN}Port OpenVPN: ${RESTORE} $OpenVPNPort"
if [ -f /etc/init.d/firewall ] ; then
	sudo sed -i "/^echo - Initialisation des regles.*/i # Autoriser OpenVPN " /etc/init.d/firewall
	sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A INPUT -p udp --dport $OpenVPNPort -j ACCEPT" /etc/init.d/firewall
	sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A OUTPUT -p udp --dport $OpenVPNPort -j ACCEPT" /etc/init.d/firewall
	sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A INPUT -p tcp --dport $OpenVPNPort -j ACCEPT" /etc/init.d/firewall
	sudo sed -i "/^echo - Initialisation des regles.*/i iptables -t filter -A OUTPUT -p tcp --dport $OpenVPNPort -j ACCEPT" /etc/init.d/firewall
	sudo sed -i "/^echo - Initialisation des regles.*/i iptables -I INPUT -p udp --dport $OpenVPNPort -j ACCEPT" /etc/init.d/firewall
	sudo sed -i "/^echo - Initialisation des regles.*/i iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT" /etc/init.d/firewall
	sudo sed -i "/^echo - Initialisation des regles.*/i iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT" /etc/init.d/firewall

        sudo /etc/init.d/firewall stop
        sudo /etc/init.d/firewall start
fi
