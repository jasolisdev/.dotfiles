#!/usr/bin/env bash
set -euo pipefail

STATUS_FILE="${XDG_RUNTIME_DIR:-/tmp}/touchpad.status"

# Read the device name straight from hyprland (keeps a single source of truth)
# Falls back to the same value you put in the config if the query fails.
DEV_FROM_CONF="${TOUCHPAD_DEV:-dll06e4:01-06cb:7a13-touchpad}"
DEV="$(hyprctl -j devices 2>/dev/null | jq -r '.devices[] | select(.type=="touchpad") | .name' | head -n1 || true)"
DEV="${DEV:-$DEV_FROM_CONF}"

notify() { command -v notify-send >/dev/null && notify-send -u low "$@"; }

# Helper to set the enabled flag via hyprctl (MUST quote the key because of colons)
set_enabled() {
  local v="$1" # true/false
  hyprctl keyword "device:${DEV}:enabled" "$v"
}

# If hyprctl -j or jq ever misbehaves on your system, you can skip detection
# and rely purely on STATUS_FILE by uncommenting the next line:
# DEV="$DEV_FROM_CONF"

# Initialize state if missing (assume "enabled" to start)
if [[ ! -f "$STATUS_FILE" ]]; then
  echo "enabled" >"$STATUS_FILE"
fi

state="$(cat "$STATUS_FILE" 2>/dev/null || echo enabled)"

if [[ "$state" == "enabled" ]]; then
  set_enabled false
  echo "disabled" >"$STATUS_FILE"
  notify "Touchpad disabled"
else
  set_enabled true
  echo "enabled" >"$STATUS_FILE"
  notify "Touchpad enabled"
fi
