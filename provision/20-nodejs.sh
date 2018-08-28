# Install some global modules
yarn_modules=(
  eslint
  create-react-app
  vue-cli
)
for M in "${yarn_modules[@]}"; do
  [ ! -d $DATA_DIR/yarn/global/node_modules/$M ] && yarn global add "$M"
done
