#!/usr/bin/env bash
set -euo pipefail

# --- Logging (captures errors if the menu "does nothing") ---
LOG="${LOG:-$HOME/.cache/hyprshot.log}"
mkdir -p "$(dirname "$LOG")"
exec 2>>"$LOG"

# --- Config you can tweak ---
THEME="${THEME:-$HOME/.config/wofi/themes/gruvbox-dark.css}"

# Screenshots
SAVE_DIR="${SAVE_DIR:-$HOME/Pictures/Screenshots}"
COPY_CLIPBOARD="${COPY_CLIPBOARD:-true}"
OPEN_AFTER="${OPEN_AFTER:-true}"
SOUND="${SOUND:-true}"

# Recordings
REC_DIR="${REC_DIR:-$HOME/Videos/Recordings}"
REC_FPS_DEFAULT="${REC_FPS_DEFAULT:-60}"
REC_CODEC="${REC_CODEC:-libx264}"
REC_CURSOR="${REC_CURSOR:-true}"

# Menu layout
WIDTH="${WIDTH:-90%}"
HEIGHT="${HEIGHT:-46%}"
CONFIRM_WIDTH="${CONFIRM_WIDTH:-420}"
CONFIRM_HEIGHT="${CONFIRM_HEIGHT:-140}"
DELAY_OPTS=("Now:1" "3s:3" "5s:5")

# State
STATE_DIR="$HOME/.cache/hyprshot"
PID_REC="$STATE_DIR/wf-recorder.pid"
FILE_REC="$STATE_DIR/wf-recorder.path"

# --- Utils & deps ---
die() {
  echo "ERR: $*" >&2
  exit 1
}
need() { command -v "$1" >/dev/null 2>&1 || die "Missing dep: $1"; }

path_abs() { # resolve ~ and relative paths for Wofi CSS
  python - "$1" <<'PY'
import os,sys
print(os.path.abspath(os.path.expanduser(sys.argv[1])))
PY
}
THEME_ABS="$(path_abs "$THEME")"

need wofi
need jq
need grim
need hyprctl
command -v slurp >/dev/null || true
command -v wl-copy >/dev/null || true
command -v swappy >/dev/null || true
command -v satty >/dev/null || true
command -v canberra-gtk-play >/dev/null || true
command -v wf-recorder >/dev/null || true # optional; menu hides record items if missing
command -v pactl >/dev/null || true       # for picking system/mic sources

mkdir -p "$SAVE_DIR" "$REC_DIR" "$STATE_DIR"

ts() { date +"%Y-%m-%d_%H-%M-%S"; }
shutter() { [[ "$SOUND" == "true" ]] && canberra-gtk-play -i camera-shutter -V 0 >/dev/null 2>&1 || true; }
notify_ok() { notify-send -i camera-photo "Screenshot" "$1" || true; }
notify_rec() { notify-send -i media-record "Recording" "$1" || true; }

editor_cmd() {
  if command -v swappy >/dev/null 2>&1; then
    echo "swappy -f"
    return
  fi
  if command -v satty >/dev/null 2>&1; then
    echo "satty -f"
    return
  fi
  echo ""
}

active_geom() {
  hyprctl activewindow -j | jq -r '
    .at as $a | .size as $s |
    "\($a[0]),\($a[1]) \($s[0])x\($s[1])"
  '
}

pick_monitor() {
  hyprctl monitors -j |
    jq -r '.[] | "\(.name)\t(\(.width)x\(.height) @ \(.x),\(.y))"' |
    wofi --show dmenu -i --prompt "Output" --style "$THEME_ABS" |
    awk -F'\t' '{print $1}'
}

pick_delay() {
  printf "%s\n" "${DELAY_OPTS[@]}" |
    awk -F: '{printf "%-6s %s sec\n",$1,$2}' |
    wofi --show dmenu -i --prompt "Delay" --style "$THEME_ABS" |
    awk '{print $2}'
}

