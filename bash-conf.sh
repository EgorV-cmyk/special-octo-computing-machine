export HOME=/mnt/external/0/etc/home
export LAVENDER=/mnt/external/0/

alias install="/mnt/external/0/lavender.env/scripts/install"
alias remove="/mnt/external/0/lavender.env/scripts/remove"
alias startsound="lxc exec sound sh daemon.sh &"

stopsound() {
    pkill -f -9 "sh daemon.sh"
    
    local status=$?

    if [ $status -eq 0 ]; then
        echo "One or more 'sh daemon.sh' processes terminated successfully."
    elif [ $status -eq 1 ]; then
        echo "No processes 'sh daemon.sh' found to terminate."
    else
        echo "An error occurred while attempting to terminate processes 'sh daemon.sh'. Exit code: $status" >&2
    fi
    return $status
}

start_lxc_if_needed() {
  local container_name="${1:-mycontainer}"

  if ! lxc-info -n "$container_name" >/dev/null 2>&1; then
    echo "Container '$container_name' not found."
    return 1
  fi

  local state
  state=$(lxc-info -n "$container_name" -s | awk '{print $2}')

  if [ "$state" = "RUNNING" ]; then
    echo "Container sound is running"
  else
    lxc-start -n "$container_name" -d
  fi
}

start_lxc_if_needed sound

lxc exec sound sh daemon.sh &

PS1='\033[38;5;250m[\u@\h \W]\033[0m \$ '

run() {
  local prog="$1"
  local path

  for dir in /mnt/external/0/bin /mnt/external/0/sbin /mnt/external/0/usr/sbin /mnt/external/0/usr/bin; do
    path="$dir/$prog"
    if [ -x "$path" ]; then
      /mnt/external/0/lib/ld-musl-x86_64.so.1 \
        --library-path /mnt/external/0/lib:/mnt/external/0/usr/lib:/mnt/external/0/usr/libexec \
        "$path" "${@:2}"
      return
    fi
  done

  echo -e "\033[1;31m[✗] Program '$prog' not found in /mnt/external/0/bin, /mnt/external/0/sbin, /mnt/external/0/usr/sbin or /mnt/external/0/usr/bin.\033[0m"
}
