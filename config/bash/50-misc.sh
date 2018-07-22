# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
#if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
#    debian_chroot=$(cat /etc/debian_chroot)
#fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  DCF="${XDG_CONFIG_HOME-$HOME/.config}"/dircolors
  test -r "$DCF" && eval $(dircolors -b "$DCF") || eval "$(dircolors -b)"
  unset DCF
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
