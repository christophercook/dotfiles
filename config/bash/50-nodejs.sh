# Only add one since they are almost certainly the same
if [ $(which npm) ]; then
  PATH="$PATH:$(npm -g bin 2>/dev/null)"
elif [ -n "$(which yarn)"]; then
  PATH="$PATH:$(yarn global bin)"
fi
