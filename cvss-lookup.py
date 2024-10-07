#!/usr/bin/python3
# sh1n0bi 04/08/2023
# scrapes nvd website for vuln definition
import requests
from bs4 import BeautifulSoup
import sys

# colours
RED='\033[1;31m'
BLUE='\033[1;34m'
YEL='\033[1;33m'
NC='\033[0m'

# check that the CVE number is given as a command argument
if len(sys.argv) !=2:
  print(f"{RED}[!] Error: Pass the CVE name as an argument")
  print(f"Eg: {sys.argv[0]} CVE-2018-13379 {NC}")
  exit(1)

cve = sys.argv[1]
url = "https://nvd.nist.gov/vuln/detail/"
r = requests.get(url+cve).text
soup = BeautifulSoup(r,'lxml')

# CVSSv4
# todo!

# CVSSv3
score = getattr(soup.find('a', {"id": "Cvss3NistCalculatorAnchor"}), "text", None)
rating = getattr(soup.find('span', {"class": "tooltipCvss3NistMetrics"}), "text", None)

# description of vulnerability
desc = getattr(soup.find('p', {"data-testid":"vuln-description"}), "text", None)

# CVSSv2
score2 = getattr(soup.find('a', {"id":"Cvss2CalculatorAnchor"}), "text", None)
rating2 = getattr(soup.find("span", {"class": "tooltipCvss2NistMetrics"}), "text", None)

#print(soup.prettify)

print(f"{RED}"+sys.argv[1])
print(f"{NC}")
print("CVSSv3 rating:")
print(score)
print(rating)
print("")

print(f"{YEL}"+desc)
print(f"{NC}")

print("CVSSv2 rating:")
print(score2)
print(rating2)

# print(f"{YEL}"+sys.argv[1]+"\n"+score+"\n"+rating+"\n"+desc+"{NC}")
