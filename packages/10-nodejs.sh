#!/usr/bin/env bash

# If this file is not being sourced, exit now.
[[ "$0" = "${BASH_SOURCE[0]}" ]] && echo "Do not run this script directly." && exit

###########################
# Install Node.js using NVM
###########################

export NVM_DIR="$CONFIG_DIR/nvm"

# Clone NVM repo
if [ ! -d "$NVM_DIR" ]; then
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
fi

# Install latest stable NVM
git -C "$NVM_DIR" checkout "$(git -C "$NVM_DIR" describe --abbrev=0 --tags --match "v[0-9]*" "$(git -C "$NVM_DIR" rev-list --tags --max-count=1)")"
# shellcheck disable=SC1091
source "$NVM_DIR"/nvm.sh

# Verify that NVM is properly loaded
[ -z "$(type -t nvm)" ] && echo "NVM is not found" && exit

# Check for NPM_CONFIG_USERCONFIG and initialize if not set
[ -z "$NPM_CONFIG_USERCONFIG" ] && NPM_CONFIG_USERCONFIG="$CONFIG_DIR"/npm/config

# Set up NPM config to support XDG DIRS before installing
if [ ! -f "$CONFIG_DIR"/npm/config ]; then
  mkdir -p "$CONFIG_DIR"/npm
  cat << EOF > "$CONFIG_DIR"/npm/config
cache="$CACHE_DIR/npm"
tmp="$RUNTIME_DIR/npm"
EOF
fi

# Install Node.js
nvm install node

# Install Yarn
npm install --global yarn

# Set up author info using Git config
if [ -n "$(which git)" ]; then
  if [ -z "$(npm config get init-author-name)" ]; then
    name="$(git config --get user.name)"
    [ -n "$name" ] && npm config set init-author-name "$name"
  fi
  if [ -z "$(npm config get init-author-email)" ]; then
    email="$(git config --get user.email)"
    [ -n "$email" ] && npm config set init-author-email "$email"
  fi
fi

# Other configs?
npm config set optional false
#npm config init-module "$CONFIG_DIR"/npm/npm-init.js
#npm config set init-author-url ""
#npm config set init-license "ISC"

# Install some global modules
yarn_modules=(
  create-react-app
  eslint
  vue-cli
)
for m in "${yarn_modules[@]}"; do
  if ! yarn global list 2>/dev/null | grep -q "info \"$m@"; then
    yarn global add --ignore-optional "$m"
  fi
done
