
function tildePath {
  echo $(echo $1 | sed "s|^$HOME|~|")
}

# Create VIM dirs
mkdir -p "$CONFIG_DIR"/vim
mkdir -p "$CACHE_DIR"/vim/{swap,backup,undo}
mkdir -p "$RUNTIME_DIR"/vim

# VIM configuration to support XDG DIRS
if [ ! -f "$CONFIG_DIR"/vim/config ]; then
cat << EOF > "$CONFIG_DIR"/vim/config
set directory=$(tildePath $CACHE_DIR/vim/swap)
set backupdir=$(tildePath $CACHE_DIR/vim/backup)
set undodir=$(tildePath $CACHE_DIR/vim/undo)
set viminfo+=n$(tildePath $CACHE_DIR/vim/viminfo)
set runtimepath=$RUNTIME_DIR/vim
EOF
fi

echo "Copying data directories"
for F in "$CWD"/{data,data-"$OS"}; do
  [ -d "$F" ] && cp -nvr "$F"/* "$DATA_DIR"/
done

# Copy config directories which must differ from repo version
echo "Copying config directories"
cp -nvr "$CWD"/config/git "$CONFIG_DIR"/

# Back up and relocate replaced configs
echo "Backing up configuration files"
[ -f ~/.gitconfig ] && mv ~/.gitconfig ~/.gitconfig.bak

# Finish Git configuration
echo "Finishing Git configuration"
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
