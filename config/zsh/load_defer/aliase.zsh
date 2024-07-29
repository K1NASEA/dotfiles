# reload zsh config
alias reload!='RELOAD=1 source ${ZDOTDIR}/.zshrc'

# Filesystem aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Helpers
alias grep='grep --color=auto'
alias df='df -h'    # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder

alias path='echo $PATH | tr ":" "\n"' # list the PATH separated by new lines

# use eza if available
if [[ -x "$(command -v eza)" ]]; then
    alias l="eza --git --all --long --group --time-style='+%Y-%m-%dT%H:%M:%S'"
    alias ll="eza --git --long --group --time-style='+%Y-%m-%dT%H:%M:%S'"
else
    alias l="ls -lah"
    alias ll="ls -lFh"
fi
alias la="ls -AF"
alias lld="ls -l | grep ^d"
alias rmf="rm -rf"

# git aliases
alias gs='git s'
alias glog="git l"

# tmux aliases
alias ta='tmux attach'
alias tls='tmux ls'
alias tat='tmux attach -t'
alias tns='tmux new-session -s'

# use nvim, but don't make me think about it
if [[ -n "$(command -v nvim)" ]]; then
    alias vi="nvim"
    alias vim="nvim"
    alias view="nvim -R"
    # shortcut to open vim and immediately update vim-plug and all installed plugins
    alias vimu="nvim --headless \"+Lazy! sync\" +qa"
    # immediately open to fugitive's status screen
    alias vimg="nvim +Ge:"
fi
