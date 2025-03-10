#shellcheck shell=bash
# setup Language and timezone
if locale -a | grep -q '^ja_JP\.utf8$'; then
    export LANG='ja_JP.UTF-8'
    export LC_CTYPE='ja_JP.UTF-8'
    export TZ='Asia/Tokyo'
fi

# PATH
if ! echo "$PATH" | grep -q "${HOME}/.local/bin:${HOME}/bin"; then
    export PATH="${HOME}/.local/bin:${HOME}/bin:${PATH}"
fi

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

# GPG
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
GPG_TTY="$(tty)"
export GPG_TTY

# Python
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"

# SQLite
export SQLITE_HISTORY="${XDG_STATE_HOME}/sqlite/history"

# Public Cloud
export AZURE_CONFIG_DIR="${XDG_DATA_HOME}/azure"
export AWS_SHARED_CREDENTIALS_FILE="${XDG_CONFIG_HOME}/aws/credentials"
export AWS_CONFIG_FILE="${XDG_CONFIG_HOME}/aws/config"
export OCI_CLI_RC_FILE="${XDG_CONFIG_HOME}/oci/oci_cli_rc"
