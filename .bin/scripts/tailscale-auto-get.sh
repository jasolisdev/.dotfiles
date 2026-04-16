#!/usr/bin/env bash

DOWNLOAD_DIR="$HOME/Downloads"

# Ensure Downloads exists
mkdir -p "$DOWNLOAD_DIR"

while true; do
  # Attempt to pull any pending files
  tailscale file get "$DOWNLOAD_DIR" >/dev/null 2>&1

  # Poll interval (seconds)
  sleep 5
done
