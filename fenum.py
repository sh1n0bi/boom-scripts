#!/usr/bin/python3

# requires feroxbuster,ffuf,rustscan,nmap
# smbmap, enum4linux, smbclient, smtp-user-enum
# nslookup, snmpcheck,onesixtyone

import pyfiglet
import requests, socket
import sys, os
from cmd import Cmd
from datetime import datetime


# make sure we got the correct command-line arguments.
if len(sys.argv) != 3:
    print ("\033[1;31mUSAGE: {} <name> <ip>\033[0;0m" .format(sys.argv[0]))
    sys.exit(-1)

tango = sys.argv[1]
ip = sys.argv[2]
dom = ""

ascii_banner = pyfiglet.figlet_format("F-Enum")
print("\033[1;31m"+ascii_banner+"\033[0;0m")
print("\033[1;34mby sh1n0bi\033[0;0m")

# Add Banner
print("-" * 50)
print("\033[1;34m[*] Enumerating: \033[0;0m" + tango)
print("Started at:" + str(datetime.now()))
print("\033[1;34m[*] Press '?' for list of commands.\033[0;0m")
print("-" * 50)


# Create target Directory if doesn't exist
if not os.path.exists(tango):
    os.mkdir(tango)
    print("\033[1;31m[*] Directory {} Created \033[0;0m".format(tango))
else:
    print("\033[1;31m[-] Directory {} already exists\033[0;0m".format(tango))


######## functions to call from command prompt

def my_rustscan():
  print("\033[1;34m[*]Starting a SuperFast RustScan now! \033[0;0m ")
  os.system("rustscan  -a {} --ulimit 5000 -- -Pn -sVC -oA {}/n{}".format(ip, tango, tango))
  print("\033[1;34m[*] Remember to add any found Domain Names to /etc/hosts file\033[0;0m")


def my_feroxbuster():
  wordlist1="/usr/share/seclists/Discovery/Web-Content/common.txt"
  wordlist2="/usr/share/seclists/Discovery/Web-Content/raft-small-words.txt"
  wordlist3="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"

  print("\033[1;33m 1 = {}\n 2 = {}\n 3 = {}\033[0;0m".format(wordlist1, wordlist2, wordlist3))
  choice=input("\033[1;31mChoose which wordlist to use with FeroxBuster? (1, 2 or 3): \033[0;0m")
  if choice == "1":
    wordl=wordlist1
  elif choice == "2":
    wordl=wordlist2
  elif choice == "3":
    wordl=wordlist3
  else:
    print("\033[1;31m[-] Don't be a dummy!\033[0;0m")
    exit()

  # replace ip in ferosbuster by domain name?
  d_choice =input("Do you know the target's domain name? y/n: ")

  if d_choice == "y":
    dom=input("Enter it here: ")
    ip = dom
  else:
    print("Just brute-forcing dirs using the IP address...")
    ip = sys.argv[2]

  # Running feroxbuster with chosen wordlist
  print("\033[1;34m[+] Brute-forcing Web directories with FeroxBuster\033[0;0m")
  # find http ports and scan them
  os.system(f"grep 'http' {tango}/n{tango}.nmap |grep '^[0-9]' |cut -d '/' -f1 |tee {tango}/http-ports.txt")

  file1 = open(f"{tango}/http-ports.txt", "r")
  for x in file1:
    os.system(f"feroxbuster --wordlist {wordl} --output {tango}/ferox-http.txt --url http://{ip}:{x}/ -x php txt html --threads 100")
  # find https ports and scan them
  os.system(f" grep 'ssl' {tango}/n{tango}.nmap |grep '^[0-9]'|cut -d '/' -f1 |tee {tango}/https-ports.txt")

  file2 = open(f"{tango}/https-ports.txt", "r")
  for x in file2:
    os.system(f"feroxbuster --wordlist {wordl} --output {tango}/ferox-https.txt --url https://{ip}:{x}/ -x php txt html --threads 100 -k -W 0")

  # fuzz for subdomains
  fuff_choice=input("\033[1;34m[?] Do you want to fuzz for subdomains? y/n: \033[0;0m")
  if fuff_choice == "y":
    os.system(f"ffuf -u 'http://FUZZ.{ip}/' -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt -c -fs 0")
  else:
    print("nope!")



def smtpEnum():
    print("\033[1;33m [*] Enumerating SMTP users \33[0;0m")
    os.system(f"smtp-user-enum -U /usr/share/seclists/Usernames/Names/names.txt -t {ip} -m 150")
    os.system(f"nmap -Pn --script smtp-enum-users {ip} -p25")


