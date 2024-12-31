#!/bin/bash

# Usage: ./script.sh -t <target> -m <mode>
# Modes: Anve (easy), Tapa (medium), Hidi (aggressive)

# Version
VERSION="v0.1"

# Default mode
MODE="Anve" # Default is easy mode
TARGET=""
FULL_URL=""

# Parse command-line arguments
while getopts "t:m:" opt; do
  case ${opt} in
    t) TARGET=$OPTARG ;;
    m) MODE=$OPTARG ;;
    *) echo "Usage: $0 -t <target> -m <mode>"; exit 1 ;;
  esac
done

# Validate target
if [ -z "$TARGET" ]; then
  echo "Error: Target (-t) is required."
  echo "Usage: $0 -t <target> -m <mode>"
  exit 1
fi

# Extract the hostname or IP if necessary and retain the full URL
if [[ $TARGET =~ ^http ]]; then
  FULL_URL=$TARGET
  TARGET=$(echo $TARGET | awk -F/ '{print $3}')
else
  FULL_URL="http://$TARGET" # Default to HTTP if not specified
fi

# Define the colors
INDIGO='\033[38;5;54m'  # Indigo color for ASCII art
AQUA='\033[38;5;51m'    # Aqua color for the rest of the output
RESET='\033[0m'         # Reset color

# Output newline before ASCII art for better readability
echo ""

# Output ASCII art in indigo
echo -e "${INDIGO}░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓███████▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░"
echo -e "${INDIGO}░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░"
echo -e "${INDIGO}░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░"
echo -e "${INDIGO}░▒▓███████▓▒░░▒▓████████▓▒░▒▓███████▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓████████▓▒░"
echo -e "${INDIGO}░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░"
echo -e "${INDIGO}░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░"
echo -e "${INDIGO}░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░"

# Display version in aqua
echo -e "							     ${AQUA}Version: $VERSION"

echo -e "${INDIGO}                                                                          "
echo -e "${INDIGO}                                                                          "

# Function for each mode
anve_mode() {
  echo -e "${AQUA}[+] Running in Anve (Easy) mode..."
  echo -e "${AQUA}Performing lightweight reconnaissance on $TARGET"
  nslookup $TARGET
}

tapa_mode() {
  echo -e "${AQUA}[+] Running in Tapa (Medium) mode..."
  echo -e "${AQUA}Performing moderate reconnaissance on $TARGET"
  dig $TARGET
  whois $TARGET
  echo -e "${AQUA}Scanning for directories with Dirsearch..."
  dirsearch -u $FULL_URL
}

hidi_mode() {
  echo -e "${AQUA}[+] Running in Hidi (Aggressive) mode..."
  echo -e "${AQUA}Performing extensive reconnaissance on $TARGET"
  nmap -A $TARGET
  echo -e "${AQUA}Scanning for directories with Dirsearch..."
  dirsearch -u $FULL_URL
  echo -e "${AQUA}Running Nikto for vulnerability analysis..."
  nikto -h $FULL_URL
}

# Execute based on mode
case $MODE in
  anve)
    anve_mode
    ;;
  tapa)
    tapa_mode
    ;;
  hidi)
    hidi_mode
    ;;
  *)
    echo -e "${AQUA}Error: Invalid mode. Choose from Anve (easy), Tapa (medium), or Hidi (aggressive)."
    exit 1
    ;;
esac

echo -e "${AQUA}[+] Script completed for $TARGET in $MODE mode.${RESET}"
