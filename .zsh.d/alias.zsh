#############
#  ALIASES  #
#############

 alias ..='cd ..'

 # show type,show almost all
 alias l='ls -FA'
 # long list,size,show type,human readable
 alias ll='ls -lFh'
 # long list,show almost all,show type,human readable
 alias la='ls -a'
 # sorted by date,recursive,show type,human readable
 alias lr='ls -tRFh'
 # long list,sorted by date,show type,human readable
 alias lt='ls -ltFh'

 alias ldot='ls -ld .*'
 alias lS='ls -1FSsh'
 alias lart='ls -1Fcart'
 alias lrt='ls -1Fcrt'
 alias t='tail -f'
 alias wa='watch -ctn 2'

 alias df="df -h"

 alias rm='rm -i'
 alias rmrf='rm -rf'
 alias cp='cp -r -i --reflink=auto'
 alias mv='mv -i'

 alias :q='exit'

 alias reflectug='sudo reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist'

 alias pg='ping -c 1 www.google.com'

 alias vpn='sudo cyberghostvpn --traffic --country-code US --city "San Francisco" --connect'
 alias svpn='sudo cyberghostvpn --stop'
 alias netui=nmtui

 alias neofetch='echo "\\n\\n" && neofetch'
 alias hardwareinfo="inxi -F"

 alias journalctl='journalctl -r'

 alias dgit='git --git-dir ~/.dotfiles/.git --work-tree=$HOME'

 alias grep='grep --color=auto --exclude-dir={.git,.svn}'

 alias kal='khal interactive'                            # show calendar

 alias testpowerline='echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"'

 alias ta='tmux attach-session -t0'

 alias todo='calcurse'

 alias Xrdb='xrdb ~/.Xresources'

 alias cls='clear'

 alias ec='emacsclient'
 alias ect='emacsclient -t'
 alias e='emacs -nw'

 alias v='vim'

 alias py='python3'

 alias dev='cd ~/Dev/'
 alias home='cd ~/'


 alias rsx='redshift -x'
 alias rs53='redshift -O 5300'
 alias rs52='redshift -O 5200'
 alias rs51='redshift -O 5100'
 alias rs50='redshift -O 5000'
 alias rs49='redshift -O 4900'
 alias rs48='redshift -O 4800'
 
 alias rslocal='redshift -l 33.659484:-117.998803'

 # Spelling corrections because Im dumb sometimes.
 alias vmi="vim"
 alias exi="exit"
 alias exti="exit"
 alias eitx="exit"
 alias eixt="exit"
 alias exiyt="exit"
 alias exity="exit"
 alias cd..="cd .."

alias yt="youtube-viewer"

foreground-job() {
    fg
}
zle     -N   foreground-job
bindkey '^Z' foreground-job

mkcd() {
    [[ $# -gt 1 ]] && return 1
    mkdir -p "$1" && cd "$1" || return 1
}

# archive compress
compress() {
    if [[ -n "$1" ]]; then
        local file=$1
        shift
        case "$file" in
            *.tar ) tar cf "$file" "$*" ;;
            *.tar.bz2 ) tar cjf "$file" "$*" ;;
            *.tar.gz ) tar czf "$file" "$*" ;;
            *.tgz ) tar czf "$file" "$*" ;;
            *.zip ) zip "$file" "$*" ;;
            *.rar ) rar "$file" "$*" ;;
            * ) tar zcvf "$file.tar.gz" "$*" ;;
        esac
    else
        echo 'usage: compress <foo.tar.gz> ./foo ./bar'
    fi
}

# archive extract
extract() {
    if [[ -f "$1" ]] ; then
        local filename=$(basename "$1")
        local foldername=${filename%%.*}
        local fullpath=$(perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1")
        local didfolderexist=false
        if [[ -d "$foldername" ]]; then
            didfolderexist=true
            read -p "$foldername already exists, do you want to overwrite it? (y/n) " -n 1
            echo
            if [[ "$REPLY" =~ ^[Nn]$ ]]; then
                return
            fi
        fi
        mkdir -p "$foldername" && cd "$foldername"
        case "$1" in
            *.tar.bz2) tar xjf "$fullpath" ;;
            *.tar.gz) tar xzf "$fullpath" ;;
            *.tar.xz) tar Jxvf "$fullpath" ;;
            *.tar.Z) tar xzf "$fullpath" ;;
            *.tar) tar xf "$fullpath" ;;
            *.taz) tar xzf "$fullpath" ;;
            *.tb2) tar xjf "$fullpath" ;;
            *.tbz) tar xjf "$fullpath" ;;
            *.tbz2) tar xjf "$fullpath" ;;
            *.tgz) tar xzf "$fullpath" ;;
            *.txz) tar Jxvf "$fullpath" ;;
            *.zip) unzip "$fullpath" ;;
            *) echo "'$1' cannot be extracted via extract()" \
                && cd .. \
                && ! "$didfolderexist" \
                && rm -r "$foldername" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# tre is a shorthand for tree
