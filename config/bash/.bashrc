# shellcheck shell=bash

# Environment variables
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CACHE_HOME="${HOME}/.cache"
export BASHDOTDIR="${XDG_CONFIG_HOME}/bash"
export LANG='C'
export LC_CTYPE='C.UTF-8'
export TERM='xterm-256color'

# load Homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
	# Homebrew exists at /opt/homebrew for arm64 macos
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
	# or at /usr/local for intel macos
	eval "$(/usr/local/bin/brew shellenv)"
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
	# or from linuxbrew
	test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
	test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# load sheldon
export SHELDON_CONFIG_FILE="$XDG_CONFIG_HOME/sheldon/bash_plugins.toml"
export SHELDON_DATA_DIR="$XDG_DATA_HOME/sheldon_bash"
sheldon_cache="$XDG_CACHE_HOME/sheldon/sheldon.bash"
if [[ ! -r "$sheldon_cache" || "$SHELDON_CONFIG_FILE" -nt "$sheldon_cache" ]]; then
	mkdir -p "${XDG_CACHE_HOME}/sheldon"
	sheldon source >"$sheldon_cache"
fi
# shellcheck source=/dev/null
source "$sheldon_cache"
unset sheldon_cache
