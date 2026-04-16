# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# export SUDO_ASKPASS=$HOME/.bin/rofi/scripts/rofi-askpass
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src


export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.bin/:$PATH"   # Add user binaries and scripts to path

# Path to your oh-my-zsh installation.
export ZSH_CONFIG="$HOME/.zsh.d"
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

export ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

 [[ -f "$HOME/.zprofile" ]] \
    && source "$HOME/.zprofile"
 

# export VISUAL='/home/jose/.local/bin/lvim'
# export EDITOR='/home/jose/.local/bin/lvim'
export TERMINAL="kitty"
export BROWSER="google-chrome"
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
    zsh-syntax-highlighting
    zsh-completions
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

# Gruvbox palette for TTY (virtual console only)
if [[ "$TERM" = "linux" ]]; then
    echo -en "\e]P0282828"  # colour0  bg0
    echo -en "\e]P1cc241d"  # colour1  red
    echo -en "\e]P298971a"  # colour2  green
    echo -en "\e]P3d79921"  # colour3  yellow
    echo -en "\e]P4458588"  # colour4  blue
    echo -en "\e]P5b16286"  # colour5  purple
    echo -en "\e]P6689d6a"  # colour6  aqua
    echo -en "\e]P7a89984"  # colour7  fg4/gray
    echo -en "\e]P8928374"  # colour8  bright gray
    echo -en "\e]P9fb4934"  # colour9  bright red
    echo -en "\e]PAb8bb26"  # colour10 bright green
    echo -en "\e]PBfabd2f"  # colour11 bright yellow
    echo -en "\e]PC83a598"  # colour12 bright blue
    echo -en "\e]PDd3869b"  # colour13 bright purple
    echo -en "\e]PE8ec07c"  # colour14 bright aqua
    echo -en "\e]PFebdbb2"  # colour15 fg1
    clear
fi
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

#export PATH=$PATH:/home/jose/.spicetify

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
if [[ "$TERM" = "linux" ]]; then
    [[ ! -f ~/.p10k-tty.zsh ]] || source ~/.p10k-tty.zsh
else
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

# bun completions
[ -s "/home/jose/.bun/_bun" ] && source "/home/jose/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Claude Code LSP
export ENABLE_LSP_TOOL=1
export ENABLE_LSP_TOOL=1

export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# export SUPABASE_ACCESS_TOKEN="sbp_b0286bb9ba52cc3a6dea0c58498e049adb319297"

# opencode
export PATH=/home/jose/.opencode/bin:$PATH
