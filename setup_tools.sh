#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
RESET='\033[0m'

echo -e "${CYAN}Starting the setup for required tools...${RESET}"

# Update system package manager
echo -e "${GREEN}[+] Updating package manager...${RESET}"
sudo apt update || { echo -e "${RED}Failed to update package manager. Check your internet connection.${RESET}"; exit 1; }

# Install Nmap
echo -e "${GREEN}[+] Installing Nmap...${RESET}"
sudo apt install -y nmap || { echo -e "${RED}Failed to install Nmap.${RESET}"; exit 1; }

# Install DNS utilities (nslookup and dig)
echo -e "${GREEN}[+] Installing DNS utilities (nslookup and dig)...${RESET}"
sudo apt install -y dnsutils || { echo -e "${RED}Failed to install DNS utilities.${RESET}"; exit 1; }

# Install Python and pip if not installed
echo -e "${GREEN}[+] Installing Python and pip...${RESET}"
sudo apt install -y python3 python3-pip || { echo -e "${RED}Failed to install Python and pip.${RESET}"; exit 1; }

# Install Dirsearch using pip
echo -e "${GREEN}[+] Installing Dirsearch...${RESET}"
sudo apt install dirsearch || { echo -e "${RED}Failed to install Dirsearch.${RESET}"; exit 1; }

# Install Nikto
echo -e "${GREEN}[+] Setting up Nikto...${RESET}"
git clone https://github.com/sullo/nikto.git || { echo -e "${RED}Failed to clone Nikto repository.${RESET}"; exit 1; }
cd nikto || { echo -e "${RED}Nikto directory not found after cloning.${RESET}"; exit 1; }

# Locate the nikto executable
if [ -f "program/nikto.pl" ]; then
    sudo chmod +x program/nikto.pl
    sudo ln -sf $(pwd)/program/nikto.pl /usr/local/bin/nikto
elif [ -f "nikto.pl" ]; then
    sudo chmod +x nikto.pl
    sudo ln -sf $(pwd)/nikto.pl /usr/local/bin/nikto
else
    echo -e "${RED}Error: Could not find the Nikto executable.${RESET}"
    exit 1
fi

cd ..


# Install Dirsearch from GitHub (optional, alternative to pip)
echo -e "${GREEN}[+] Setting up Dirsearch (from GitHub)...${RESET}"
git clone https://github.com/maurosoria/dirsearch.git || { echo -e "${RED}Failed to clone Dirsearch repository.${RESET}"; exit 1; }
cd dirsearch || { echo -e "${RED}Dirsearch directory not found after cloning.${RESET}"; exit 1; }
sudo chmod +x dirsearch.py
sudo ln -sf $(pwd)/dirsearch.py /usr/local/bin/dirsearch
cd ..

# Confirm installation
echo -e "${GREEN}[+] All tools have been installed successfully!${RESET}"
echo -e "${CYAN}Installed Tools:${RESET}"
echo -e "${CYAN}- Nmap${RESET}"
echo -e "${CYAN}- DNS Utilities (nslookup and dig)${RESET}"
echo -e "${CYAN}- Dirsearch${RESET}"
echo -e "${CYAN}- Nikto${RESET}"

# Instructions for testing
echo -e "${GREEN}You can now use the tools from the terminal. Examples:${RESET}"
echo -e "${CYAN}  nmap -A example.com${RESET}"
echo -e "${CYAN}  dig example.com${RESET}"
echo -e "${CYAN}  nslookup example.com${RESET}"
echo -e "${CYAN}  dirsearch -u https://example.com${RESET}"
echo -e "${CYAN}  nikto -h https://example.com${RESET}"
