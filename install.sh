#!/bin/sh

set -e  # Exit immediately if a command files
set -u  # Treat unset variables as errors

INSTALL_DIR="${INSTALL_DIR:-$HOME/repos/github.com/K1NASEA/dotfiles}"

if [ -d "$INSTALL_DIR" ]; then
    echo "Updating dotfiles..."
    git -C "$INSTALL_DIR" pull
else
    echo "Installing dotfiles..."
    git clone https://github.com/K1NASEA/dotfiles "$INSTALL_DIR"
fi

/bin/sh "$INSTALL_DIR/scripts/setup.sh"
