#!/usr/bin/env bash

# If this file is not being sourced, exit now.
[[ "$0" = "${BASH_SOURCE[0]}" ]] && echo "Do not run this script directly." && exit

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /home/chris/Projects/node_modules/tabtab/.completions/serverless.bash ] && . /home/chris/Projects/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /home/chris/Projects/node_modules/tabtab/.completions/sls.bash ] && . /home/chris/Projects/node_modules/tabtab/.completions/sls.bash
