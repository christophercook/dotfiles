################################
# Set up VIM to support XDG Dirs
################################

# Create VIM dirs
mkdir -p "$CONFIG_DIR"/vim
mkdir -p "$CACHE_DIR"/vim/{swap,backup,undo}
mkdir -p "$RUNTIME_DIR"/vim

# VIM configuration to support XDG DIRS
if [ ! -f "$CONFIG_DIR"/vim/config ]; then
  echo "creating $CONFIG_DIR/vim/config"
cat << EOF > "$CONFIG_DIR"/vim/config
set directory=$(tildePath $CACHE_DIR/vim/swap)
set backupdir=$(tildePath $CACHE_DIR/vim/backup)
set undodir=$(tildePath $CACHE_DIR/vim/undo)
set viminfo+=n$(tildePath $CACHE_DIR/vim/viminfo)
set runtimepath=$RUNTIME_DIR/vim
EOF
fi

# TODO: Clean up old VIM files

############
# Set up Git
############

# Copy config rather than symlink
cp -nvr "$CWD"/config/git "$CONFIG_DIR"/

# If a .gitconfig already exists in the $HOME directory
if [ -f ~/.gitconfig ]; then
  FULL_NAME="$(git config -f $HOME/.gitconfig --get user.name)"
  EMAIL_ADDRESS="$(git config -f $HOME/.gitconfig --get user.email)"
  [ -z "$FULL_NAME" ] && read -p "Your Git committer name? " FULL_NAME
  [ -z "$EMAIL_ADDRESS" ] && read -p "Your Git committer email address? " EMAIL_ADDRESS

  # Move the gitconfig out of the way
  mv -v ~/.gitconfig ~/gitconfig.bak
fi

# Update Git configuration
git config -f "$CONFIG_DIR"/git/config core.excludesfile $(tildePath "$CONFIG_DIR"/git/excludes)
[ -n "$FULL_NAME" ] && git config -f "$CONFIG_DIR"/git/config user.name "$FULL_NAME"
[ -n "$EMAIL_ADDRESS" ] && git config -f "$CONFIG_DIR"/git/config user.email "$EMAIL_ADDRESS"
if [ -n $(which meld) ]; then
  git config -f "$CONFIG_DIR"/git/config diff.tool meld
  git config -f "$CONFIG_DIR"/git/config merge.tool meld
elif [ -n $(which diffmerge) ]; then
  git config -f "$CONFIG_DIR"/git/config diff.tool diffmerge
  git config -f "$CONFIG_DIR"/git/config merge.tool diffmerge
  git config -f "$CONFIG_DIR"/git/config difftool.diffmerge.cmd "diffmerge \$LOCAL \$REMOTE"
  git config -f "$CONFIG_DIR"/git/config merge.diffmerge.cmd "diffmerge \$LOCAL \$MERGED \$REMOTE --output \$MERGED"
elif [ -x /Applications/DiffMerge.appContents/MacOS/diffmerge ]; then
  git config -f "$CONFIG_DIR"/git/config diff.tool diffmerge
  git config -f "$CONFIG_DIR"/git/config merge.tool diffmerge
  git config -f "$CONFIG_DIR"/git/config difftool.diffmerge.cmd "/Applications/DiffMerge.appContents/MacOS/diffmerge \$LOCAL \$REMOTE"
  git config -f "$CONFIG_DIR"/git/config merge.diffmerge.cmd "/Applications/DiffMerge.appContents/diffmerge \$LOCAL \$MERGED \$REMOTE --output \$MERGED"
fi
