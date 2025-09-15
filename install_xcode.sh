#!/bin/bash
 

echo "Starting installation of Xcode 15.1, VS Code, Flutter, and Cocoapods..."

pause() {
  echo ""
  read -p "Press Enter to continue to the next step..."
}


# Install Oh My Zsh
# if [ ! -d "$HOME/.oh-my-zsh" ]; then
#   echo "Installing Oh My Zsh..."
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# else
#   echo "Oh My Zsh is already installed, skipping."
# fi
# pause

touch  ~/.zshenv 
# Install Homebrew
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zshenv
  echo 'eval "$(/usr/local/bin/brew shellenv)"' >>~/.zshenv
  eval "$(/usr/local/bin/brew shellenv)" 
  source ~/.zshenv 
else
  echo "Homebrew is already installed, skipping."
fi

if command -v brew &>/dev/null; then
  echo "brew Version: $(brew -v)"
else
  echo "brew is not installed."
fi

pause


if [ ! -f "xcode.zip" ]; then
  echo "Downloading Xcode 16.2"
  open https://drive.google.com/file/d/1nuu-OCWyJ_XxDmoxdo510uLX-tgP30Ka/view?usp=sharing
else
  echo "xcode.zip already exists, skipping download."
fi
pause


brew install ffsend
ffsend --help


source ~/.zshenv 
# Display System Information
echo "System Information:"
echo "Operating System: $(uname -s)"
echo "Kernel Version: $(uname -r)"
echo "Architecture: $(uname -m)"
echo "CPU Information: $(sysctl -n machdep.cpu.brand_string)"
echo "Total Memory: $(($(sysctl -n hw.memsize) / 1024 / 1024 / 1024)) GB"
pause


echo "Installation completed! Please verify if all tools have been correctly installed."
