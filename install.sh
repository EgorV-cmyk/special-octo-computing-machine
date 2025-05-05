#!/bin/sh
echo "1"
# Colors and symbols
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"
INFO="${YELLOW}[!]${RESET}"
OK="${GREEN}[✓]${RESET}"
ERR="${RED}[✗]${RESET}"

log_info() { printf "${INFO} %s\n" "$1"; }
log_ok()   { printf "${OK} %s\n" "$1"; }
log_err()  { printf "${ERR} %s\n" "$1"; }

# Creating directories
log_info "Creating directory structure..."
for DIR in \
  /mnt/external/0/bin \
  /mnt/external/0/lib \
  /mnt/external/0/usr \
  /mnt/external/0/usr/lib \
  /mnt/external/0/usr/libexec \
  /mnt/external/0/usr/bin \
  /mnt/external/0/usr/share \
  /mnt/external/0/etc \
  /mnt/external/0/etc/home \
  /mnt/external/0/lavender.env \
  /mnt/external/0/lavender.env/tmp \
  /mnt/external/0/lavender.env/scripts \
  /mnt/external/0/lavender.env/installed
do
  mkdir -p "$DIR"
done
log_ok "All directories created."

log_info "Downloading base tools..."
curl -o /mnt/external/0/lavender.env/scripts/install -s "https://raw.githubusercontent.com/EgorV-cmyk/special-octo-computing-machine/main/installapps.sh?$(date +%s)"
curl -o /mnt/external/0/lavender.env/scripts/remove -s "https://raw.githubusercontent.com/EgorV-cmyk/special-octo-computing-machine/main/remove.sh?$(date +%s)"
chmod +x /mnt/external/0/lavender.env/scripts/*
log_ok "Base scripts downloaded."

# Install core utilities
log_info "Installing core packages (musl, busybox, fastfetch, netcat, sox, nano, htop)..."
/mnt/external/0/lavender.env/scripts/install main musl-1.2.5-r9 &&
/mnt/external/0/lavender.env/scripts/install main busybox-1.37.0-r12 &&
/mnt/external/0/lavender.env/scripts/install main hwdata-pci-0.393-r0 && 
/mnt/external/0/lavender.env/scripts/install edge_community fastfetch-2.42.0-r0 && 
/mnt/external/0/lavender.env/scripts/install main libncursesw-6.5_p20241006-r3 &&
/mnt/external/0/lavender.env/scripts/install main nano-8.2-r0 &&
/mnt/external/0/lavender.env/scripts/install main libmd-1.1.0-r0 &&
/mnt/external/0/lavender.env/scripts/install main libbsd-0.12.2-r0 &&
/mnt/external/0/lavender.env/scripts/install main netcat-openbsd-1.226.1.1-r0 &&
/mnt/external/0/lavender.env/scripts/install main libvorbis-1.3.7-r2 &&
/mnt/external/0/lavender.env/scripts/install main libsndfile-1.2.2-r2 &&
/mnt/external/0/lavender.env/scripts/install main libpng-1.6.47-r0 &&
/mnt/external/0/lavender.env/scripts/install main libcrypto3-3.3.3-r0 &&
/mnt/external/0/lavender.env/scripts/install main libssl3-3.3.3-r0 &&
/mnt/external/0/lavender.env/scripts/install main opus-1.5.2-r1 &&
/mnt/external/0/lavender.env/scripts/install main opusfile-0.12-r6 &&
/mnt/external/0/lavender.env/scripts/install main libogg-1.3.5-r5 &&
/mnt/external/0/lavender.env/scripts/install main lame-libs-3.100-r5 &&
/mnt/external/0/lavender.env/scripts/install main libmagic-5.46-r2 &&
/mnt/external/0/lavender.env/scripts/install edge_community libmad-0.15.1b-r10 &&
/mnt/external/0/lavender.env/scripts/install main libltdl-2.4.7-r3 &&
/mnt/external/0/lavender.env/scripts/install main gsm-1.0.22-r3 &&
/mnt/external/0/lavender.env/scripts/install main libgomp-14.2.0-r4 &&
/mnt/external/0/lavender.env/scripts/install main alsa-lib-1.2.12-r0 &&
/mnt/external/0/lavender.env/scripts/install main_community libao-1.2.2-r3 &&
/mnt/external/0/lavender.env/scripts/install main libflac-1.4.3-r1 &&
/mnt/external/0/lavender.env/scripts/install main_community sox-14.4.2-r13 &&
/mnt/external/0/lavender.env/scripts/install main htop-3.3.0-r0

log_ok "Core utilities installed."

# Fetching bash config and startup script
log_info "Fetching config and startup files..."
curl -o /mnt/external/0/lavender.env/bashrc -s "https://raw.githubusercontent.com/EgorV-cmyk/special-octo-computing-machine/main/bash-config.sh?$(date +%s)"
curl -o /mnt/external/0/start-bash -s "https://raw.githubusercontent.com/EgorV-cmyk/special-octo-computing-machine/main/start-bash.sh?$(date +%s)"
chmod +x /mnt/external/0/start-bash
log_ok "Configuration files ready."

# Final notes

printf "${INFO} Inside fish session, install packages with: ${GREEN}install community_or_main_repos name-version${RESET}\n"
printf "${INFO} To remove packages: ${GREEN}remove name-version${RESET}\n"
printf "${INFO} Example: ${GREEN}nano-8.2-r0${RESET}\n"
printf "${INFO} Use: ${GREEN}run <program>${RESET} to start installed programs.\n"
printf "\n${INFO} To launch Lavender environment, run: ${GREEN}/mnt/external/0/start-bash${RESET}\n"
