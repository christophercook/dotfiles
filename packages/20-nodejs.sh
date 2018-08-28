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

# Install some global modules
yarn_modules=(
  eslint
  create-react-app
  vue-cli
)
for M in "${yarn_modules[@]}"; do
  [ ! -d $DATA_DIR/yarn/global/node_modules/$M ] && yarn global add "$M"
done
