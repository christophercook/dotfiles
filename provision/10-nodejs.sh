# Check for NPM_CONFIG_USERCONFIG and initialize if not set
[ -z "$NPM_CONFIG_USERCONFIG" ] && NPM_CONFIG_USERCONFIG="$CONFIG_DIR"/npm
mkdir -p "$CONFIG_DIR"/npm

# Set up config to support XDG DIRS before installing
[ -z "$(npm config get cache)" ] && npm config set cache "$CACHE_DIR"/npm && mkdir -p "$CACHE_DIR"/npm
[ -z "$(npm config get tmp)" ] && npm config set tmp "$RUNTIME_DIR"/npm && mkdir -p "$RUNTIME_DIR"/npm
[ -z "$(npm config get prefix)" ] && npm config set prefix "$DATA_DIR"/npm && mkdir -p "$DATA_DIR"/npm

# Set up author info using Git config
if [ -z "$(npm config get init-author-name)" ]; then
  FULL_NAME="$(git config --get user.name)"
  [ -n "$FULL_NAME" ] && npm config set init-author-name "$FULL_NAME"
fi
if [ -z "$(npm config get init-author-email)" ]; then
  EMAIL_ADDRESS="$(git config --get user.email)"
  [ -n "$EMAIL_ADDRESS" ] && npm config set init-author-email "$EMAIL_ADDRESS"
fi

# Other configs?
npm config set optional false
#npm config init-module "$CONFIG_DIR"/npm/npm-init.js
#npm config set init-author-url ""
#npm config set init-license "ISC"
