#!/bin/bash

# Preliminary enumeration on a new box... by sh1n0bi. 25/7/20
# nmap default scan
# enum4linux
# gobuster


# colours first
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'


#####################

echo -e "${RED}"
echo -e "BoxEnum !!!" |figlet;
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
echo -e "${BLUE}by sh1n0bi.${NC}"

####################


read -p "Enter the Target's name: " box
read -p "Enter the Target's ipaddress: " target

if [ ! -d "$boxname" ];then
	mkdir $box
	cd $box
fi

figlet $box |tee -a $box.md
echo $target >> $box.md
echo ""


echo -e "${BLUE}[+] Starting default Nmap Scan!${NC}"
nmap -sVC -Pn --min-rate 10000 -p- $target |tee -a $box.md


####  checking for smb

if nc -w1 -z $target 445; then
	echo -e "${BLUE}[+] Enumerating SMB !${NC}"
	smbmap -H $target -R
	enum4linux $target |tee -a enum4.txt
else
	echo -e "${RED}[+] No SMB here! ${NC}"
fi

#### checking port 80

if nc -w1 -z $target 80; then
	echo -e "${BLUE}[+] Brute-forcing directories with Gobuster ${NC}"
	gobuster dir -u http://$target/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 40 \
	-x .php,.txt,.html,.asp |tee -a gob$box.txt
else
	echo -e "${RED}[+] No Webserver on port 80!${NC}"
fi

### checking snmp 161  --comment out unwanted scans.

if nc -vzu $target 161; then
	echo -e "${BLUE}[+] OneSixtyOne is open people! Look Lively!!! ${NC}"
	snmp-check -c public $target |tee -a snmp$box.txt
#	snmpwalk -c public -v1 $target 1 >> snmpwalkout.txt
#	snmpwalk -c private -v1 $target 1 >> snmpwalk-private.txt
#	snmpwalk -c manager -v1 $target 1 >> snmpwalk-manager.txt
	onesixtyone -c /usr/share/doc/onesixtyone/dict.txt $target -o onesixtyone.txt
else
	echo -e "${RED}[+] Port 161 is not open!${NC}"
fi

####### now you can decide how to proceed from here...!

echo -e "${RED}[+] Im done! What you gonna do? ${NC}"

