#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: $(basename "$0") <command> [args...]" >&2
  exit 1
fi

if ! command -v hyprctl >/dev/null 2>&1; then
  exec "$@"
fi

instance=$(
  hyprctl instances -j 2>/dev/null | jq -r '.[0].instance' 2>/dev/null || true
)
if [[ -z "$instance" || "$instance" == "null" ]]; then
  exec "$@"
fi

active_json=$(hyprctl --instance "$instance" -j activeworkspace 2>/dev/null || true)
ws_id=$(printf '%s' "$active_json" | jq -r '.id // empty' 2>/dev/null || true)
ws_name=$(printf '%s' "$active_json" | jq -r '.name // empty' 2>/dev/null || true)

if [[ -z "$ws_id" || "$ws_name" == special:* ]]; then
  ws_id=$(
    hyprctl --instance "$instance" -j monitors 2>/dev/null |
      jq -r '.[] | select(.focused) | .activeWorkspace.id' 2>/dev/null || true
  )
fi

if [[ -z "$ws_id" || "$ws_id" == "null" ]]; then
  exec "$@"
fi

cmd=$(printf '%q ' "$@")
cmd=${cmd% }
hyprctl --instance "$instance" dispatch exec "[workspace $ws_id] $cmd"
