#!/usr/bin/env bash
set -euo pipefail

STYLE_MAIN="$HOME/.config/wofi/styles/powermenu.css"
STYLE_CONFIRM="$HOME/.config/wofi/styles/confirm.css"

# --- helpers ---------------------------------------------------------------
pause_media() {
  # Pause any MPRIS player (Spotify, mpv, VLC, browsers with MPRIS, etc.)
  if command -v playerctl >/dev/null 2>&1; then
    # Only pause players that are actually playing
    # shellcheck disable=SC2015
    playerctl --all-players status 2>/dev/null | grep -q 'Playing' &&
      playerctl --all-players pause >/dev/null 2>&1 || true
  fi

  # mpd (if running)
  if command -v mpc >/dev/null 2>&1; then
    mpc pause >/dev/null 2>&1 || true
  fi

  # cmus (if running)
  if command -v cmus-remote >/dev/null 2>&1; then
    cmus-remote -u >/dev/null 2>&1 || true
  fi
}

confirm() {
  printf "Yes\nNo\n" |
    wofi --dmenu \
      --normal-window \
      --prompt "Are you sure?" \
      --style "$STYLE_CONFIRM" \
      --width 220 --height 130 \
      --hide-scroll \
      --cache-file /dev/null
}

# Menu entries (icon + label)
entries=$'  Lock\n  Logout\n  Suspend\n  Reboot\n⏻  Shutdown'

# Uptime for prompt
uptime_str="$(uptime -p | sed 's/^up //')"

choose() {
  printf "%s\n" "$entries" |
    wofi --dmenu \
      --normal-window \
      --prompt "  Uptime: $uptime_str" \
      --style "$STYLE_MAIN" \
      --width 350 --height 260 \
      --hide-scroll \
      --cache-file /dev/null
}

selection="$(choose | sed -E 's/^[^ ]+[[:space:]]+//;s/[[:space:]]+$//' | tr '[:upper:]' '[:lower:]')"

case "$selection" in
lock)
  pause_media
  pkill -x wofi || true
  sleep 0.1
  exec hyprlock
  ;;
logout)
  [ "$(confirm)" = "Yes" ] && exec hyprctl dispatch exit NOW
  ;;
suspend)
  if [ "$(confirm)" = "Yes" ]; then
    pause_media
    exec systemctl suspend
  fi
  ;;
reboot)
  [ "$(confirm)" = "Yes" ] && exec systemctl reboot
  ;;
shutdown)
  [ "$(confirm)" = "Yes" ] && exec systemctl poweroff -i
  ;;
*)
  exit 0
  ;;
esac
