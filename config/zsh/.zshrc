# setup Language
if locale -a | grep -q '^ja_JP\.utf8$'; then
    export LANG='ja_JP.UTF-8'
    export LC_CTYPE='ja_JP.UTF-8'
fi

# setup Zsh Plugin Manager
zsh_plugin="${ZDOTDIR}/.zsh_plugin"
[ -f $zsh_plugin ] && source $zsh_plugin

# setup Zsh Prompt
zsh_prompt="${ZDOTDIR}/.zsh_prompt"
[ -f $zsh_prompt ] && source $zsh_prompt

# setup aliases
zsh_aliases="${ZDOTDIR}/.zsh_aliases"
[ -f $zsh_aliases ] && source $zsh_aliases

# setup fzf
fzf_config="${XDG_CONFIG_HOME}/fzf/fzf.zsh"
[ -f $fzf_config ] && source $fzf_config

#prepend_path $ZDOTDIR/../bin

export REPORTTIME=10
export KEYTIMEOUT=1

setopt NO_BG_NICE
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
setopt PROMPT_SUBST

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY     # write the history file in the ":start:elapsed;command" format.
setopt HIST_REDUCE_BLANKS   # remove superfluous blanks before recording entry.
setopt SHARE_HISTORY        # share history between all sessions.
setopt HIST_IGNORE_ALL_DUPS # delete old recorded entry if new entry is a duplicate.

setopt COMPLETE_ALIASES

# make terminal command navigation sane again
bindkey "^[[1;5C" forward-word      # [Ctrl-right] - forward one word
bindkey "^[[1;5D" backward-word     # [Ctrl-left] - backward one word
bindkey '^[^[[C' forward-word       # [Ctrl-right] - forward one word
bindkey '^[^[[D' backward-word      # [Ctrl-left] - backward one word
bindkey '^[[1;3D' beginning-of-line # [Alt-left] - beginning of line
bindkey '^[[1;3C' end-of-line       # [Alt-right] - end of line
bindkey '^[[5D' beginning-of-line   # [Alt-left] - beginning of line
bindkey '^[[H' beginning-of-line    # [Home] - beginning of line
bindkey '^[[5C' end-of-line         # [Alt-right] - end of line
bindkey '^[[F' end-of-line          # [End] - end of line
bindkey '^?' backward-delete-char   # [Backspace] - delete backward
if [[ "${terminfo[kdch1]}" != "" ]]; then
    bindkey "${terminfo[kdch1]}" delete-char # [Delete] - delete forward
else
    bindkey "^[[3~" delete-char # [Delete] - delete forward
    bindkey "^[3;5~" delete-char
    bindkey "\e[3~" delete-char
fi
bindkey "^A" vi-beginning-of-line
bindkey -M viins "^F" vi-forward-word # [Ctrl-f] - move to next word
bindkey -M viins "^E" vi-add-eol      # [Ctrl-e] - move to end of line
bindkey "^J" history-beginning-search-forward
bindkey "^K" history-beginning-search-backward