pick_fps() {
  printf "%s\n" "60" "30" |
    wofi --show dmenu -i --prompt "FPS" --style "$THEME_ABS" |
    head -n1
}

# New: Audio mode picker (System vs Mic vs Off)
pick_audio_mode() {
  printf "%s\n" \
    "System audio (speakers)" \
    "Microphone" \
    "No audio" |
    wofi --show dmenu -i --prompt "Audio source" --style "$THEME_ABS" |
    sed 's/^ *//;s/ *$//'
}

# Prefer system monitor (speakers) or default mic
system_monitor_source() {
  command -v pactl >/dev/null 2>&1 || {
    echo ""
    return 0
  }
  local sink
  sink="$(pactl info 2>/dev/null | awk -F': ' '/Default Sink/{print $2}')"
  if [[ -n "$sink" ]]; then
    local mon
    mon="$(pactl list short sources 2>/dev/null | awk -v s="$sink.monitor" '$2==s{print $2; exit}')"
    [[ -n "$mon" ]] && {
      echo "$mon"
      return 0
    }
  fi
  pactl list short sources 2>/dev/null | awk '$2 ~ /\.monitor$/ {print $2; exit}'
}
default_mic_source() {
  command -v pactl >/dev/null 2>/dev/null || {
    echo ""
    return 0
  }
  # Try "Default Source" first
  local src
  src="$(pactl info 2>/dev/null | awk -F': ' '/Default Source/{print $2}')"
  [[ -n "$src" ]] && {
    echo "$src"
    return 0
  }
  # Fallback: first non-monitor source
  pactl list short sources 2>/dev/null | awk '$2 !~ /\.monitor$/ {print $2; exit}'
}

# --- Recording status helper (used by menu & stop flow)
is_recording() {
  [[ -f "$PID_REC" ]] || return 1
  local p
  p="$(cat "$PID_REC" 2>/dev/null || echo)"
  [[ -n "$p" ]] && kill -0 "$p" 2>/dev/null
}

# --- Menu builder: ONLY "Stop recording" when actively recording
pick_menu() {
  if is_recording; then
    printf "%s\n" "Stop recording" |
      wofi --show dmenu -i --prompt "Recording…" --style "$THEME_ABS" |
      sed 's/^ *//;s/ *$//'
    return
  fi

  if command -v wf-recorder >/dev/null 2>&1; then
    printf "%s\n" \
      "Area" \
      "Active window" \
      "Output / Monitor" \
      "All outputs" \
      "—" \
      "Record area" \
      "Record active window" \
      "Record output / monitor" \
      "Record all outputs"
  else
    printf "%s\n" \
      "Area" \
      "Active window" \
      "Output / Monitor" \
      "All outputs"
  fi |
    wofi --show dmenu -i --prompt "Screenshot / Record" --style "$THEME_ABS" |
    sed 's/^ *//;s/ *$//'
}

# --- Screenshots ---
shot_file() { echo "$SAVE_DIR/Screenshot_${1}_$(ts).png"; }

do_shot() {
  local mode="$1" arg="${2:-}" delay="${3:-0}"
  local file
  file="$(shot_file "$mode")"

  [[ "$delay" -gt 0 ]] && sleep "$delay"

  case "$mode" in
  area)
    if command -v slurp >/dev/null 2>&1; then
      grim -g "$(slurp -d)" "$file"
    else
      notify_ok "Install slurp for area capture"
      return 1
    fi
    ;;
  window)
    grim -g "$(active_geom)" "$file"
    ;;
  output)
    [[ -n "$arg" ]] || die "No output selected"
    grim -o "$arg" "$file"
    ;;
  all)
    grim "$file"
    ;;
  *)
    die "Unknown screenshot mode: $mode"
    ;;
  esac

  [[ -f "$file" ]] || die "Capture failed"

  if [[ "$COPY_CLIPBOARD" == "true" ]] && command -v wl-copy >/dev/null 2>&1; then
    wl-copy <"$file" || true
  fi

  shutter
  notify_ok "Saved: $(basename "$file")"

  if [[ "$OPEN_AFTER" == "true" ]]; then
    local ed
    ed="$(editor_cmd)"
    [[ -n "$ed" ]] && $ed "$file" >/dev/null 2>&1 &
  fi

  echo "$file"
}

