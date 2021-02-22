# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH_CONFIG="$HOME/.zsh.d"
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line to enable command auto-correction.
 ENABLE_CORRECTION="true"

 [[ -f "$HOME/.zprofile" ]] \
    && source "$HOME/.zprofile"
 
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="kitty"
export BROWSER="Google-chrome"
export READER="zathura"

export PATH="$PATH:`pwd`/flutter/bin"

# if [[ "$TERM" != 'linux' ]]; then
    # ZSH_THEME='gruvbox-dark'
# fi

#echo "[3m$(fortune -sa)\n"    # display a random short quote at start

###############
#  DIRCOLORS  #
###############

# eval dircolors
# [[ -f "$HOME/.dircolors" ]] \
    # && eval "$(dircolors "$HOME/.dircolors")"

#####################
#  PLUGIN SETTINGS  #
#####################

# bgnotify settings
bgnotify_threshold=1    ## set your own notification threshold
bgnotify_formatted() {
    ## $1=exit_status, $2=command, $3=elapsed_time
    [[ $1 -eq 0 ]] && title="Zsh" || title="Zsh (fail)"
    bgnotify "$title (${3}s)" "$2"
}

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    # zsh-syntax-highlighting
    # zsh-completions
    tmuxinator
    zsh-autosuggestions
    command-not-found
    colorize
    bgnotify
    vi-mode
    colored-man-pages
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

# # Alternative prompt
# if [[ "$TERM" == "linux" ]]; then
#     PROMPT='[%F{167}%B%n%b%f@%M %~]'
#     PROMPT+='$(git_prompt_info)'
#     PROMPT+=' %(?.%F{108}.%F{167})%B%(!.#.$)%b%f '
#     ZSH_THEME_GIT_PROMPT_PREFIX=" [%F{214}%B"
#     ZSH_THEME_GIT_PROMPT_SUFFIX="%b%f]"
#     ZSH_THEME_GIT_PROMPT_DIRTY="%F{167}%B*%b%f"
#     ZSH_THEME_GIT_PROMPT_CLEAN=""
# fi

# # # Directly source prompt
# # source "$ZSH/custom/themes/gruvbox-dark.zsh-theme"

# HISTFILE=~/.local/histfile      # location of command history file HISTSIZE=1000                   # hist file max lines
# SAVEHIST=1000                   # max amount of history to keep
# setopt HIST_IGNORE_DUPS         # only keep most recent usage of a command

# # {{{ PROMPT
# autoload -Uz promptinit && promptinit
# prompt elite
# function parse_git_dirty {
#     [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
# }
# function parse_git_branch {
#     git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
# }
# function parse_current_dir {
#     ruby -e "puts ('../'+Dir.getwd.split('/').last(2).join('/')).gsub('//', '/')"
# }

# CURRENT_BG='NONE'
# SEGMENT_SEPARATOR=''

# # Begin a segment
# # Takes two arguments, background and foreground. Both can be omitted,
# # rendering default background/foreground.
# prompt_segment() {
#   local bg fg
#   [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
#   [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
#   if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
#     echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
#   else
#     echo -n "%{$bg%}%{$fg%} "
#   fi
#   CURRENT_BG=$1
#   [[ -n $3 ]] && echo -n $3
# }

# # End the prompt, closing any open segments
# prompt_end() {
#   if [[ -n $CURRENT_BG ]]; then
#     echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
#   else
#     echo -n "%{%k%}"
#   fi
#   echo -n "%{%f%}"
#   CURRENT_BG=''
# }

# # Prompt components
# # Each component will draw itself, and hide itself if no information needs to be shown
# # Context: user@hostname (who am I and where am I)
# prompt_context() {
#   if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
#     prompt_segment 246 235 "%(!.%{%F{yellow}%}.)$USER@%m"
#     # prompt_segment 246 235 "%(!.%{%F{yellow}%}.)󰣇"
#   fi
# }

# # Git: branch/detached head, dirty status
# prompt_git() {
#   local ref dirty mode repo_path
#   repo_path=$(git rev-parse --git-dir 2>/dev/null)

#   if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
#     dirty=$(parse_git_dirty)
#     ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
#     if [[ -n $dirty ]]; then
#       prompt_segment 172 black
#     else
#       prompt_segment green black
#     fi

#     if [[ -e "${repo_path}/BISECT_LOG" ]]; then
#       mode=" <B>"
#     elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
#       mode=" >M<"
#     elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
#       mode=" >R>"
#     fi

#     setopt promptsubst
#     autoload -Uz vcs_info

#     zstyle ':vcs_info:*' enable git
#     zstyle ':vcs_info:*' get-revision true
#     zstyle ':vcs_info:*' check-for-changes true
#     zstyle ':vcs_info:*' stagedstr '✚'
#     zstyle ':vcs_info:git:*' unstagedstr '●'
#     zstyle ':vcs_info:*' formats ' %u%c'
#     zstyle ':vcs_info:*' actionformats ' %u%c'
#     vcs_info
#     echo -n "${ref/refs\/heads\// }${vcs_info_msg_0_%% }${mode}"
#   fi
# }

# prompt_hg() {
#   local rev status
#   if $(hg id >/dev/null 2>&1); then
#     if $(hg prompt >/dev/null 2>&1); then
#       if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
#         # if files are not added
#         prompt_segment red white
#         st='±'
#       elif [[ -n $(hg prompt "{status|modified}") ]]; then
#         # if any modification
#         prompt_segment yellow black
#         st='±'
#       else
#         # if working copy is clean
#         prompt_segment green black
#       fi
#       echo -n $(hg prompt "☿ {rev}@{branch}") $st
#     else
#       st=""
#       rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
#       branch=$(hg id -b 2>/dev/null)
#       if `hg st | grep -q "^\?"`; then
#         prompt_segment red black
#         st='±'
#       elif `hg st | grep -q "^[MA]"`; then
#         prompt_segment yellow green
#         st='±'
#       else
#         prompt_segment green black
#       fi
#       echo -n "☿ $rev@$branch" $st
#     fi
#   fi
# }

# # Dir: current working directory
# prompt_dir() {
#   prompt_segment 239 248 ' %~'
# }

# # Virtualenv: current working virtualenv
# prompt_virtualenv() {
#   local virtualenv_path="$VIRTUAL_ENV"
#   if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
#     prompt_segment blue black "(`basename $virtualenv_path`)"
#   fi
# }

# # Status:
# # - was there an error
# # - am I root
# # - are there background jobs?
# prompt_status() {
#   local symbols
#   symbols=()
#   [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
#   [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
#   [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

#   [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
# }

# ## Main prompt
# build_prompt() {
#   RETVAL=$?
#   prompt_status
#   prompt_virtualenv
#   prompt_context
#   prompt_dir
#   prompt_git
#   prompt_hg
#   prompt_end
# }

# PROMPT='%{%f%b%k%}$(build_prompt) '

# zstyle ':completion:*' menu select
# # }}}

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
