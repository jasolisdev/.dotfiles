#!/bin/bash
# Custom notify-send wrapper for nvim that replaces notifications instead of stacking

# Pass all arguments to notify-send but add the synchronous hint
notify-send -h string:x-canonical-private-synchronous:nvim "$@"