# --- Recording ---
rec_file() { echo "$REC_DIR/Recording_${1}_$(ts).mkv"; }

start_record() {
  command -v wf-recorder >/dev/null 2>&1 || {
    notify_rec "wf-recorder not installed"
    return 1
  }

  # $1 mode, $2 arg (monitor), $3 delay, $4 fps, $5 audio_mode: system|mic|off
  local mode="$1" arg="${2:-}" delay="${3:-0}" fps="${4:-$REC_FPS_DEFAULT}" audio_mode="${5:-system}"
  local file
  file="$(rec_file "$mode")"

  if [[ "$delay" -gt 0 ]]; then
    notify_rec "Starts in ${delay}s…"
    sleep "$delay"
  fi

  local args=(-f "$file" -r "$fps" -c "$REC_CODEC")
  $REC_CURSOR || args+=(--no-cursor)

  case "$mode" in
  area)
    if command -v slurp >/dev/null 2>&1; then
      args+=(-g "$(slurp -d)")
    else
      notify_rec "Install slurp for area recording"
      return 1
    fi
    ;;
  window)
    args+=(-g "$(active_geom)")
    ;;
  output)
    [[ -n "$arg" ]] || die "No output selected"
    args+=(-o "$arg")
    ;;
  all)
    :
    ;;
  *)
    die "Unknown record mode: $mode"
    ;;
  esac

  # --- Audio selection
  case "$audio_mode" in
  system)
    if command -v pactl >/dev/null 2>&1; then
      src="$(system_monitor_source)"
      if [[ -n "${src:-}" ]]; then
        args+=(--audio -a "$src")
      else
        notify_rec "System monitor not found; recording without audio"
      fi
    else
      notify_rec "pactl not available; recording without audio"
    fi
    ;;
  mic)
    if command -v pactl >/dev/null 2>&1; then
      src="$(default_mic_source)"
      if [[ -n "${src:-}" ]]; then
        args+=(--audio -a "$src")
      else
        notify_rec "Mic source not found; recording without audio"
      fi
    else
      notify_rec "pactl not available; recording without audio"
    fi
    ;;
  off | none | "")
    : # no audio
    ;;
  *)
    notify_rec "Unknown audio mode '$audio_mode' → no audio"
    ;;
  esac

  wf-recorder "${args[@]}" &
  local pid=$!
  echo "$pid" >"$PID_REC"
  echo "$file" >"$FILE_REC"
  notify_rec "Recording…  (PID $pid)"
}

stop_record() {
  if is_recording; then
    local pid
    pid="$(cat "$PID_REC")"
    kill -INT "$pid" 2>/dev/null || true
    sleep 0.3
    if ! kill -0 "$pid" 2>/dev/null; then
      local out="Recording saved"
      [[ -f "$FILE_REC" ]] && out="$out: $(basename "$(cat "$FILE_REC")")"
      notify_rec "$out"
    else
      notify_rec "Stopped (finalizing…)"
    fi
    rm -f "$PID_REC"
  else
    notify_rec "No active recording"
  fi
}

