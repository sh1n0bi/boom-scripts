#!/bin/bash

# automates nmap preliminary scans.
# just those i use most frequently
# sneaky options too....
# by Shin0bi 3/9/2019


figlet "Nmap-Boom!"
date;
read -p "Enter target ip-address: " ipaddress
echo "Saving $ipaddress as target address";

read -p "Enter filename to save results: " filename
echo "All results will be appended to $filename.txt";

# case statement

read -p "Select scan-type: 1=quick; 2=aggressive; 3=full-port; 4=vuln; 5=UDP: " sel

if [ -z $sel ];then
	echo "Nope, just a number please..."
	exit
fi

case $sel in
	1)
	 echo "Quick-scan selected...buckle up buttercup!" |/usr/games/cowsay
	 nmap -sT -T5 $ipaddress |tee -a $filename.txt;;

	1a)
	 echo "Sneaky....sssshhh...just teh top ports!" |/usr/games/cowsay -f unipony-smaller
	 nmap -Pn -f -v $ipaddress |tee -a $filename.txt;;

	2)
	 echo "Why use a scalpel when some knuckledusters will do?" |/usr/games/cowsay -f ren
	 nmap -A $ipaddress |tee -a $filename.txt;;

	3)
	 echo "Go put the kettle on....this'll take a while!" |/usr/games/cowsay -f skeleton
	 nmap -p- -Pn -sV $ipaddress -sC |tee -a $filename.txt;;

	3a)
	 echo "Sneaky....ssshhhh!" |/usr/games/cowsay -f unipony-smaller
	 nmap -p- -Pn -sV -v $ipaddress |tee -a $filename.txt;;

	4)
	 echo "Long scan for vulns...maybe read a book, or do a jigsaw?" |/usr/games/cowsay -f gnu
	 nmap -sV $ipaddress --script=vuln |tee -a $filename.txt;;

	5)
	 echo "Scanning all UDP ports" |/usr/games/cowsay -f suse
	 nmap -sCVU $ipaddress |tee -a $filename.txt;;

	*) echo "Sorry, just 1,2,3,4, or 5 please!" |/usr/games/cowsay -f sheep;;
esac


echo Finished! |/usr/games/cowsay -f stimpy;

sleep 3;

read -p "Scan finished; do you want to scan any specific ports? " -n 1 -r

echo
 if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
		exit 1
fi

read -p "Enter the port number to scan: " port

echo "Performing a Vulnerability scan on port $port" |/usr/games/cowsay -f hellokitty
nmap -p $port -sV $ipaddress --script=vuln |tee -a $filename.txt;

echo "Finished...for now..." |/usr/games/cowsay -f daemon

## continue this script,
# ToDo:  looking for open ports, and targeting them....







