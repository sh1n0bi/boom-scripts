
#/bin/bash
# a simple bug-bounty subdomain enum script. by sh1n0bi 18/04/20
# Amass,HTTProbe,Nmap,Eyewitness


# colours first
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

#############
echo -e "${RED}"
echo -e "Subdom-Boom!" |figlet;
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
echo -e "${BLUE}by sh1n0bi.${NC}"


# Make directories to organise results.
if [ ! -d "amass" ]; then
	mkdir -p amass/am-2/am-3
fi

if [ ! -d "scans" ]; then
	mkdir scans
fi

if [ ! -d "eyewitness" ];then
	mkdir eyewitness
fi

if [ ! -d "output" ];then
	mkdir output
fi


# use amass to find subdomains.
echo -e "${BLUE}Using Amass to find subdomains within subdomains${NS}" 
for I in $(cat scope.txt);do amass enum --passive -d $I -o amass/$I-am1.txt; done

for I in $(cat amass/*.txt);do amass enum --passive -d $I -o amass/am-2/$I-am2.txt; done


cat amass/am-2/*.txt |sort -u |tee -a fjinal.txt

# run the domains in fjinal.txt through httprobe, clean them for nmap.
echo -e "${BLUE}Running fjinal.txt through Httprobe, and cleaning the results for Nmap ${NS}"
cat fjinal.txt | httprobe | sed 's/https\?:\/\///' |tr -d ":443" |tee -a probed.txt;

# get rid of excluded scope items.
if [ -f "excluded.txt" ];then
	for nope in $(cat excluded.txt);do awk '!/$nope/' probed.txt > temp && mv temp probed.txt;done
fi

####################


# use nmap to scan the probed.txt file domains.
echo -e "${BLUE}Scanning the probed.txt targets with Nmap${NS}"
nmap -iL probed.txt -T5 -p- -oA scans/scanned


# use eyewitness to take screenshots of webpages.
echo -e "${BLUE}Using Eyewitness to get screenshots${NS}"
eyewitness -x scans/*.xml -d eyewitness


###########################

# brute-force the directories to find more targets/things to explore...maybe even stored creds.
# for I in $(cat probed.txt);do dirsearch -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u https://$I -e .txt,.php; done

####################

# Use tomnomnom's waybackurl go script to find more urls to target....
# make sure waybackurls is in the path...
# This will often create a huge file.
cat probed.txt |waybackurls |tee -a output/urls.txt

# also try gau to find more: gau can be installed with :
# go get -u github.com/lc/gau
for x in $(cat probed.txt);do
	gau $x |tee -a output/moreurls.txt
done

###################
# archivefuzz.py for finding more stuff...follow instructions from ... https://github.com/devanshbatham/ArchiveFuzz
for x in $(cat probed.txt);do
	python3 /opt/Archive-Fuzz/ArchiveFuzz/archivefuzz.py $x |tee -a archivefuzzed.txt
done

cp -rf /root/.archivefuzz/* output/
#################


