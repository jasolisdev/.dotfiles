###################
#  ENV VARIABLES  #
###################

# Adds `~/.bin` and all subdirectories to $PATH
export PATH="$(du "$HOME/.bin/" | cut -f2 | tr '\n' ':')$PATH"

# terminal emulator
export TERMINAL='kitty'

# editor
export VISUAL='vim'
export EDITOR='vim'

export READER="zathura"

export BROWSER="chromium"

export GDK_SCALE=2
export GDK_DPI_SCALE=0.5

# Start graphical server if i3 not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx

xset r rate 190 35
