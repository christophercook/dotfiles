#!/usr/bin/env bash

# This script will install packages and set up configuration
# for certain apps. It will attempt to help apps locate their
# configuration in XDG compatible paths to minimize dotfiles in $HOME.
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

# If this file is being sourced, exit now.
[[ "$1" == "source" ]] && return


if [[ "$1" == "-h" || "$1" == "--help" ]]; then cat <<HELP

Usage: $(basename "$0")

HELP
exit; fi

function __provision_cleanup {
  unset CWD OS CONFIG_DIR DATA_DIR F
}
trap __provision_cleanup EXIT

# Get script directory
# realpath is expected to exist on modern Linux and macOS
if [[ -x "$(which realpath)" ]] && [[ -n "$BASH_SOURCE[0]" ]]; then
  CWD=$(dirname $(realpath "$BASH_SOURCE[0]"))
else
  CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
fi

[[ "$OSTYPE" = darwin* ]] && OS=macos
[[ "$OSTYPE" = linux* ]]  && OS=linux

if [[ -n "$DESKTOP_SESSION" || "$OS" = macos ]]; then

  # Define dirs
  if [[ "$OS" = macos ]]; then
    CONFIG_DIR="${XDG_CONFIG_HOME-$HOME/Library/Application Support}"
    DATA_DIR="${XDG_DATA_HOME-$HOME/Library/Application Support}"
  else
    CONFIG_DIR="${XDG_CONFIG_HOME-$HOME/.config}"
    DATA_DIR="${XDG_DATA_HOME-$HOME/.local/share}"
  fi

  # Run base provisioning scripts
  export CONFIG_DIR DATA_DIR CWD OS
  for F in "$CWD"/provision/{00-base,01-base-"$OS"}.sh; do
    [ -f "$F" ] && source "$F"
  done

fi
