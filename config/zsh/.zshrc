# load sheldon
export SHELDON_CONFIG_FILE="$XDG_CONFIG_HOME/sheldon/zsh_plugins.toml"
export SHELDON_DATA_DIR="$XDG_DATA_HOME/sheldon_zsh"
sheldon_cache="$XDG_CACHE_HOME/sheldon/sheldon.zsh"
if [[ ! -r "$sheldon_cache" || "$SHELDON_CONFIG_FILE" -nt "$sheldon_cache" ]]; then
    mkdir -p "${XDG_CACHE_HOME}/sheldon"
    sheldon source >"$sheldon_cache"
fi
source "$sheldon_cache"
unset sheldon_cache
