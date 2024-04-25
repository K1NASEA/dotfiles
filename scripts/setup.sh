#!/bin/sh

set -e  # Exit immediately if a command files
set -u  # Treat unset variables as errors

. "$(dirname "$0")/common.sh"

/bin/sh "$CUR_DIR/setup-apt.sh"
