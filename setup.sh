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
  CONFIG_DIR="${XDG_CONFIG_HOME-$HOME/.config}"
  DATA_DIR="${XDG_DATA_HOME-$HOME/.local/share}"

  # Create config and data dirs if they don't exist
  [ ! -d "$CONFIG_DIR" ] && mkdir -p "$CONFIG_DIR"
  [ ! -d "$DATA_DIR" ] && mkdir -p "$DATA_DIR"

  # Move bash history to new DATA_DIR but don't overwrite
  mv -n "$HOME"/.bash_history "$DATA_DIR"/bash_history

  # Move existing files to backup directory
  BACKUP_DIR="$HOME/bash_profile_backup_$(date +%s)"
  echo "Moving existing bash files to $BACKUP_DIR"
  mkdir "$BACKUP_DIR"
  for F in "$HOME"/.bash* "$HOME"/.profile*; do
    [ "$F" = "$HOME/.bashrc" ] && [ -L "$F" ] && rm "$F" && continue # delete if .bashrc is a symlink
    [ "$F" = "$HOME/.profile" ] && [ -L "$F" ] && rm "$F" && continue # delete if .profile is a symlink
    DEST="$BACKUP_DIR/$(basename $F|cut -d\. -f2)"
    echo "Moving $F to $DEST"
    mv "$F" "$DEST"
  done

  # Backup bash directory or trash symlink if found in XDG_CONFIG_HOME path
  F="$CONFIG_DIR"/bash
  if [ -d "$F" ]; then
    if [ -L "$F" ]; then # if dir is a symlink
      rm "$F"
    else
      mkdir -p "$BACKUP_DIR"/.config
      mv "$F" "$BACKUP_DIR"/.config/
    fi
  fi

  # If backup dir is empty at this point lets remove it
  [ "$(ls -A -1 $BACKUP_DIR | wc -l)" -eq 0 ] && rmdir "$BACKUP_DIR"

  # Symlink bash config into CONFIG_HOME
  [ -L "$CONFIG_DIR"/bash ] && rm "$CONFIG_DIR"/bash
  ln -sfv "$CWD"/config/bash "$CONFIG_DIR"/

  # Symlink profile and bashrc file into HOME
  ln -sfv "$CWD"/config/profile "$HOME"/.profile
  ln -sfv "$CWD"/config/bash/bashrc "$HOME"/.bashrc

  # Copy data directory
  if [ "$OSTYPE" = linux* ]; then
    cp -nvr "$CWD"/data-linux/* "$DATA_DIR"/
  fi

  # Clean up
  unset CONFIG_DIR DATA_DIR BACKUP_DIR

### Server environment
else
    # Copy bashrc to home
    echo "Will do: cp $CWD/bash/bashrc $HOME/.bashrc"
    for F in "$CWD"/bash/{bashrc}; do
      DEST="$HOME"/.$file
      mv -i "$F" "$DEST" # don't overwrite without permission
    done

fi

# Clean up
unset CWD DEST F
