#!/usr/bin/env bash

# If this file is not being sourced, exit now.
[[ "$0" = "${BASH_SOURCE[0]}" ]] && echo "Do not run this script directly." && exit

###########################################
# Install common packages and configuration
###########################################

# Detect debian package manager
if [ "$(uname -s)" = Linux ] && [ -n "$(which apt-get)" ]; then

  # Define the list of required repository packages
  packages=( apt-transport-https ca-certificates curl vim git unzip vlc
            python3-pip openvpn network-manager-openvpn-gnome meld shellcheck )

  # Install packages individually, instead of all together, so that
  # we can check if they are installed and skip if they are installed
  # which reduces output messaging.
  echo "Preparing to install packages"
  for p in "${packages[@]}" ; do
    if [ "$(dpkg -s "$p" 2> /dev/null | grep 'Status: ')" != "Status: install ok installed" ]; then
      sudo apt-get -y install "$p"
    fi
  done

  # Configure gnome app preferences
  if [ -n "$(which gsettings)" ]; then

    # set gnome terminal colors to tango dark scheme
    id=$(sed -e "s/'//g" <<<"$(gsettings get org.gnome.Terminal.ProfilesList default)")
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ use-theme-colors false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ use-theme-transparency false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ background-color 'rgb(46,52,54)'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ foreground-color 'rgb(211,215,207)'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ default-size-columns 120
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ default-size-rows 40
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ audible-bell false

    # set gedit color scheme to Monokai Extended
    gsettings set org.gnome.gedit.preferences.editor scheme 'vsdark'
  fi

fi