tre() {
    tree -aC -I \
        '.git|.hg|.svn|.tmux|.backup|.vim-backup|.swap|.vim-swap|.undo|.vim-undo|*.bak|tags' \
        --dirsfirst "$@" \
        | less
}

# switch from/to project/package dir
pkg() {
    current=$(pwd | sed "s@$HOME/@@" | sed 's@/.*@@')
    if [[ "$current" == 'projects' ]]; then
        cd "$(pwd | sed 's/projects/packages/')"
    else
        cd "$(pwd | sed 's/packages/projects/')"
    fi
}

bak() {
    if [[ -e "$1" ]]; then
        echo "Found: $1"
        mv "${1%.*}"{,.bak}
    elif [[ -e "$1.bak" ]]; then
        echo "Found: $1.bak"
        mv "$1"{.bak,}
    fi
}


#########
#  FZF  #
#########

alias fzf="fzf-tmux -d 30% --"


#############
#  RIPGREP  #
#############

# fuzzy rg
frg() {
    rg --line-number \
        --column \
        --no-heading \
        --color=always \
        --colors='match:none' \
        --colors='path:fg:white' \
        --colors='line:fg:white' \
        "$@" . 2> /dev/null \
        | fzf --ansi
}


#######################
# THE SILVER SEARCHER #
#######################

alias ag="ag \
    --hidden \
    --follow \
    --smart-case \
    --numbers \
    --color-match '1;31' \
    --color-path '0;37' \
    --color-line-number '1;33'"

# fuzzy ag
fag() {
    ag --nobreak \
        --noheading \
        --color \
        --color-match '' \
        --color-path '0;37' \
        --color-line-number '0;37' \
        "$@" . 2> /dev/null \
        | fzf --ansi
}


##################
# FUZZY COMMANDS #
##################

# # cd to selected directory (no hidden files)
# cnh() {
#       cd "$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null \
#           | fzf +m -q "$1" -0)"
# }

# cd to selected directory (no hidden files)
cnh() {
    cd "$(fd --follow --type d '.' "${1:-.}" 2> /dev/null \
        | fzf +m -q "$1" -0)" \
        || return 1
}

# # cnh, but including hidden directories
# c() {
#       cd "$(find -L ${1:-.} -type d 2> /dev/null \
#           | fzf +m -q "$1" -0)"
# }

# cnh, but including hidden directories
c() {
    cd "$(fd --hidden --follow --type d '.' "${1:-.}" 2> /dev/null \
        | fzf +m -q "$1" -0)" \
        || return 1
}

# # cd to selected directory and open ranger
# fr() {
#       cd "$(find -L ${1:-.} -type d 2> /dev/null \
#           | fzf +m -q "$1" -0)" && ranger
# }

# cd to selected directory and open ranger
fr() {
    cd "$(fd --hidden --follow --type d '.' "${1:-.}" 2> /dev/null \
        | fzf +m -q "$1" -0)" \
        && ranger
}

# open the selected file with the default editor
#       - CTRL-O to open with `open` command,
#       - CTRL-E or Enter key to open with the $EDITOR
fo() {
    local out file key
    IFS=$'\n' out=($(fzf -q "$1" -0 --expect=ctrl-o,ctrl-e))
    key=$(head -1 <<< "$out")
    file=$(head -2 <<< "$out" | tail -1)
    if [ -n "$file" ]; then
        [ "$key" = ctrl-o ] \
            && mimeopen -n "$file" \
            || "${EDITOR:-vim}" "$file"
    fi
}

# cd into the directory of the selected file
cdf() {
    local file
    local dir
    file=$(fzf +m -q "$1" -0) \
        && dir=$(dirname "$file") \
        && cd "$dir" \
        || return 1
}

# browse chrome history
ch() {
    local cols sep google_history open
    cols=$(( COLUMNS / 3 ))
    sep='{::}'

    if [ "$(uname)" = "Darwin" ]; then
        google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
        open="open"
    else
        google_history="$HOME/.config/chromium/Default/History"
        open="mimeopen -n"
    fi

    cp -f "$google_history" /tmp/h
    sqlite3 -separator "$sep" /tmp/h \
        "select substr(title, 1, $cols), url
    from urls order by last_visit_time desc" \
        | awk -F "$sep" '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' \
        | fzf --ansi -m \
        | sed 's#.*\(https*://\)#\1#' \
        | xargs "$open" > /dev/null 2> /dev/null
}

# cd to selected parent directory
fdp() {
    local dirs=()

    get_parent_dirs() {
        if [[ -d "$1" ]]; then
            dirs+=("$1"); else return;
        fi
        if [[ "$1" == '/' ]]; then
            for d in "${dirs[@]}"; do
                echo "$d";
            done
        else
            get_parent_dirs "$(dirname "$1")"
        fi
    }

    cd "$(get_parent_dirs "$(realpath "${1:-$PWD}")" | fzf --tac)" \
        || return 1
}
