#!/bin/sh

set -e  # Exit immediately if a command files
set -u  # Treat unset variables as errors

source "$(dirname "$0")/common.sh"

command -v apt-get >/dev/null || exit 0

sudo /bin/sh "$REPO_DIR/config/apt/install.sh"
