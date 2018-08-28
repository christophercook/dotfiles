if [ "$(uname -s)" = Linux ] && [ -n "$which apt-get" ]; then

  # Add Google Chrome repo
  if [ ! -e /etc/apt/sources.list.d/google-chrome.list ]; then
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt-get update -qq
  fi

  # Install
  if [ -z "$(which google-chrome)" ]; then
    sudo apt-get install -y google-chrome-stable
  fi

fi
