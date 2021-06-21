#!/bin/bash

# Enum All The Things!
#
# requires figlet + lolcat
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

# fatal --- print an error message and die:
fatal () {
    # Messages go to standard error.
    echo -e "${RED}$0: fatal error !!! ${NC}" >&2
    echo -e "${RED}Syntax:" "$0 <TargetName> <IP> \n ${NC}"
    exit 1
}

if [ $# != 2 ] # not enough arguments
then
    fatal not enough argurments
fi


##################### header

echo -e "${RED}"
echo -e "RustEnum !!!" |figlet;
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
echo -e "${BLUE}by sh1n0bi.${NC}"

####################




# Create directory for target if one doesn't exist.
if [ ! -d "$1" ];then
    mkdir $1;
    cd $1;
fi

# Start the log file...
figlet $1 |tee -a $1.md
echo $2 >> $1.md
echo ""


# wordlists for ferox-buster
wordlist1=/usr/share/seclists/Discovery/Web-Content/raft-small-words.txt
wordlist2=/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

# Get user's choice
echo -e "${YELLOW}1 = $wordlist1 "
echo -e "2 = $wordlist2 ${NC}"
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



#### rustscan
echo -e "${BLUE}[+] Starting a SuperFast RustScan !${NC}"
rustscan -a $2 --ulimit 5000 -- -Pn -sVC -oA n$1

# update the log file
echo "[toc]" >> $1.md
echo "# RustEnum" >> $1.md
echo "## nmap" >> $1.md
echo " " >> $1.md
echo "\`\`\`" >> $1.md
cat n$1.nmap >> $1.md
echo " " >> $1.md
echo "\`\`\`" >> $1.md
echo " " >> $1.md


#### checking ftp for anonymous login
if nc -w1 -z $2 21; then
    echo -e "${BLUE}[+] Checking FTP !${NC}"
    nmap -A $2 -p21
else
    echo -e "${RED}[+] No FTP detected!${NC}"
fi


#### checking DNS
if nc -w1 -z $2 53; then
    echo -e "${BLUE}[+] Checking DNS !${NC}"
    nslookup -type=any server $2 |tee -a $1.md
else
    echo -e "${RED}[+] No DNS detected!${NC}"
fi


####  checking for smb

if nc -w1 -z $2 445; then
    echo -e "${BLUE}[+] Enumerating SMB !${NC}"
    smbmap -H $2 -R |tee smbmap-out.txt
    enum4linux $2 |tee -a enum4.txt
else
    echo -e "${RED}[+] No SMB here! ${NC}"
fi



#### ferox-buster to brute the http/s ports
echo -e "${BLUE}[+] Brute-forcing Web-directories with FeroxBuster ${NC}"
echo -e "${BLUE}[+] You will need to enter sudo password! ${NC}"

echo "---" >> $1.md
echo " " >> $1.md
echo "# Web" >> $1.md


if grep -q '443' n$1.nmap;
    then sudo feroxbuster -u https://$2/ -w $wordlist \
    -x php txt html -t200 -r -k -W 0 |tee -a feroxbuster$2.txt;

fi


for x in $(grep 'http' n$1.nmap |grep -v 'ssl'|grep '^[0-9]' |cut -d "/" -f1);
    do sudo feroxbuster -u http://$2:$x/ -w $wordlist \
     -x php txt html -t200 -W 0 |tee -a feroxbuster$2.txt;
    done;


for y in $(grep 'ssl' n$1.nmap |grep -v '443'|grep '^[0-9]' |cut -d "/" -f1);
        do sudo feroxbuster -u http://$2:$y/ -w $wordlist \
         -x php txt html -t200 -k -W 0 |tee -a feroxbuster$2.txt;
        done;


# update log file
echo "\`\`\`" >> $1.md
cat feroxbuster$2.txt |grep 200 >> $1.md
echo "\`\`\`" >> $1.md
echo " " >> $1.md



### checking snmp 161  --comment out unwanted scans.

if nc -vzu $2 161; then
    echo -e "${BLUE}[+] OneSixtyOne is open people! Look Lively!!! ${NC}"
    snmp-check -c public $2 |tee -a snmp$1.txt
#   snmpwalk -c public -v1 $target 1 >> snmpwalkout.txt
#   snmpwalk -c private -v1 $target 1 >> snmpwalk-private.txt
#   snmpwalk -c manager -v1 $target 1 >> snmpwalk-manager.txt
    onesixtyone -c /usr/share/doc/onesixtyone/dict.txt $2 -o onesixtyone.txt
else
    echo -e "${RED}[+] Port 161 is not open!${NC}"
fi

foo=$(cat onesixtyone.txt |wc -l)
if [ boo -lt 10 ]; then rm -rf onesixtyone.txt;fi

bar=$(cat snmp$1.txt|wc -l)
if [ bar -lt 10 ]; then rm -rf snmp$1.txt;fi


####### now you can decide how to proceed from here...!
echo -e "${RED}[+] Im done! What you gonna do? ${NC}"
