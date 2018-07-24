# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  [ "$OSTYPE" = darwin* ] && alias ls='ls -G' || alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  if [ -n "$(which ip)" ]; then
    alias ip='ip -c'
  fi
fi

alias ll='ls -AlF'
alias la='ls -A'
alias l='ls -CF'

alias ..='cd ..'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
