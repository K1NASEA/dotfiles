#!/usr/bin/env bash

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as errors.

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

DOTFILES="${INSTALL_DIR:-$XDG_DATA_HOME/dotfiles}"

CONFIG_DIRS=(
  "bash"
  "fzf"
  "git"
  "nvim"
  "sheldon"
  "starship"
  "wget"
  "zsh"
)

COLOR_RED="\033[1;31m"
COLOR_GREEN="\033[1;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_BLUE="\033[1;34m"
COLOR_PURPLE="\033[1;35m"
COLOR_GRAY="\033[1;37m"
COLOR_NONE="\033[0m"

# Check the permissions of the execution user
SUDO=""
if [ "$EUID" -ne 0 ]; then
  # Add sudo for general users
  SUDO="sudo"
fi

usage() {
  echo -e $"\nUsage: $(basename "$0") {install|uninstall|backup|link|homebrew|shell|git|japanese|}\n"
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
  title "Backing up dotfiles"

  BACKUP_DIR="${XDG_CONFIG_HOME}/backup_$(date +%Y-%m-%dT%H:%M:%S)"
  info "Creating backup directory at $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"

  for config in "${CONFIG_DIRS[@]}"; do
    target="${XDG_CONFIG_HOME}/$(basename "$config")"
    if [ ! -L "$target" ] && [ -d "$target" ]; then
      info "Backing up \"$target\""
      cp -rf "$target" "$BACKUP_DIR"
    else
      warning "$target does not exist at this location or is a symlink"
    fi
  done
}

setup_homebrew() {
  title "Setting up Homebrew"

  if test ! "$(command -v brew)"; then
    info "Homebrew not installed. Installing."

    if test "$(command -v apt-get)"; then
      $SUDO apt-get -y install build-essential procps curl file git
    elif test "$(command -v yum)"; then
      $SUDO yum -y groupinstall 'Development Tools'
      $SUDO yum -y install procps-ng curl file git --allowerasing
    elif test "$(command -v pacman)"; then
      $SUDO pacman -S --noconfirm base-devel procps-ng curl file git
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
  fi

  # install brew dependencies from Brewfile
  brew bundle --file "$DOTFILES/Brewfile"

  # add locales for glibc in homebrew
  if brew list | grep -q "^perl$" && brew list | grep -q "^glibc$"; then
    "$(brew --prefix glibc)/bin/localedef" -c -i C -f UTF-8 C.UTF-8 2>/dev/null
    "$(brew --prefix glibc)/bin/localedef" -c -i ja_JP -f UTF-8 ja_JP.UTF-8 2>/dev/null
  fi
}

setup_symlinks() {
  title "Creating symlinks"

  info "installing to $XDG_CONFIG_HOME"
  if [ ! -d "$XDG_CONFIG_HOME" ]; then
    info "Creating $XDG_CONFIG_HOME"
    mkdir -p "$XDG_CONFIG_HOME"
  fi

  for config in "${CONFIG_DIRS[@]}"; do
    target="$XDG_CONFIG_HOME/$(basename "$config")"
    if [ -e "$target" ]; then
      info "~${target#"$HOME"} already exists... Skipping."
    else
      info "Creating symlink for $config"
      ln -snf "${DOTFILES}/${config}" "$target"
    fi
  done

  if [ ! -d "$XDG_DATA_HOME" ]; then
    info "Creating $XDG_DATA_HOME"
    mkdir -p "$XDG_DATA_HOME"
  fi

  if [ ! -d "$XDG_STATE_HOME" ]; then
    info "Creating $XDG_STATE_HOME"
    mkdir -p "$XDG_STATE_HOME"
    chmod 0700 "$XDG_STATE_HOME"
    mkdir -m 0700 "${XDG_STATE_HOME}/zsh"
    mkdir -m 0700 "${XDG_STATE_HOME}/bash"
    mkdir -m 0700 "${XDG_STATE_HOME}/less"
    mkdir -m 0700 "${XDG_STATE_HOME}/wget"
  fi
}

setup_shell() {
  title "Configuring shell"

  [[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"
  if ! grep "$zsh_path" /etc/shells; then
    info "adding $zsh_path to /etc/shells"
    echo "$zsh_path" | $SUDO tee -a /etc/shells >/dev/null
  fi

  if [ "$SHELL" != "$zsh_path" ]; then
    if test "$(command -v chsh)"; then
      chsh -s "$zsh_path"
    else
      $SUDO usermod --shell "$zsh_path" "$(id -un)"
    fi
    info "default shell changed to $zsh_path"
  fi

  if [ -d /etc/zsh ]; then
    if [ ! -f /etc/zsh/zshenv ]; then
      echo "test -d \"\${HOME}/.config/zsh\" && export ZDOTDIR=\"\${HOME}/.config/zsh\"" | $SUDO tee /etc/zsh/zshenv >/dev/null
    fi
  else
    if [ ! -f /etc/zshenv ]; then
      echo "test -d \"\${HOME}/.config/zsh\" && export ZDOTDIR=\"\${HOME}/.config/zsh\"" | $SUDO tee /etc/zshenv >/dev/null
    fi
  fi

  if [ -d /etc/bash ]; then
    if [ -d /etc/bash/bashrc.d ]; then
      if [ ! -f /etc/bash/bashrc.d/bash_xdg.sh ]; then
        echo "test -f \"\${HOME}/.config/bash/.bashrc\" && source \"\${HOME}/.config/bash/.bashrc\"" | $SUDO tee /etc/bash/bashrc.d/bash_xdg.sh >/dev/null
      fi
    fi
  else
    if [ -d /etc/profile.d ]; then
      if [ ! -f /etc/profile.d/bash_xdg.sh ]; then
        echo "test -f \"\${HOME}/.config/bash/.bashrc\" && source \"\${HOME}/.config/bash/.bashrc\"" | $SUDO tee /etc/profile.d/bash_xdg.sh >/dev/null
      fi
    fi
  fi
}

setup_git() {
  title "Setting up Git"

  defaultName=$(git config user.name || true)
  defaultEmail=$(git config user.email || true)

  read -rp "Name [$defaultName]: " name
  read -rp "Email [$defaultEmail]: " email

  git config -f "${XDG_CONFIG_HOME}/.gitconfig-local" user.name "${name:-$defaultName}"
  git config -f "${XDG_CONFIG_HOME}/.gitconfig-local" user.email "${email:-$defaultEmail}"
}

setup_japanese() {
  title "Set Japanese localization"

  if test "$(command -v apt-get)"; then
    cat /etc/*release | grep "^ID=" | grep -iq "debian" && $SUDO apt-get -y install task-japanese locales-all
    cat /etc/*release | grep "^ID=" | grep -iq "ubuntu" && $SUDO apt-get -y install language-pack-ja-base language-pack-ja
  elif test "$(command -v yum)"; then
    $SUDO yum -y install langpacks-core-ja
  fi
}

uninstall_shell() {
  title "Uninstall shell"

  for target in "/etc/zsh/zshenv" "/etc/zshenv" "/etc/bash/bashrc.d/bash_xdg.sh" "/etc/profile.d/bash_xdg.sh"; do
    if [ -f "$target" ]; then
      info "Cleaning up \"$target\""
      rm -f "$target"
    fi
  done
}

uninstall_dotfiles() {
  title "Uninstall dotfiles"

  for config in "${CONFIG_DIRS[@]}"; do
    target="${XDG_CONFIG_HOME}/$(basename "$config")"
    if [ -L "$target" ]; then
      info "Cleaning up \"$target\""
      rm -f "$target"
    elif [ -e "$target" ]; then
      warning "Skipping \"$target\" because it is not a symlink"
    else
      warning "Skipping \"$target\" because it does not exist"
    fi
  done
}

if [ $# -eq 0 ]; then
  set -- install
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
git)
  setup_git
  ;;
japanese)
  setup_japanese
  ;;
install)
  setup_homebrew
  setup_symlinks
  setup_shell
  setup_git
  ;;
uninstall)
  uninstall_shell
  uninstall_dotfiles
  ;;
*)
  usage
  ;;
esac

echo -e
success "Done."
