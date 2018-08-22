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
if [[ -x "$(which realpath)" ]] && [[ -n "$BASH_SOURCE[0]" ]]; then
  CWD=$(dirname $(realpath "$BASH_SOURCE[0]"))
else
  CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
fi

### Desktop environment

if [[ -n "$DESKTOP_SESSION" || "$OSTYPE" = darwin* ]]; then

  # Define dirs
  if [[ "$OSTYPE" = darwin* ]]; then
    CONFIG_DIR="${XDG_CONFIG_HOME-$HOME/Library/Application Support}"
    DATA_DIR="${XDG_DATA_HOME-$HOME/Library/Application Support}"
  else
    CONFIG_DIR="${XDG_CONFIG_HOME-$HOME/.config}"
    DATA_DIR="${XDG_DATA_HOME-$HOME/.local/share}"
  fi

  # Create config and data dirs if they don't exist
  [ ! -d "$CONFIG_DIR" ] && mkdir -p "$CONFIG_DIR"
  [ ! -d "$DATA_DIR" ] && mkdir -p "$DATA_DIR"

  # Move bash history to new DATA_DIR but don't overwrite
  [ -f ~/.bash_history ] && mv -n ~/.bash_history "$DATA_DIR"/bash_history

  # Move existing files to backup directory
  BACKUP_DIR="$HOME/bash_profile_backup_$(date +%s)"
  mkdir "$BACKUP_DIR"
  for F in "$HOME"/.{bash*,profile}; do
    [ -L "$F" ] && continue
    DEST="$BACKUP_DIR/$(basename $F|cut -d\. -f2)"
    mv -v "$F" "$DEST"
  done

  # Backup bash directory if found in XDG_CONFIG_HOME path
  if [ -d "$CONFIG_DIR"/bash ] && [ ! -L "$CONFIG_DIR"/bash ]; then
    mkdir -p "$BACKUP_DIR"/config
    mv -v "$F" "$BACKUP_DIR"/config/
  fi

  # If backup dir is empty at this point lets remove it
  [ "$(ls -A -1 $BACKUP_DIR | wc -l)" -eq 0 ] && rmdir "$BACKUP_DIR"

  # Symlink bash config into CONFIG_HOME
  ln -sfv "$CWD"/config/bash "$CONFIG_DIR"

  # Symlink profile and bashrc file into HOME
  ln -sfv "$CWD"/config/profile "$HOME"/.profile
  ln -sfv "$CWD"/config/bash/bashrc "$HOME"/.bashrc

  # Clean up
  unset CONFIG_DIR DATA_DIR BACKUP_DIR

### Server environment
#else
  # TODO
fi

# Clean up
unset CWD DEST F

source ~/.profile
