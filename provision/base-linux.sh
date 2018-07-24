# Install base packages and configuration
if [ "$(uname -s)" = Linux ] && [ -n "$which apt-get" ]; then

  # Define the list of required repository packages
  PACKAGES=( apt-transport-https ca-certificates curl vim git unzip vlc
            python-pip openvpn network-manager-openvpn-gnome )

  # Install packages individually, instead of all together, so that
  # we can check if they are installed and skip if they are installed
  # which reduces output messaging.
  echo "Preparing to install packages"
  for p in "${PACKAGES[@]}" ; do
    if [ "$(dpkg -s ${p} 2> /dev/null | grep 'Status: ')" != "Status: install ok installed" ]; then
      sudo apt-get -y install ${p}
    fi
  done

  # Configure gnome app preferences
  if [ -n "$(which gsettings)" ]; then

    # set gnome terminal colors to tango dark scheme
    profileId=$(sed -e "s/'//g" <<<$(gsettings get org.gnome.Terminal.ProfilesList default))
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileId/ use-theme-colors false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileId/ use-theme-transparency false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileId/ background-color 'rgb(46,52,54)'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileId/ foreground-color 'rgb(211,215,207)'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileId/ default-size-columns 120
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileId/ default-size-rows 40
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileId/ audible-bell false

    # set gedit color scheme to Monokai Extended
    gsettings set org.gnome.gedit.preferences.editor scheme 'vsdark'
  fi

fi
