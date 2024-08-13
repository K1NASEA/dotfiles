# setup Language and timezone
if locale -a | grep -q '^ja_JP\.utf8$'; then
    export LANG='ja_JP.UTF-8'
    export LC_CTYPE='ja_JP.UTF-8'
    export TZ='Asia/Tokyo'
fi

# PATH
export PATH="${HOME}/repos/github.com/K1NASEA/dotfiles/bin:${PATH}"

# USER
export USER="$(/usr/bin/id -un)"

# docker config
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"

# wget config
export WGETRC="${XDG_CONFIG_HOME}/wget/.wgetrc"

# history for less command
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"

export REPORTTIME=10 # Report command execution time if it exceeds 10 seconds
export KEYTIMEOUT=1  # Time in deciseconds (0.1 second) to wait for a key sequence to complete

# Editor
export EDITOR='nvim'
export GIT_EDITOR='nvim'
