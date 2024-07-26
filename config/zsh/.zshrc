# load sheldon
sheldon_cache="$XDG_CACHE_HOME/sheldon.zsh"
sheldon_toml="$XDG_CONFIG_HOME/sheldon/zsh.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
    mkdir -p $XDG_CACHE_HOME
    sheldon source >$sheldon_cache
fi
source "$sheldon_cache"
unset sheldon_cache sheldon_toml
