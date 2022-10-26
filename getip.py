#!/usr/bin/python3
# Getip
# by sh1n0bi, 26/10/22
# uses 'wget' to 'icanhazip.com'
# symlink it to '/usr/local/bin/getip'
from subprocess import run

# colours
RED ='\033[0;31m'
BLUE ='\033[0;34m'
NC ='\033[0m'

myip = run(['/usr/bin/wget', '-qO', '-', 'icanhazip.com', '-4'], capture_output=True)

if myip.returncode != 0:
  print(f"{RED}[!] There's a problem, are you connected?{NC}")

else:
  print(f"{BLUE}Your Public IP is:\n{RED}{myip.stdout.decode()}{NC}")
