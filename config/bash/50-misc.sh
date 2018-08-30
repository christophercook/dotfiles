#!/usr/bin/env bash

# If this file is not being sourced, exit now.
[[ "$0" = "${BASH_SOURCE[0]}" ]] && echo "Do not run this script directly." && exit

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
#if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
#    debian_chroot=$(cat /etc/debian_chroot)
#fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  dc="${XDG_CONFIG_HOME-$HOME/.config}"/dircolors
  if [ -r "$dc" ]; then
    eval "$(dircolors -b "$dc")"
  else
    eval "$(dircolors -b)"
  fi
  unset dc
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
