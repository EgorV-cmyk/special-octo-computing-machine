#!/bin/sh

PACKAGE=$1

ROOTFS="/mnt/external/0"
TRACK_FILE="/mnt/external/0/lavender.env/installed/${PACKAGE}.list"

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

log_info()    { printf "${YELLOW}[!]${RESET} %s\n" "$1"; }
log_success() { printf "${GREEN}[✓]${RESET} %s\n" "$1"; }
log_error()   { printf "${RED}[✗]${RESET} %s\n" "$1"; }

if [ ! -f "$TRACK_FILE" ]; then
  log_error "Tracking file not found: $TRACK_FILE"
  exit 1
fi

log_info "Removing files installed by package: $PACKAGE..."
while read -r FILE; do
  FULL_PATH="$ROOTFS$FILE"
  if [ -f "$FULL_PATH" ]; then
    rm -f "$FULL_PATH" && log_success "Removed: $FILE"
  fi
done < "$TRACK_FILE"

log_info "Cleaning up empty directories..."
while read -r FILE; do
  DIR=$(dirname "$ROOTFS$FILE")
  while [ "$DIR" != "$ROOTFS" ]; do
    rmdir --ignore-fail-on-non-empty "$DIR" 2>/dev/null
    DIR=$(dirname "$DIR")
  done
done < "$TRACK_FILE"

rm -f "$TRACK_FILE"
log_success "Package '$PACKAGE' successfully removed."
