#!/usr/bin/env bash

# If this file is not being sourced, exit now.
[[ "$0" = "${BASH_SOURCE[0]}" ]] && echo "Do not run this script directly." && exit

############################################
# Install desktop packages and configuration
############################################

# Detect debian package manager
if [ "$(uname -s)" = Linux ] && [ -n "$(which apt-get)" ]; then

  # Detect Ubuntu Desktop
  if [ "$(dpkg-query --show --showformat='${Status}\n' ubuntu-desktop 2> /dev/null)" = "install ok installed" ]; then

    # Define official packages
    packages=( vlc openvpn network-manager-openvpn-gnome meld shellcheck )

    # Define 3rd party repositories and packages
    arch=amd64
    repoNames=()
    repoURLs=()
    keys=()
    keyURLs=()
    packageNames=()

    # Brave Browser
    repoNames+=("brave-browser-release")
    repoURLs+=("https://brave-browser-apt-release.s3.brave.com/")
    keys+=("brave-browser-archive-keyring.gpg")
    keyURLs+=("https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg")
    packageNames+=("brave-browser")

    # Chrome Browser
    repoNames+=("google-chrome")
    repoURLs+=("http://dl.google.com/linux/chrome/deb/")
    keys+=("google-chrome-archive-keyring.gpg")
    keyURLs+=("https://dl.google.com/linux/linux_signing_key.pub")
    packageNames+=("google-chrome-stable")

    # Microsoft VSCode
    repoNames+=("microsoft-vscode")
    repoURLs+=("https://packages.microsoft.com/repos/vscode")
    keys+=("microsoft-vscode-archive-keyring.gpg")
    keyURLs+=("https://packages.microsoft.com/keys/microsoft.asc")
    packageNames+=("code")

    # Add signing keys and repositories
    for i in "${!repoNames[@]}" ; do
      if [ ! -e "/etc/apt/sources.list.d/${repoNames[$i]}.list" ]; then
        curl -fsSL "${keyURLs[$i]}" | sudo gpg --yes --dearmor -o /usr/share/keyrings/"${keys[$i]}"
        echo "deb [signed-by=/usr/share/keyrings/${keys[$i]} arch=$arch] ${repoURLs[$i]} stable main" | sudo tee "/etc/apt/sources.list.d/${repoNames[$i]}.list"
      fi
    done

    # Update sources
    sudo apt-get update -qq

    # Combine 3rd party packages with official packages
    allPackages=("${packages[@]}" "${packageNames[@]}")

    # Install packages individually, instead of all together, so that
    # we can check if they are installed and skip if they are installed
    # which reduces output messaging.
    echo "Preparing to install packages"
    for p in "${allPackages[@]}" ; do
      if [ "$(dpkg -s "$p" 2> /dev/null | grep 'Status: ')" != "Status: install ok installed" ]; then
        sudo apt-get -y install "$p"
      fi
    done

    # Configure gnome app preferences
    if [ -n "$(which gsettings)" ]; then

      # set gnome terminal configuration
      id="$(gsettings get org.gnome.Terminal.ProfilesList default)"
      id="${id//\'/}"
      gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ use-theme-colors false
      gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ use-theme-transparency false
      gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ background-color 'rgb(0,0,0)'
      gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ foreground-color 'rgb(255,255,255)'
      gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ default-size-columns 120
      gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ default-size-rows 40
      gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ audible-bell false

      # set gedit color scheme to Monokai Extended
      gsettings set org.gnome.gedit.preferences.editor scheme 'vsdark'
    fi

    # Configure VSCode
    if [ -n "$(which code)" ]; then

      # Copy config files
      #cp -vr "$CWD"/config/Code "$CONFIG_DIR"/

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

      # Install extensions
      for e in "${all_extensions[@]}"; do
        code --force --install-extension "$e"
      done
    fi

  fi
fi
