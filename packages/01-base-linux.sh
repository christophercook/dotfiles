#!/usr/bin/env bash

# If this file is not being sourced, exit now.
[[ "$0" = "${BASH_SOURCE[0]}" ]] && echo "Do not run this script directly." && exit

###########################################
# Install common packages and configuration
###########################################

# Detect debian package manager
if [ "$(uname -s)" = Linux ] && [ -n "$(which apt-get)" ]; then

  # Define the list of required repository packages
  packages=( apt-transport-https ca-certificates curl vim git unzip
            python3-pip )

  # Install packages individually, instead of all together, so that
  # we can check if they are installed and skip if they are installed
  # which reduces output messaging.
  echo "Preparing to install packages"
  for p in "${packages[@]}" ; do
    if [ "$(dpkg -s "$p" 2> /dev/null | grep 'Status: ')" != "Status: install ok installed" ]; then
      sudo apt-get -y install "$p"
    fi
  done

fi
