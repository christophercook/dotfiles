#!/usr/bin/env bash

# This script will backup existing bash configuration and create new
# configuration in the XDG_CONFIG_HOME (default ~/.config) path.

# It will also attempt to relocate configuration for other apps and
# tools which are known to support the XDG DIRS paths in an effort to
# minimize dotfiles located in the home directory.

# It is designed to be nearly idempotent (able to be run repeatedly
# without causing harm).

# Get script directory
# realpath is expected to exist on modern Linux and macOS
if [[ -x "$(which realpath)" ]] && [[ -n "${BASH_SOURCE[0]}" ]]; then
  cwd=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
else
  cwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
fi

### Desktop environment

if [[ -n "$DESKTOP_SESSION" || "$OSTYPE" = darwin* ]]; then

  # Create aliases for XDG dirs
  if [[ "$OSTYPE" = darwin* ]]; then
    config_dir="${XDG_CONFIG_HOME-$HOME/Library/Application Support}"
    data_dir="${XDG_DATA_HOME-$HOME/Library/Application Support}"
    cache_dir="${XDG_CACHE_HOME-$HOME/Library/Caches}"
  else
    config_dir="${XDG_CONFIG_HOME-$HOME/.config}"
    data_dir="${XDG_DATA_HOME-$HOME/.local/share}"
    cache_dir="${XDG_CACHE_HOME-$HOME/.cache}"
  fi

  # Move bash history to new data_dir but don't overwrite
  mkdir -p "$data_dir"/bash
  [ -f ~/.bash_history ] && mv -n ~/.bash_history "$data_dir"/bash_history

  # Move existing files to backup directory
  backup_dir="$HOME/bash_profile_backup_$(date +%s)"
  mkdir "$backup_dir"
  for f in "$HOME"/.{profile,bash*}; do
    if [ -f "$f" ]; then
      # if file is a symlink then delete rather than backup
      [ -L "$f" ] && rm "$f" && continue

      dest="$backup_dir/$(basename "$f" | cut -d\. -f2)"
      mv -v "$f" "$dest"
    fi
  done
  unset dest f

  # Backup bash directory if found in XDG_CONFIG_HOME path
  if [ -d "$config_dir"/bash ] && [ ! -L "$config_dir"/bash ]; then
    mkdir -p "$backup_dir"/config
    mv -v "$F" "$backup_dir"/config/
  fi

  # If backup dir is empty at this point lets remove it
  [ "$(find "$backup_dir" -type f | wc -l)" -eq "0" ] && rmdir "$backup_dir"
  unset backup_dir

  # Create config dir if it doesn't exist
  mkdir -p "$data_dir"

  # Add support for user profile in XDG CONFIG HOME
  if [ ! -f /etc/profile.d/xdg_config_home_profile ]; then
    sudo tee /etc/profile.d/xdg_config_home_profile.sh > /dev/null << EOF
# /etc/profile.d/xdg_config_home_profile.sh - Load user profile from XDG CONFIG HOME

# Added by https://github.com/christophercook/dotfiles

# Source user profile if available
[ -r "\${XDG_CONFIG_HOME:-$HOME/.config}/profile" ] &&
            . "\${XDG_CONFIG_HOME:-$HOME/.config}/profile"
EOF
  fi

  # Symlink bash config into XDG_CONFIG_HOME
  ln -sfv "$cwd"/config/bash "$config_dir"

  # Modify /etc/bash.bashrc to load bashrc from $XDG_CONFIG_HOME/bash/
  if [ -f /etc/bash.bashrc ]; then
    if ! grep -q "\$HOME/.config/bash/bashrc" /etc/bash.bashrc; then
      mkdir -p "$data_dir"/bash
      echo "writing /etc/bash.bashrc"

      sudo tee -a /etc/bash.bashrc > /dev/null << EOF

[ -d "${data_dir/"$HOME"/"\$HOME"}/bash" ] && HISTFILE="${data_dir/"$HOME"/"\$HOME"}/bash/bash_history"
[ -f "${config_dir/"$HOME"/"\$HOME"}/bash/bashrc" ] && . "${config_dir/"$HOME"/"\$HOME"}/bash/bashrc"
EOF
    fi
  fi

  # Move some supported dot files from home
  [ -d "$HOME"/.gnupg ] && mv "$HOME"/.gnupg "$config_dir"/gnupg
  [ -f "$HOME"/.ICEauthority ] && mkdir -p "$cache_dir"/ice && mv "$HOME"/.ICEauthority "$cache_dir"/ice/authority

  # Display final instructions
  echo -e "\033[1;37m"
  echo -e "All done setting up Bash. Close and restart your terminal. Some changes require rebooting."
  echo -e "\033[0m"

### Server environment
else
  # Define config_dir
  config_dir="${XDG_CONFIG_HOME-$HOME/.config}"

  # Copy bash files
  mkdir -p "$config_dir"/bash
  cp -uv --backup=numbered "$cwd"/config/bash/{*.sh,dircolors} "$config_dir"/bash
  cp -uv --backup=numbered "$cwd"/config/bash/bashrc "$HOME"/.bashrc
fi

# Clean up
unset config_dir data_dir cache_dir cwd
