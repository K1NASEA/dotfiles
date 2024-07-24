#!/usr/bin/env bash

set -e  # Exit immediately if a command exits with a non-zero status.
set -u  # Treat unset variables as errors.

DOTFILES="${INSTALL_DIR:-$HOME/repos/github.com/K1NASEA/dotfiles}"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

COLOR_RED="\033[1;31m"
COLOR_GREEN="\033[1;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_BLUE="\033[1;34m"
COLOR_PURPLE="\033[1;35m"
COLOR_GRAY="\033[1;37m"
COLOR_NONE="\033[0m"

linkables=(
  "zsh/.zshrc"
  "zsh/.zshenv"
  "zsh/.zprofile"
#  "zsh/.zsh_aliases"
#  "zsh/.zsh_functions"
#  "zsh/.zsh_prompt"
)

usage() {
  echo -e $"\nUsage: $(basename "$0") {backup|link|homebrew|shell|all}\n"
  exit 1
}

title() {
  echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
  echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

error() {
  echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
  exit 1
}

warning() {
  echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
  echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
  echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

backup() {
  BACKUP_DIR=$HOME/dotfiles-backup

  echo "Creating backup directory at $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"

  for file in "${linkables[@]}"; do
    filename="$(basename "$file")"
    target="$HOME/$filename"
    if [ -f "$target" ]; then
      echo "backing up $filename"
      cp "$target" "$BACKUP_DIR"
    else
      warning "$filename does not exist at this location or is a symlink"
    fi
  done

  for filename in "$XDG_CONFIG_HOME/nvim" "$HOME/.vim" "$HOME/.vimrc"; do
    if [ ! -L "$filename" ] && [ -d "$filename" ] ; then
      echo "backing up $filename"
      cp -rf "$filename" "$BACKUP_DIR"
    else
      warning "$filename does not exist at this location or is a symlink"
    fi
  done
}

cleanup_symlinks() {
  title "Cleaning up symlinks"
  for file in "${linkables[@]}"; do
    target="$HOME/$(basename "$file")"
    if [ -L "$target" ]; then
      info "Cleaning up \"$target\""
      rm "$target"
    elif [ -e "$target" ]; then
      warning "Skipping \"$target\" because it is not a symlink"
    else
      warning "Skipping \"$target\" because it does not exist"
    fi
  done

  config_files=$(find "$DOTFILES/config" -maxdepth 1 2>/dev/null)
  for config in $config_files; do
    target="$XDG_CONFIG_HOME/$(basename "$config")"
    if [ -L "$target" ]; then
      info "Cleaning up \"$target\""
      rm "$target"
    elif [ -e "$target" ]; then
      warning "Skipping \"$target\" because it is not a symlink"
    else
      warning "Skipping \"$target\" because it does not exist"
    fi
  done
}

setup_symlinks() {
  title "Creating symlinks"

  for file in "${linkables[@]}"; do
    target="$HOME/$(basename "$file")"
    if [ -e "$target" ]; then
      info "~${target#"$HOME"} already exists... Skipping."
    else
      info "Creating symlink for $file"
      ln -s "$DOTFILES/$file" "$target"
    fi
  done

  echo -e
  info "installing to $XDG_CONFIG_HOME"
  if [ ! -d "$XDG_CONFIG_HOME" ]; then
    info "Creating $XDG_CONFIG_HOME"
    mkdir -p "$XDG_CONFIG_HOME"
  fi

  if [ ! -d "$XDG_DATA_HOME" ]; then
    info "Creating $XDG_DATA_HOME"
    mkdir -p "$XDG_DATA_HOME"
  fi

  config_files=$(find "$DOTFILES/config" -maxdepth 1 2>/dev/null)
  for config in $config_files; do
    target="$XDG_CONFIG_HOME/$(basename "$config")"
    if [ -e "$target" ]; then
      info "~${target#"$HOME"} already exists... Skipping."
    else
      info "Creating symlink for $config"
      ln -s "$config" "$target"
    fi
  done
}

setup_homebrew() {
  title "Setting up Homebrew"

  if test ! "$(command -v brew)"; then
    info "Homebrew not installed. Installing."

    if test "$(command -v apt-get)"; then
      sudo apt-get -y install build-essential procps curl file git
    elif test "$(command -v yum)"; then
      sudo yum -y groupinstall 'Development Tools'
      sudo yum -y install procps-ng curl file git
    elif test "$(command -v pacman)"; then
      sudo pacman -S --noconfirm base-devel procps-ng curl file git
    fi

    # Run as a login shell (non-interactive) so that the script doesn't pause for user input
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login

    if [ "$(uname)" == "Linux" ]; then
      test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
      test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
  fi

  # Cloning Dotfiles
  if [ -d "$DOTFILES" ]; then
    pushd "$DOTFILES"
    git pull
    popd
  else
    git clone https://github.com/K1NASEA/dotfiles.git "$DOTFILES"
    pushd "$DOTFILES"
fi

  # install brew dependencies from Brewfile
  brew bundle
  popd

  # install fzf
  echo -e
  info "Installing fzf"
  "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
}

setup_shell() {
  title "Configuring shell"

  [[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"
  if ! grep "$zsh_path" /etc/shells; then
    info "adding $zsh_path to /etc/shells"
    echo "$zsh_path" | sudo tee -a /etc/shells
  fi

  if [ "$SHELL" != "$zsh_path" ]; then
    chsh -s "$zsh_path"
    info "default shell changed to $zsh_path"
  fi
}

if [ $# -eq 0 ]; then
  usage
fi

case "$1" in
backup)
  backup
  ;;
clean)
  cleanup_symlinks
  ;;
link)
  setup_symlinks
  ;;
homebrew)
  setup_homebrew
  ;;
shell)
  setup_shell
  ;;
all)
  setup_homebrew
  setup_symlinks
  setup_shell
  setup_git
  setup_macos
  ;;
*)
  usage
  ;;
esac

echo -e
success "Done."
