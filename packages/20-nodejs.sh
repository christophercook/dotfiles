#!/usr/bin/env bash

# If this file is not being sourced, exit now.
[[ "$0" = "${BASH_SOURCE[0]}" ]] && echo "Do not run this script directly." && exit

###########################################################
# Finalize Node.js configuration and install global modules
###########################################################

# Set up author info using Git config
if [ -z "$(npm config get init-author-name)" ]; then
  name="$(git config --get user.name)"
  [ -n "$name" ] && npm config set init-author-name "$name"
fi
if [ -z "$(npm config get init-author-email)" ]; then
  email="$(git config --get user.email)"
  [ -n "$email" ] && npm config set init-author-email "$email"
fi

# Other configs?
npm config set optional false
#npm config init-module "$CONFIG_DIR"/npm/npm-init.js
#npm config set init-author-url ""
#npm config set init-license "ISC"

# Install some global modules
yarn_modules=(
  eslint
  create-react-app
  vue-cli
)
for m in "${yarn_modules[@]}"; do
  if ! yarn global list 2>/dev/null | grep -q "info \"$m@"; then
    yarn global add --ignore-optional "$m"
  fi
done
