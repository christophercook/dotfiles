#!/usr/bin/env bash

# If this file is not being sourced, exit now.
#[[ "$0" = "${BASH_SOURCE[0]}" ]] && echo "Do not run this script directly." && exit

############################
# Install Visual Studio Code
############################

# Detect debian package manager
if [ "$(uname -s)" = Linux ] && [ -n "$(which apt-get)" ]; then

  # Install Microsoft vscode repo
  if [ ! -e /etc/apt/sources.list.d/vscode.list ]; then
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get update -qq
  fi

  # Install
  if [ -z "$(which code)" ]; then
    sudo apt-get install -y code
    cp -vr "$CWD"/config/Code "$CONFIG_DIR"/
  fi

fi

if [ -n "$(which code)" ]; then
  # Get installed extensions (lowercase)
  declare -a installed_extensions
  IFS=$'\r\n' GLOBIGNORE='*' command eval "installed_extensions=($(code --list-extensions | tr "[:upper:]" "[:lower:]"))"

  # Define extensions to be installed
  declare -a all_extensions
  all_extensions=(
    2gua.rainbow-brackets
    EditorConfig.EditorConfig
    Zignd.html-css-class-completion
    christian-kohler.path-intellisense
    DavidAnson.vscode-markdownlint
    dbaeumer.vscode-eslint
    mikestead.dotenv
    sidneys1.gitconfig
    timonwong.shellcheck
  )

  # Install extensions that are not already installed
  for e in "${all_extensions[@]}"; do
    ext=$(echo "$e" | tr "[:upper:]" "[:lower:]")
    if [[ ! " ${installed_extensions[*]} " =~ $ext ]]; then
      code --install-extension "$E"
    fi
  done
fi
