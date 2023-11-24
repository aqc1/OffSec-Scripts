#!/usr/bin/env bash

# Pretty colors!
ERROR=$(tput setaf 1)
INFO=$(tput setaf 2)
RESET=$(tput sgr0)

# Check for IP address argument
# Hostname also works - Nmap supports it
if [ $# == 0 ]
then
    echo "${ERROR}[-]${RESET} Usage: ${0} [ IP Address | Hostname ]"
    exit 1
fi

# Grab host to scan
TARGET="${1}"

# Set directory for throwing scans into
# Multi-purpose - can be used for other scan types
SCANS="scans/nmap"

# Create directory for scans
mkdir -p "${SCANS}"
echo "${INFO}[+]${RESET} Created directory for Nmap scans: ${SCANS}"

# Quick scan to fetch all TCP ports
# -vv set for very verbose output
echo -e "\n${INFO}[+]${RESET} Beginning initial port scan on: ${TARGET}\n"
nmap -Pn -T5 -p- "${TARGET}" -vv -oN "${SCANS}/ports.nmap" -oG "${SCANS}/ports.gnmap"

# Carve out found TCP ports from .gnmap file
mapfile -t PORTS < <(grep -oE "[[:digit:]]+/open" "${SCANS}/ports.gnmap" | cut -d "/" -f 1 | tr -s "[:space:]*" ","  | sed "s/.$//")

# Remove unneeded .gnmap file
# Non-greppable copy still in the same folder for manual inspection
rm "${SCANS}/ports.gnmap"

# Aggressive scan on found ports
echo -e "\n${INFO}[+]${RESET} Beginning service scan on the following ports: ${PORTS[*]}\n"
nmap -Pn -sC -sV -T4 -p "${PORTS[*]}" "${TARGET}" -vv -oN "${SCANS}/service.nmap"

echo -e "\n${INFO}[+]${RESET} Done!"
