
# Copy data directories
for F in "$CWD"/{data,data-"$OS"}; do
  [ -d "$F" ] && cp -nvr "$F"/* "$DATA_DIR"/
done
