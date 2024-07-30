fpath=(
    $fpath
    ${ZDOTDIR}/site-functions
)
[ ! -d "${XDG_CACHE_HOME}/zsh" ] && mkdir -p "${XDG_CACHE_HOME}/zsh"
autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
