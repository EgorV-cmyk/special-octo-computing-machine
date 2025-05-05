RKDIR="/root/lavtmp"
FIFO="$WORKDIR/lavfifo"
LOG="$WORKDIR/lavsoundd.log"
PORT="12345"

mkdir -p "$WORKDIR"

echo "[lavsoundd] Starting sound daemon..." | tee -a "$LOG"

cleanup() {
  echo "[lavsoundd] Cleaning up..." | tee -a "$LOG"
  [ -n "$FFPLAY_PID" ] && kill "$FFPLAY_PID" 2>/dev/null
  rm -f "$FIFO"
  exit 0
}

trap cleanup INT TERM

while true; do
  rm -f "$FIFO"
  mkfifo "$FIFO" || {
    echo "[lavsoundd] Failed to create FIFO." | tee -a "$LOG"
    exit 1
  }

  echo "[lavsoundd] Listening on port $PORT..." | tee -a "$LOG"

  ffplay -autoexit -nodisp "$FIFO" >>"$LOG" 2>&1 &
  FFPLAY_PID=$!

  echo "[lavsoundd] Waiting for audio stream..." | tee -a "$LOG"
  nc -l -p "$PORT" > "$FIFO"

  echo "[lavsoundd] Stream done. Restarting playback..." | tee -a "$LOG"
  kill "$FFPLAY_PID" 2>/dev/null
done
