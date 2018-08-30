#!/usr/bin/env bash

# If this file is not being sourced, exit now.
[[ "$0" = "${BASH_SOURCE[0]}" ]] && echo "Do not run this script directly." && exit

# Only add one since they are almost certainly the same
if [ "$(which npm)" ]; then
  PATH="$PATH:$(npm -g bin 2>/dev/null)"
elif [ -n "$(which yarn)" ]; then
  PATH="$PATH:$(yarn global bin)"
fi
