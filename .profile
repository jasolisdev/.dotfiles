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

export BROWSER="brave"
export READER="zathura"

# aurutils
export AUR_REPO='aur'
export AUR_PAGER='ranger'

export GDK_SCALE=2
export GDK_DPI_SCALE=0.5

# man / less colors
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[30;48;5;208m'
export LESS_TERMCAP_se=$'\e[39;49m'
export LESS_TERMCAP_us=$'\e[4;96m'
export LESS_TERMCAP_ue=$'\e[0m'
export MANROFFOPT='-c'
export LESS='-iMRSj.3'
export SYSTEMD_LESS="$LESS"

xrandr --dpi 192

# Start graphical server if i3 not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx
