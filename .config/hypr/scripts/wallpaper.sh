#!/usr/bin/env bash
set -euo pipefail

# ── Config (tweak as you like) ────────────────────────────────────────────────
WALLDIR="${WALLDIR:-$HOME/.wallpaper}"                       # your wallpapers
THEME="${THEME:-$HOME/.config/wofi/themes/gruvbox-dark.css}" # names-only CSS
WALCSS="${WALCSS:-$HOME/.config/wofi/colors/wal.css}"        # pywal → wofi colors

WIDTH="${WIDTH:-20%}" # wofi window
HEIGHT="${HEIGHT:-35%}"
COLUMNS="${COLUMNS:-1}" # list (1 column)

CONFIRM_WIDTH="${CONFIRM_WIDTH:-420}" # confirm dialog size
CONFIRM_HEIGHT="${CONFIRM_HEIGHT:-140}"

TRANSITION="${TRANSITION:-center}" # awww transition
FPS="${FPS:-60}"
DURATION_PREVIEW="${DURATION_PREVIEW:-0.35}" # quick preview
DURATION_APPLY="${DURATION_APPLY:-0.50}"     # final apply

# Cache (compatible with your old flow)
CACHE_FILE="$HOME/.cache/current_wallpaper"
RASI_FILE="$HOME/.cache/current_wallpaper.rasi" # left for compat

# ── Helpers ───────────────────────────────────────────────────────────────────
die() {
  echo "$*" >&2
  exit 1
}
need() { command -v "$1" >/dev/null 2>&1 || die "Missing dep: $1"; }

ensure_runtime() {
  mkdir -p "$HOME/.cache" "$(dirname "$WALCSS")"
  [[ -f "$CACHE_FILE" ]] || printf "%s\n" "$WALLDIR/default.jpg" >"$CACHE_FILE"
  [[ -f "$RASI_FILE" ]] || printf '* { current-image: url("%s", height); }' "$WALLDIR/default.jpg" >"$RASI_FILE"
}

export_wal_css() {
  # Generate ~/.config/wofi/colors/wal.css from pywal colors.json (if available)
  local json="$HOME/.cache/wal/colors.json"
  [[ -f "$json" ]] || return 0
  if command -v jq >/dev/null 2>&1; then
    jq -r '
      "@define-color bg0 " + .special.background + ";",
      "@define-color bg1 mix(" + .special.background + ", #ffffff, 6%);",
      "@define-color bg2 mix(" + .special.background + ", #ffffff, 10%);",
      "@define-color bg3 mix(" + .special.background + ", #ffffff, 14%);",
      "@define-color bg4 mix(" + .special.background + ", #000000, 8%);",
      "@define-color bg_visual mix(" + .special.background + ", " + .colors.color2 + ", 20%);",
      "@define-color fg " + .special.foreground + ";",
      "@define-color green " + .colors.color2 + ";",
      "@define-color aqua " + .colors.color6 + ";",
      "@define-color grey1 mix(" + .special.foreground + ", #808080, 40%);"
    ' "$json" >"$WALCSS"
  fi
}

swww_init() {
  need awww
  awww query >/dev/null 2>&1 || awww init
}

set_wallpaper() {
  # $1: image path, $2: duration
  local img="$1" dur="${2:-$DURATION_APPLY}"
  awww img "$img" \
    --transition-fps "$FPS" \
    --transition-type "$TRANSITION" \
    --transition-duration "$dur" \
    --transition-pos "$(hyprctl cursorpos)"
}

apply_and_theme() {
  # $1: image path (final apply: writes caches + pywal + wal.css)
  local img="$1"
  need wal
  wal -q -s -i "$img"
  export_wal_css
  printf "%s\n" "$img" >"$CACHE_FILE"
  printf '* { current-image: url("%s", height); }' "$img" >"$RASI_FILE"
}

list_rel() {
  (
    cd "$WALLDIR" 2>/dev/null || die "Missing dir: $WALLDIR"
    find . -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) |
      sed 's|^\./||' | sort -f
  )
}

pick_name() {
  need wofi
  list_rel | wofi --show dmenu -i \
    --normal-window \
    --columns "$COLUMNS" \
    --width "$WIDTH" --height "$HEIGHT" \
    --style "$THEME" \
    --prompt "Search"
}

confirm_keep() {
  # returns 0 to KEEP, 1 to REVERT
  printf "Yes\nNo\n" |
    wofi --show dmenu -i \
      --normal-window \
      --width "$CONFIRM_WIDTH" --height "$CONFIRM_HEIGHT" \
      --style "$THEME" \
      --prompt "Keep this wallpaper?" |
    grep -qi '^yes$'
}

# ── Commands ──────────────────────────────────────────────────────────────────
ensure_runtime
current="$(cat "$CACHE_FILE" 2>/dev/null || true)"

case "${1:-select}" in
init)
  swww_init
  if [[ -n "${current:-}" && -f "$current" ]]; then
    # theme from cached file, refresh caches, then apply with awww
    wal -q -s -i "$current" || true
    export_wal_css
    printf "%s\n" "$current" >"$CACHE_FILE"
    printf '* { current-image: url("%s", height); }' "$current" >"$RASI_FILE"
    set_wallpaper "$current" "$DURATION_APPLY"
    echo "Wallpaper: $current"
  else
    # first run fallback: theme from dir and set a random image
    wal -q -s -i "$WALLDIR" || true
    export_wal_css
    rel="$(list_rel | shuf -n 1 || true)"
    if [[ -n "${rel:-}" && -f "$WALLDIR/$rel" ]]; then
      sel="$WALLDIR/$rel"
      printf "%s\n" "$sel" >"$CACHE_FILE"
      printf '* { current-image: url("%s", height); }' "$sel" >"$RASI_FILE"
      set_wallpaper "$sel" "$DURATION_APPLY"
      echo "Wallpaper: $sel"
    fi
  fi
  ;;

select)
  swww_init
  choice="$(pick_name || true)"
  [[ -n "${choice:-}" ]] || exit 0
  sel="$WALLDIR/$choice"
  [[ -f "$sel" ]] || die "Not a file: $sel"

  # 1) PREVIEW (quick transition, do NOT write caches yet)
  set_wallpaper "$sel" "$DURATION_PREVIEW"

  # 2) Ask to keep or revert
  if confirm_keep; then
    # KEEP: theme + cache + final (slightly longer) transition
    apply_and_theme "$sel"
    set_wallpaper "$sel" "$DURATION_APPLY"
    echo "Wallpaper: $sel"
  else
    # REVERT: go back to previous
    if [[ -n "$current" && -f "$current" ]]; then
      set_wallpaper "$current" "$DURATION_PREVIEW"
    fi
    echo "Reverted."
  fi
  ;;

set)
  swww_init
  [[ -n "${2:-}" ]] || die "Usage: $0 set /path/to/image"
  sel="$2"
  [[ -f "$sel" ]] || die "Not a file: $sel"
  apply_and_theme "$sel"
  set_wallpaper "$sel" "$DURATION_APPLY"
  echo "Wallpaper: $sel"
  ;;

random)
  swww_init
  rel="$(list_rel | shuf -n 1)"
  [[ -n "$rel" ]] || die "No images in $WALLDIR"
  sel="$WALLDIR/$rel"
  apply_and_theme "$sel"
  set_wallpaper "$sel" "$DURATION_APPLY"
  echo "Wallpaper: $sel"
  ;;

*)
  echo "Usage: $0 {init|select|set <file>|random}"
  exit 1
  ;;
esac
