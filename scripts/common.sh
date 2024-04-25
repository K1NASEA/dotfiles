#!/bin/sh

set -e  # Exit immediately if a command files
set -u  # Treat unset variables as errors

export CUR_DIR="$(cd "$(dirname "$0")"; pwd)"
export REPO_DIR="$(cd "$(dirname "$0")/.."; pwd)"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
