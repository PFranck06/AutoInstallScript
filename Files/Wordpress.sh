#!/bin/bash
WORDPRESSPASSWORD=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
echo -e "${GREEN}wordpress database password: $WORDPRESSPASSWORD ${RESTORE}"
sudo mysql -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
sudo mysql -e "GRANT ALL ON wordpress.* TO 'wordpress_user'@'localhost' IDENTIFIED BY '$WORDPRESSPASSWORD';;"

sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip curl -y
sudo systemctl restart apache2

sudo mv /etc/apache2/sites-enabled/*.conf /etc/apache2/sites-available
sudo cp ./Downloads/wordpress.conf /etc/apache2/sites-available/

sudo a2enmod rewrite
sudo a2ensite wordpress.conf

cd /var/www/html/
sudo curl -O https://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz
sudo rm latest.tar.gz
cd wordpress
sudo touch .htaccess
sudo cp wp-config-sample.php wp-config.php
sudo mkdir ./wp-content/upgrade
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo find /var/www/html/wordpress/ -type d -exec chmod 775 {} \;
sudo find /var/www/html/wordpress/ -type f -exec chmod 640 {} \;

cd $CurrentFolder
sudo mv /var/www/html/wordpress/wp-config.php /var/www/html/wordpress/wp-config.old
curl -o ./Downloads/wordpress.key -s https://api.wordpress.org/secret-key/1.1/salt/
sudo cat ./Downloads/wordpress.key ./Downloads/wp-config.php  >./Downloads/wp-config.php2
sudo rm ./Downloads/wordpress.key
sudo sed -i "s/WORDPRESSPASSWORD/$WORDPRESSPASSWORD/" ./Downloads/wp-config.php2
sudo sed -i '1 i\<?php' ./Downloads/wp-config.php2
sudo mv ./Downloads/wp-config.php2 /var/www/html/wordpress/wp-config.php

sudo systemctl restart apache2

if [ -f /etc/fail2ban/jail.local ] ; then
        sudo sed -i '/^\[wordpress\].*/a enabled = true' /etc/fail2ban/jail.local
	sudo cp ./Downloads/wordpress.fail2ban.conf /etc/fail2ban/filter.d/wordpress.conf
	sudo service fail2ban restart
fi

echo -e "${GREEN}Rendez vous sur: ${RESTORE} http://$IPV4/wp-admin/install.php ${GREEN} ou ${RESTORE} http://$HOSTNAME/wp-admin/install.php"

