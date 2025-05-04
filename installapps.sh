#!/bin/sh
echo "test"
REPO=$1
PACKAGE=$2
APK_FILE="${PACKAGE}.apk"
APK_URL_MAIN_COMMUNITY="https://dl-cdn.alpinelinux.org/alpine/latest-stable/community/x86_64/$APK_FILE"
APK_URL_EDGE_COMMUNITY="https://dl-cdn.alpinelinux.org/alpine/edge/community/x86_64/$APK_FILE"
APK_URL_TESTING="https://dl-cdn.alpinelinux.org/alpine/edge/testing/x86_64/$APK_FILE"
APK_URL_MAIN="https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/x86_64/$APK_FILE"
TMP_DIR="/mnt/external/0/lavender.env/tmp"
ROOTFS="/mnt/external/0"
TRACK_DIR="/mnt/external/0/lavender.env/installed"
TRACK_FILE="$TRACK_DIR/${PACKAGE}.list"

RED="\033[38;5;196m"      # насыщенный красный
BLUE="\033[38;5;33m"      # синий
YELLOW="\033[38;5;214m"   # медовый
BOLD="\033[1m"
RESET="\033[0m"

log_info()   { printf "${BOLD}${YELLOW}[!]${RESET} %s\n" "$1"; }
log_success(){ printf "${BOLD}${BLUE}[✓]${RESET} %s\n" "$1"; }
log_error()  { printf "${BOLD}${RED}[✗]${RESET} %s\n" "$1"; }
mkdir -p "$TMP_DIR" "$TRACK_DIR"
cd "$TMP_DIR" || { log_error "Failed to go to $TMP_DIR"; exit 1; }

if [ "$REPO" = "main_community" ]; then
  log_info "Downloading: $APK_URL_MAIN_COMMUNITY"
  curl -s -O "$APK_URL_COMMUNITY" || { log_error "Error loading $PACKAGE"; exit 1; }
elif [ "$REPO" = "edge_community" ]; then
  log_info "Downloading: $APK_URL_EDGE_COMMUNITY"
  curl -s -O "$APK_URL_COMMUNITY" || { log_error "Error loading $PACKAGE"; exit 1; }
elif [ "$REPO" = "main" ]; then
  log_info "Downloading: $APK_URL_MAIN"
  curl -s -O "$APK_URL_MAIN" || { log_error "Error loading $PACKAGE"; exit 1; }
elif [ "$REPO" = "testing" ]; then
  log_info "Downloading: $APK_URL_TESTING"
  curl -s -O "$APK_URL_TESTING" || { log_error "Error loading $PACKAGE"; exit 1; }
else
  log_error "Unknown repository: $REPO"
  exit 1
fi

log_info "Checking archive contents..."
tar -tf "$APK_FILE" > /dev/null 2>&1 || {
  log_error "$APK_FILE is not a valid tar archive!"
  exit 1
}

log_info "Unpacking the package: $PACKAGE"
tar -xf "$APK_FILE" -C "$TMP_DIR"

log_info "Installing files and tracking..."

move_and_track() {
  SRC="$1"
  if [ -d "$TMP_DIR/$SRC" ]; then
    find "$TMP_DIR/$SRC" -type f | while read -r FILE; do
      REL_PATH="${FILE#$TMP_DIR/}"
      DEST_PATH="$ROOTFS/$REL_PATH"
      mkdir -p "$(dirname "$DEST_PATH")"
      mv "$FILE" "$DEST_PATH"
      echo "/$REL_PATH" >> "$TRACK_FILE"
    done
  fi
}

for DIR in etc bin sbin lib usr/bin usr/sbin usr/lib usr/share usr/libexec; do
  move_and_track "$DIR"
done

create_symlinks() {
  for dir in "$ROOTFS/lib" "$ROOTFS/usr/lib" "$ROOTFS/usr/libexec"; do
    [ -d "$dir" ] || continue
    for file in "$dir"/*.so.*; do
      [ -f "$file" ] || continue
      base="$(basename "$file")"
      name_without_version="$(echo "$base" | sed -E 's/\.so\..*/.so/')"
      major_version_link="$(echo "$base" | sed -E 's/(\.so\.[0-9]+)(\..*)*/\1/')"
      [ -e "$dir/$name_without_version" ] || ln -s "$base" "$dir/$name_without_version"
      [ -e "$dir/$major_version_link" ] || ln -s "$base" "$dir/$major_version_link"
    done
  done
}

create_symlinks

log_info "Cleaning temporary files..."
rm -rf "$TMP_DIR"/*

log_success "Installed: $PACKAGE"
log_info "Tracking file: $TRACK_FILE"
