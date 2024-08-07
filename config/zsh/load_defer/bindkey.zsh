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

function ghq-fzf() {
    local src=$(ghq list | fzf --border --reverse --height=100% --preview "bat --color=always --style=grid $(ghq root)/{}/README.*")
    if [ -n "$src" ]; then
        BUFFER="cd $(ghq root)/$src"
        zle accept-line
    fi
    zle -R -c
}
zle -N ghq-fzf
bindkey '^G' ghq-fzf
