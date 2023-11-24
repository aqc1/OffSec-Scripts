#!/usr/bin/env bash

# File to hold various information about the target: IP Address, Operating System, /etc/hosts entries, etc.
touch info.txt

# Directory to hold anything found and pulled from a target machine: files from FTP, downloaded zip archives, etc.
mkdir artifacts

# Directory to hold anything of value (usually credentials, secrets, etc.)
mkdir loot
touch loot/users.txt
touch loot/passwords.txt
touch loot/hashes.txt

# Directory to hold any downloaded exploits from GitHub, ExploitDB, etc.
mkdir exploits

# Directory to hold any code I had to personally write
mkdir code

# Directory to hold any form of scan output
mkdir scans
