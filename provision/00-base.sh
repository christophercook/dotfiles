
# Link configs into CONFIG_DIR
for F in "$CWD"/config/{vim,}; do
  ln -sfv "$CWD/config/$F" "$CONFIG_DIR"
done

# Create VIM cache dirs because it can't on its own
mkdir -p "$XDG_CACHE_HOME"/vim/{swap,backup,undo}

# Copy data directories
for F in "$CWD"/{data,data-"$OS"}; do
  [ -d "$F" ] && cp -nvr "$F"/* "$DATA_DIR"/
done

# Copy configs which must be manually changed
for F in "$CWD"/config/{git,}; do
  cp -nvr "$CWD/config/$F" "$CONFIG_DIR"/
done

# TODO: Prompt for git config values
