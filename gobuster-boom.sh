#!/bin/bash

# automates initial,and most frequently used gobuster(2) scans.

figlet "Gobuster-Boom!"
date;

# declare wordlists
quick="/root/wordlists/SecLists/Discovery/Web-Content/common.txt"
medium="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"


read -p "Enter target directory to browse (eg. http://targetip.com/): " target
read -p "Enter filename to save results: " filename
echo "The results will be appended to $filename.txt";


# case statement

read -p "Select wordlist/mode: 1=quick; 2=quick+files; 3=medium; 4=medium+files: " sel

if [ -z $sel ]; then
	echo "Nope, pick a number..."
	exit
fi

case $sel in
	1)
	echo "Quick dirbust with Seclist common.txt" |/usr/games/cowsay
	gobuster -u $target -w $quick -t 50 |tee -a $filename.txt;;

	2)
	echo "Quick wordlist with common file-extensions" |/usr/games/cowsay
	gobuster -u $target -w $quick -x .php,.txt,.sh,.asp,.html -t 50 |tee -a $filename.txt;;

	3)
	echo "Medium wordlist from Dirbuster" |/usr/games/cowsay -f unipony-smaller
	gobuster -u $target -w $medium -t 50|tee -a $filename.txt;;

	4)
	echo "Medium wordlist from Dirbuster, with common file-extensions" |/usr/games/cowsay -f unipony-smaller
	gobuster -u $target -w $medium -x .php,.txt,.sh,.asp,.html -t 50 |tee -a $filename.txt;;

	*) echo "Sorry, just pick a bloody number!" |/usr/games/cowsay -f skeleton
	exit;;

esac
	
