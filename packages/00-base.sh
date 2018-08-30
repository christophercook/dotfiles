#!/usr/bin/env bash

# If this file is not being sourced, exit now.
[[ "$0" = "${BASH_SOURCE[0]}" ]] && echo "Do not run this script directly." && exit

# Copy data directories
for d in "$CWD"/{data,data-"$OS"}; do
  [ -d "$d" ] && cp -nvr "$d"/* "$DATA_DIR"/
done