# --- Entry points ---
case "${1:-menu}" in
menu)
  sel="$(pick_menu || true)"
  [[ -z "${sel:-}" ]] && exit 0
  case "$sel" in
  # Only shows when not recording
  "Area")
    d="$(pick_delay || echo 0)"
    do_shot "area" "" "$d"
    ;;
  "Active window")
    d="$(pick_delay || echo 0)"
    do_shot "window" "" "$d"
    ;;
  "Output / Monitor")
    mon="$(pick_monitor || true)"
    [[ -z "${mon:-}" ]] && exit 0
    d="$(pick_delay || echo 0)"
    do_shot "output" "$mon" "$d"
    ;;
  "All outputs")
    d="$(pick_delay || echo 0)"
    do_shot "all" "" "$d"
    ;;
  # Recording (ask for audio mode)
  "Record area")
    d="$(pick_delay || echo 0)"
    fps="$(pick_fps || echo $REC_FPS_DEFAULT)"
    am="$(pick_audio_mode || echo 'System audio (speakers)')"
    case "$am" in
    "System audio (speakers)") start_record "area" "" "$d" "$fps" "system" ;;
    "Microphone") start_record "area" "" "$d" "$fps" "mic" ;;
    *) start_record "area" "" "$d" "$fps" "off" ;;
    esac
    ;;
  "Record active window")
    d="$(pick_delay || echo 0)"
    fps="$(pick_fps || echo $REC_FPS_DEFAULT)"
    am="$(pick_audio_mode || echo 'System audio (speakers)')"
    case "$am" in
    "System audio (speakers)") start_record "window" "" "$d" "$fps" "system" ;;
    "Microphone") start_record "window" "" "$d" "$fps" "mic" ;;
    *) start_record "window" "" "$d" "$fps" "off" ;;
    esac
    ;;
  "Record output / monitor")
    mon="$(pick_monitor || true)"
    [[ -z "${mon:-}" ]] && exit 0
    d="$(pick_delay || echo 0)"
    fps="$(pick_fps || echo $REC_FPS_DEFAULT)"
    am="$(pick_audio_mode || echo 'System audio (speakers)')"
    case "$am" in
    "System audio (speakers)") start_record "output" "$mon" "$d" "$fps" "system" ;;
    "Microphone") start_record "output" "$mon" "$d" "$fps" "mic" ;;
    *) start_record "output" "$mon" "$d" "$fps" "off" ;;
    esac
    ;;
  "Record all outputs")
    d="$(pick_delay || echo 0)"
    fps="$(pick_fps || echo $REC_FPS_DEFAULT)"
    am="$(pick_audio_mode || echo 'System audio (speakers)')"
    case "$am" in
    "System audio (speakers)") start_record "all" "" "$d" "$fps" "system" ;;
    "Microphone") start_record "all" "" "$d" "$fps" "mic" ;;
    *) start_record "all" "" "$d" "$fps" "off" ;;
    esac
    ;;
  # The only item shown when recording is active
  "Stop recording") stop_record ;;
  "—" | *) exit 0 ;;
  esac
  ;;
area) do_shot "area" "" "${2:-0}" ;;
window) do_shot "window" "" "${2:-0}" ;;
output)
  mon="${2:-$(pick_monitor)}"
  do_shot "output" "$mon" "${3:-0}"
  ;;
all) do_shot "all" "" "${2:-0}" ;;
# direct recording entry points (with audio mode arg: system|mic|off)
record-area) start_record "area" "" "${2:-0}" "${3:-$REC_FPS_DEFAULT}" "${4:-system}" ;;
record-window) start_record "window" "" "${2:-0}" "${3:-$REC_FPS_DEFAULT}" "${4:-system}" ;;
record-output)
  mon="${2:-$(pick_monitor)}"
  start_record "output" "$mon" "${3:-0}" "${4:-$REC_FPS_DEFAULT}" "${5:-system}"
  ;;
record-all) start_record "all" "" "${2:-0}" "${3:-$REC_FPS_DEFAULT}" "${4:-system}" ;;
stop) stop_record ;;
*)
  echo "Usage: $0 menu | area [delay] | window [delay] | output [MON] [delay] | all [delay] | record-{area|window|output|all} [delay] [fps] [audio_mode(system|mic|off)] | stop"
  exit 1
  ;;
esac
