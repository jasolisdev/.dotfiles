#!/usr/bin/env sh

NC='\033[0m'
RED='\033[31m'
BLUE='\033[34m'

launch_bar() {
  MONITOR=$1 IFACE_ETH=${eth} IFACE_WLAN=${wlan} polybar "$2" &
}

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u "$(id -u)" -x polybar >/dev/null; do
  sleep 1;
done

eth=$(ip link | grep -m 1 -E '\b(en)' | awk '{print substr($2, 1, length($2)-1)}')
wlan=$(ip link | grep -m 1 -E '\b(wl)' | awk '{print substr($2, 1, length($2)-1)}')
printf "Found network interfaces: ${BLUE}%s${NC} (eth), ${BLUE}%s${NC} (wlan)\\n" "${eth}" "${wlan}"

# Use newline as field separator for looping over lines
IFS=$'\n'

# Ensure that xrandr is available and abort the script otherwise. Discard
# command's output by redirecting stdout to /dev/null and stderr to stdout.
if ! command -v xrandr >/dev/null 2>&1; then
  printf "[ ${RED}Error${NC} ] Polybar launcher requires ${BLUE}xrandr${NC} for detecting monitors.\\n" >&2
  exit
fi

for screen in $(xrandr --query | grep -w connected); do
  # Substring removal, delete everything after first space
  output=${screen%% *}
  printf "Found output: ${BLUE}%s${NC}\\n" "${output}"

  case ${screen} in
    *primary*)
      printf "Launching primary bar(s) on ${BLUE}%s${NC}\\n" "${output}"
      launch_bar "${output}" top-primary
      launch_bar "${output}" top-transparent
      # launch_bar "${output}" top-right
      # launch_bar "${output}" top-spotify
      # launch_bar "${output}" bottom-primary
      # launch_bar "${output}" bottom-transparent
      ;;
    *)
      # printf "Launching secondary bar(s) on ${BLUE}%s${NC}\\n" "${output}"
      # launch_bar "${output}" top-secondary
      # launch_bar "${output}" bottom-secondary
      ;;
  esac
done