def smbEnum():
  target = ip
  port = 445
  s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  socket.setdefaulttimeout(1)
  result = s.connect_ex((target,port))
  if result ==0:
    print("\033[1;33m [*] Port {} is open \033[0;0m".format(port))
    s.close()
    print("\033[1;33m [*] Enumerating SMB service \033[0;0m")
    os.system(f"smbmap -H {ip} -R |tee {tango}/smbmap-out.txt")
    os.system(f"enum4linux {ip} |tee -a {tango}/enum4.txt")
    os.system(f"smbclient -L //{ip}")
  else:
    print("\033[1;31m[-] No SMB ports open \033[0;0m")
    s.close()


def krbEnum():
  os.system(f"nmap -p88 -Pn --script=krb5-enum-users --script-args krb5-enum-users.realm='{tango}' {ip}")
# Nmap -p 88 --script=krb5-enum-users --script-args krb5-enum-users.realm='<domain>',userdb=/root/Desktop/usernames.txt <IP>
# crackmapexec smb dominio.es  -u '' -p '' --users

#  sudo /opt/kerbrute userenum -d support.htb /usr/share/seclists/Usernames/Names/names.txt

def ldapEnum():
  dom1=input("Enter 1st part of domain name: ")
  dom2=input("Enter 2nd part (htb,thm,com etc...): ")

  os.system(f"nmap -Pn -sV --script 'ldap* and not brute' {ip} -p389")
  os.system(f"ldapsearch -LLL -x -H ldap://{dom1}.{dom2} -b '' -s base '(objectclass=*)'")
  os.system(f"ldapsearch -x -H ldap://{ip} -D '' -w '' -b 'DC={dom1},DC={dom2}'")


def dnsCheck():
  target = ip
  port = 53
  s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  socket.setdefaulttimeout(1)
  result = s.connect_ex((target,port))
  if result ==0:
    print("\033[1;33m [*] Port {} is open \033[0;0m".format(port))
    s.close()
    print("\033[1;33m [*] Enumerating DNS service \033[0;0m")
    os.system(f"nmap -T4 -Pn -p 53 -A {dom}")
    os.system(f"nslookup {ip} {dom}|tee -a {tango}/dns.txt")
   # os.system('''nslookup {} {}|awk '{print $NF}'|cut -d '.' -f2,3 |xargs dig AXFR @{} |tee -a {}/dns.txt'''.format(ip,ip,ip,tango))
   # os.system("nslookup {} {} |rev |awk -F. '{print $2'.'$3}' |rev |xargs dig AXFR {} @{} |tee -a {}/{}.md".format(ip,ip,ip,ip,tango,tango))

  else:
    print("\033[1;31m[-] No DNS Detected !  \033[0;0m")
    s.close()



def oneSixtyone():
  target = ip
  port = 161
  s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  socket.setdefaulttimeout(1)
  result = s.connect_ex((target,port))
  if result ==0:
    print("\033[1;33m [*] Port {} is open \033[0;0m".format(port))
    s.close()
    os.system(f"snmp-check -c public {ip} |tee -a {tango}/snmp{tango}.txt")
#   snmpwalk -c public -v1 $target 1 >> snmpwalkout.txt
#   snmpwalk -c private -v1 $target 1 >> snmpwalk-private.txt
#   snmpwalk -c manager -v1 $target 1 >> snmpwalk-manager.txt
    os.system(f"onesixtyone -c /usr/share/doc/onesixtyone/dict.txt {ip} -o {tango}/161.txt")
  else:
    print("\033[1;31m[-] Port 161 is not open!  \033[0;0m")
    s.close()



######## make a console where we can call these functions.
class Term(Cmd):

  prompt = "$> "

  def do_scan(self, line):
    """
    Rustscan and Nmap
    """
    my_rustscan()
  def do_dirs(self,line):
    """
    Feroxbuster brute-force
    """
    my_feroxbuster()
  def do_smb(self,line):
    """
    Enum4linux,smbmap,smbclient
    """
    smbEnum()
  def do_smtp(self,line):
    """
    SMTP-user-enum
    """
    smtpEnum()
  def do_dns(self,line):
    """
    NSlookup,dig
    """
    dnsCheck()
  def do_snmp(self,line):
    """
    SNMP-check,OneSixtyOne
    """
    oneSixtyone()
  def do_krb(self,line):
    """
    Nmap krb enum
    """
    krbEnum()
  def do_ldap(self,line):
    """
    Nmap ldap enum
    """
    ldapEnum()
  def do_all(self,line):
    """
    Performs All the functions...
    """
    my_rustscan()
    my_feroxbuster()
    dnsCheck()
    smbEnum()
    oneSixtyone()


  def do_quit(self, args):
    """Quits the program"""
    return 1

term = Term()
term.cmdloop()



