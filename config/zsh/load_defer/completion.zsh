fpath=(
    /usr/share/zsh/site-functions
    /usr/share/zsh/vendor-completions
    $fpath
)
[ ! -d "${XDG_CACHE_HOME}/zsh" ] && mkdir -p "${XDG_CACHE_HOME}/zsh"
autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
