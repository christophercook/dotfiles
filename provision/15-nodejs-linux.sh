if [ "$(uname -s)" = Linux ] && [ -n "$which apt-get" ]; then

  # Run install script to add repo
  if [ ! -e /etc/apt/sources.list.d/nodesource.list ]; then
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    NEW_SOURCES=yes
  fi

  # Add Yarn repo
  if [ ! -e /etc/apt/sources.list.d/yarn.list ]; then
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    NEW_SOURCES=yes
  fi

  # Install node and related packages
  [ "$NEW_SOURCES" = yes ] && sudo apt-get update -qq && unset NEW_SOURCES
  [ -z "$(which node)" ] && sudo apt-get install -y nodejs
  [ -z "$(which npm)" ] && sudo apt-get install -y npm
  [ -z "$(which yarn)" ] && sudo apt-get install -y yarn

fi
