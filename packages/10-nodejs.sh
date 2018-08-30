#!/usr/bin/env bash

# If this file is not being sourced, exit now.
[[ "$0" = "${BASH_SOURCE[0]}" ]] && echo "Do not run this script directly." && exit

#######################
# Prepare to install Node.js
#######################

# Check for NPM_CONFIG_USERCONFIG and initialize if not set
[ -z "$NPM_CONFIG_USERCONFIG" ] && NPM_CONFIG_USERCONFIG="$CONFIG_DIR"/npm
mkdir -p "$CONFIG_DIR"/npm

# Set up config to support XDG DIRS before installing
if [ ! -f "$CONFIG_DIR"/npm/config ]; then
cat << EOF > "$CONFIG_DIR"/npm/config
cache="$CACHE_DIR/npm"
tmp="$RUNTIME_DIR/npm"
prefix="$DATA_DIR/npm"
EOF
fi
