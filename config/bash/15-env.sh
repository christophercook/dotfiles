
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

HISTFILE="${XDG_DATA_HOME}/bash_history"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# Define vars for apps which need help supporting XDG dirs
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg
export LESSHISTFILE=- # disable less history
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/config
export VIMINIT=":source $XDG_CONFIG_HOME"/vim/config
