export SUDO_ASKPASS=$HOME/.bin/rofi/scripts/rofi-askpass

# Path to your oh-my-zsh installation.
export ZSH_CONFIG="$HOME/.zsh.d"
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

export ZSH_THEME="robbyrussell"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

 [[ -f "$HOME/.zprofile" ]] \
    && source "$HOME/.zprofile"
 
export PATH="$HOME/.bin/:$PATH"   # Add user binaries and scripts to path

export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="kitty"
export BROWSER="chromium"
export READER="zathura"

#####################
#  PLUGIN SETTINGS  #
#####################

# bgnotify settings
# bgnotify_threshold=1    ## set your own notification threshold
# bgnotify_formatted() {
#     ## $1=exit_status, $2=command, $3=elapsed_time
#     [[ $1 -eq 0 ]] && title="Zsh" || title="Zsh (fail)"
#     bgnotify "$title (${3}s)" "$2"
# }

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    # zsh-syntax-highlighting
    # zsh-completions
    # tmuxinator
    zsh-autosuggestions
    command-not-found
    colorize
    # bgnotify
    vi-mode
)

# Remove plugins if in tty
[[ "$TERM" = 'linux' ]] \
    && plugins=("${(@)plugins:#zsh-autosuggestions}")

# Completions
[[ -f "$ZSH_CONFIG/completion.zsh" ]] \
    && source "$ZSH_CONFIG/completion.zsh"

# Oh-My-Zsh
[[ -f "$ZSH/oh-my-zsh.sh" ]] \
    && source "$ZSH/oh-my-zsh.sh"

# NNN
n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

############
#  CUSTOM  #
############

# Zsh options
setopt COMPLETE_ALIASES
setopt HIST_IGNORE_SPACE
setopt NO_AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt PROMPT_SUBST

# No scrolllock
# stty -ixon

# Highlighting
[[ -f "$ZSH_CONFIG/highlight.zsh" ]] \
    && source "$ZSH_CONFIG/highlight.zsh"

# Aliases
[[ -f "$ZSH_CONFIG/alias.zsh" ]] \
    && source "$ZSH_CONFIG/alias.zsh"

# Gruvbox colors fix
# [[ -f "$HOME/.bin/fix-gruvbox-palette" ]] \
#     && [[ "$TERM" != 'xterm-kitty' ]] \
#     && [[ "$TERM" != 'tmux-256color' ]] \
#     && source "$HOME/.bin/fix-gruvbox-palette"
#
# TMUX
# main_attached="$(tmux list-sessions -F '#S #{session_attached}' \
#     2>/dev/null \
#     | sed -n 's/^main[[:space:]]//p')"
# if [[ ! "$main_attached" -gt '0' ]] && [[ ! "$TERM" == 'linux' ]]; then
#     tmux attach -t main >/dev/null 2>&1 || tmux new -s main >/dev/null 2>&1
#     exit
# fi

# # # Directly source prompt
# # source "$ZSH/custom/themes/gruvbox-dark.zsh-theme"

HISTFILE=~/.zsh_history         # location of command history file 
HISTSIZE=1000                   # hist file max lines
SAVEHIST=1000                   # max amount of history to keep
setopt HIST_IGNORE_DUPS         # only keep most recent usage of a command

setopt PROMPT_SUBST         # Prompt substitution
setopt PUSHD_IGNORE_DUPS    # Ignore duplicates
setopt PUSHD_SILENT         # Silent pushing and popping
setopt SHARE_HISTORY        # Share history between sessions
