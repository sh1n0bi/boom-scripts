#!/bin/bash

# Preliminary enumeration on a new box... by sh1n0bi. 25/7/20

# Requires:
# figlet
# rustscan
# nslookup
# enum4linux
# smbmap
# feroxbuster
# onesixtyone


# colours first
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

#####################

echo -e "${RED}"
echo -e "RustEnum !!!" |figlet;
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
echo -e "${BLUE}by sh1n0bi.${NC}"

####################


# wordlists for ferox-buster
wordlist1=/usr/share/seclists/Discovery/Web-Content/raft-small-words.txt

wordlist2=/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt



# get user input

read -p "Enter the Target's name: " box
read -p "Enter the Target's ip: " target
read -p "Which wordlist to use with FeroxBuster? (1or2): " num


if [ -z $num ]; then
        echo "Nope, pick a number..."
        exit
fi


case $num in

	1)
	wordlist=$wordlist1
	;;

	2)
	wordlist=$wordlist2
	;;

	*)
    	echo -n "unknown"
    	exit;;
esac

### make directory and report file
if [ ! -d "$boxname" ];then
    mkdir $box;
    cd $box;
fi


echo "# $box" |tee -a $box.md
figlet $box |tee -a $box.md
echo $target >> $box.md



#### rustscan

echo -e "${BLUE}[+] Starting a SuperFast RustScan !${NC}"

rustscan -a $target --ulimit 5000 -- -Pn -sVC -oN nmap$target.txt

echo "[toc]" >> $box.md
echo "# RustEnum" >> $box.md
echo "## nmap" >> $box.md
echo " " >> $box.md
echo "\`\`\`" >> $box.md
cat nmap$target.txt >> $box.md
echo " " >> $box.md
echo "\`\`\`" >> $box.md
echo " " >> $box.md

#### checking ftp for anonymous login
if nc -w1 -z $target 21; then
    echo -e "${BLUE}[+] Checking FTP !${NC}"
    nmap -A $target -p21
else
    echo -e "${RED}[+] No FTP detected!${NC}"
fi


#### checking DNS
if nc -w1 -z $target 53; then
    echo -e "${BLUE}[+] Checking DNS !${NC}"
    nslookup -type=any server $target |tee -a $box.md
else
    echo -e "${RED}[+] No DNS detected!${NC}"
fi


####  checking for smb

if nc -w1 -z $target 445; then
    echo -e "${BLUE}[+] Enumerating SMB !${NC}"
    smbmap -H $target -R |tee smbmap-out.txt
    enum4linux $target |tee -a enum4.txt
else
    echo -e "${RED}[+] No SMB here! ${NC}"
fi


#### ferox-buster to brute the http/s ports
echo -e "${BLUE}[+] Brute-forcing Web-directories with FeroxBuster ${NC}"
echo -e "${BLUE}[+] You will need to enter sudo password! ${NC}"

echo "---" >> $box.md
echo " " >> $box.md
echo "# Web" >> $box.md

if grep -q '443' nmap$target.txt;
	then sudo feroxbuster -u https://$target/ -w $wordlist \
	-x php txt html -t200 -r -k -W 0 |tee -a feroxbuster$target.txt;

fi


for x in $(grep 'http' nmap$target.txt |grep -v 'ssl'|grep '^[0-9]' |cut -d "/" -f1);
	do sudo feroxbuster -u http://$target:$x/ -w $wordlist \
	 -x php txt html -t200 -W 0 |tee -a feroxbuster$target.txt;
	done;


for y in $(grep 'ssl' nmap$target.txt |grep -v '443'|grep '^[0-9]' |cut -d "/" -f1);
        do sudo feroxbuster -u http://$target:$y/ -w $wordlist \
         -x php txt html -t200 -k -W 0 |tee -a feroxbuster$target.txt;
        done;

echo "\`\`\`" >> $box.md
cat feroxbuster$target.txt |grep 200 >> $box.md
echo "\`\`\`" >> $box.md
echo " " >> $box.md


### checking snmp 161  --comment out unwanted scans.

if nc -vzu $target 161; then
    echo -e "${BLUE}[+] OneSixtyOne is open people! Look Lively!!! ${NC}"
    snmp-check -c public $target |tee -a snmp$box.txt
#   snmpwalk -c public -v1 $target 1 >> snmpwalkout.txt
#   snmpwalk -c private -v1 $target 1 >> snmpwalk-private.txt
#   snmpwalk -c manager -v1 $target 1 >> snmpwalk-manager.txt
    onesixtyone -c /usr/share/doc/onesixtyone/dict.txt $target -o onesixtyone.txt
else
    echo -e "${RED}[+] Port 161 is not open!${NC}"
fi

####### now you can decide how to proceed from here...!

echo -e "${RED}[+] Im done! What you gonna do? ${NC}"

