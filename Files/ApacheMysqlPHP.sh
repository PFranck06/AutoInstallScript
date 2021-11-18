#!/bin/bash
#Apache
echo -e "${GREEN}Voulez vous installer APACHE? ${RESTORE}"
read -e -i "oui" -r -p "(Oui: o /Non: n)" answer
answer="${answer,,}"
if [[ "$answer" = "o"* ]] ; then
	sudo apt install apache2 -y
else
        echo -e "${RED} Opération annulée ${RESTORE}"
fi

#MYSQL
echo -e "${GREEN}Voulez vous installer MYSQL? ${RESTORE}"
read -e -i "oui" -r -p "(Oui: o /Non: n)" answer
answer="${answer,,}"
if [[ "$answer" = "o"* ]] ; then
	sudo apt install mariadb-server -y
	sudo mysql_secure_installation

else
        echo -e "${RED} Opération annulée ${RESTORE}"
fi

#PHP
echo -e "${GREEN}Voulez vous installer PHP? ${RESTORE}"
read -e -i "oui" -r -p "(Oui: o /Non: n)" answer
answer="${answer,,}"
if [[ "$answer" = "o"* ]] ; then
	sudo apt install php libapache2-mod-php php-mysql -y
else
        echo -e "${RED} Opération annulée ${RESTORE}"
fi
