#!/bin/bash/
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo cp ./Downloads/jail.local /etc/fail2ban/jail.local

sudo sed -i "s/#ignoreip = 127.0.0.1\/8 ::1/ignoreip = 127.0.0.1\/8 ::1 $IPV4 $SSHIP/" /etc/fail2ban/jail.local
sudo sed -i "s/= ssh/= $SSHPort/" /etc/fail2ban/jail.local
if [ -d /etc/apache2 ] ; then
	sudo sed -i '/^\[apache-badbots\].*/a enabled = true' /etc/fail2ban/jail.local
	sudo sed -i '/^\[apache-auth\].*/a enabled = true' /etc/fail2ban/jail.local
fi

echo -e "${GREEN}Entrez votre adresse mail: ${RESTORE}"
read -r -p "mail:" MAIL
sudo sed -i "s/= root@localhost/= $MAIL/" /etc/fail2ban/jail.local
sudo sed -i "s/MAILHOSTNAME/$HOSTNAME/" /etc/fail2ban/jail.local

sudo systemctl restart fail2ban
