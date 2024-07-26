# Setup fzf
# ---------
if [[ ! "$PATH" == */home/linuxbrew/.linuxbrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/linuxbrew/.linuxbrew/opt/fzf/bin"
fi

export FZF_DEFAULT_OPTS="--border --height=~93% --color=bg+:#EB5505,fg+:#FFFFFF,gutter:-1"

eval "$(fzf --bash)"
