#!/usr/bin/env bash

# If this file is not being sourced, exit now.
[[ "$0" = "${BASH_SOURCE[0]}" ]] && echo "Do not run this script directly." && exit

# Config vars for NVM and NPM
export NVM_DIR="$XDG_CONFIG_HOME"/nvm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/config

# Load NVM
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

# Only add one since they are almost certainly the same
if [ "$(which npm)" ]; then
  PATH="$PATH:$(npm -g bin 2>/dev/null)"
elif [ -n "$(which yarn)" ]; then
  PATH="$PATH:$(yarn global bin)"
fi
