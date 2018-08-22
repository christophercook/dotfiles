# Install Microsoft vscode repo
if [ ! -e /etc/apt/sources.list.d/vscode.list ]; then
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt-get update -qq
fi

# Install
[ -z "$(which code)" ] && sudo apt-get install -y code

# Get installed extensions (lowercase)
declare -a installed_extensions
IFS=$'\r\n' GLOBIGNORE='*' command eval 'installed_extensions=($(code --list-extensions | tr [:upper:] [:lower:]))'

# Define extensions to be installed
declare -a all_extensions
all_extensions=(
  mikestead.dotenv
  dbaeumer.vscode-eslint
  sidneys1.gitconfig
  zignd.html-css-class-completion
  davidanson.vscode-markdownlint
  2gua.rainbow-brackets
  editorconfig.editorconfig
)

# Install extensions that are not already installed
for E in ${all_extensions[@]}; do
  if [[ ! " ${installed_extensions[@]} " =~ " ${E} " ]]; then
    code --install-extension "$E"
  fi
done
