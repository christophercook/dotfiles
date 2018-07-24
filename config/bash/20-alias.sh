# enable color support of ls and also add handy aliases

if [ "$COLOR_TERM" = yes ]; then
  # ls colors
  if [[ "$OSTYPE" = darwin* ]]; then
    export LSCOLORS='ExGxFxDxCxDxDxhbhdacEc'
    CLICOLOR=yes
  else
    eval "$(dircolors -b $XDG_CONFIG_HOME/bash/dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
  fi

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  if [ -n "$(which ip)" ]; then
    alias ip='ip -c'
  fi
fi

alias ll='ls -Al'
alias la='ls -A'
alias l='ls -CF'

alias ..='cd ..'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
