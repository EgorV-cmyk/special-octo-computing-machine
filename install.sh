#!/bin/sh

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
  /mnt/external/0/etc/home/.config/fish \
  /mnt/external/0/lavender.env \
  /mnt/external/0/lavender.env/tmp \
  /mnt/external/0/lavender.env/scripts \
  /mnt/external/0/lavender.env/installed
do
  mkdir -p "$DIR"
done
log_ok "All directories created."

# Download base scripts
log_info "Downloading base tools..."
curl -o /mnt/external/0/lavender.env/scripts/install https://raw.githubusercontent.com/EgorV-cmyk/special-octo-computing-machine/refs/heads/main/install
curl -o /mnt/external/0/lavender.env/scripts/remove https://raw.githubusercontent.com/EgorV-cmyk/special-octo-computing-machine/refs/heads/main/remove
curl -o /mnt/external/0/lavender.env/scripts/chk-libs https://raw.githubusercontent.com/EgorV-cmyk/special-octo-computing-machine/refs/heads/main/chk-libs
chmod +x /mnt/external/0/lavender.env/scripts/*
log_ok "Base scripts downloaded."

# Install core utilities
log_info "Installing core packages (musl, busybox, fish, nano, htop)..."
/mnt/external/0/lavender.env/scripts/install musl-1.2.5-r9 &&
/mnt/external/0/lavender.env/scripts/install busybox-1.37.0-r12 &&
/mnt/external/0/lavender.env/scripts/install ncurses-terminfo-6.5_p20241006-r3 &&
/mnt/external/0/lavender.env/scripts/install ncurses-terminfo-base-6.5_p20241006-r3 &&
/mnt/external/0/lavender.env/scripts/install libintl-0.22.5-r0 &&
/mnt/external/0/lavender.env/scripts/install libgcc-14.2.0-r4 &&
/mnt/external/0/lavender.env/scripts/install fish-3.7.1-r0 &&
/mnt/external/0/lavender.env/scripts/install libncursesw-6.5_p20241006-r3 &&
/mnt/external/0/lavender.env/scripts/install ncurses-6.5_p20241006-r3 &&
/mnt/external/0/lavender.env/scripts/install libpcre2-32-10.43-r0 &&
/mnt/external/0/lavender.env/scripts/install libstdc++-14.2.0-r4 && 
/mnt/external/0/lavender.env/scripts/install libncursesw-6.5_p20241006-r3 && 
/mnt/external/0/lavender.env/scripts/install libintl-0.22.5-r0 &&
/mnt/external/0/lavender.env/scripts/install nano-8.2-r0 &&
/mnt/external/0/lavender.env/scripts/install htop-3.3.0-r0

log_ok "Core utilities installed."

# Download fish config and startup script
log_info "Fetching config and startup files..."
curl -o /mnt/external/0/etc/home/.config/fish/config.fish https://raw.githubusercontent.com/EgorV-cmyk/special-octo-computing-machine/refs/heads/main/fish-conf
curl -o /mnt/external/0/start-fish https://raw.githubusercontent.com/EgorV-cmyk/special-octo-computing-machine/refs/heads/main/start-fish
chmod +x /mnt/external/0/start-fish
log_ok "Configuration files ready."

# Final notes

printf "${INFO} Inside fish session, install packages with: ${GREEN}install name-version${RESET}\n"
printf "${INFO} To remove packages: ${GREEN}remove name-version${RESET}\n"
printf "${INFO} Example: ${GREEN}nano-8.2-r0${RESET}\n"
printf "${INFO} Use: ${GREEN}run <program>${RESET} to start installed programs.\n"
printf "\n${INFO} To launch Lavender environment, run: ${GREEN}/mnt/external/0/start-fish${RESET}\n"
/mnt/external/0/start-fish
