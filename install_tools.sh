#!/bin/bash

# Check for Administrator Privileges
# if [ "$EUID" -ne 0 ]; then
#   echo "Please run the script with administrator privileges (sudo)."
#   exit
# fi

echo "Starting installation of Xcode 15.1, VS Code, Flutter, and Cocoapods..."

# Update System and Tools
echo "Updating system..."
# softwareupdate --install --all

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh is already installed, skipping."
fi

# Install Homebrew
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew is already installed, skipping."
fi

# Install Required Dependencies
echo "Installing development tools..."
brew install wget git rbenv ruby-build || echo "Required dependencies are already installed, skipping."

# Install Xcode 15.1 (requires manual license agreement)
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode 15.1..."
  xcode-select --install
  sudo xcodebuild -license accept
else
  echo "Xcode is already installed, skipping."
fi

# Install VS Code
if [ ! -d "/Applications/Visual Studio Code.app" ]; then
  echo "Installing VS Code..."
  wget -O vscode.zip https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal
  unzip vscode.zip -d /Applications/
  rm vscode.zip
else
  echo "VS Code is already installed, skipping."
fi

# Install Flutter
if [ ! -d "$HOME/Developer/flutter" ]; then
  echo "Installing Flutter..."
  wget https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.27.1-stable.zip
  unzip flutter_macos_3.27.1-stable.zip -d ~/Developer/
  rm flutter_macos_3.27.1-stable.zip
  export PATH="$PATH:$HOME/Developer/flutter/bin"
else
  echo "Flutter is already installed, skipping."
fi

# Verify Flutter Installation
echo "Verifying Flutter installation..."
flutter doctor

# Configure Ruby and Install Cocoapods
if ! command -v rbenv &>/dev/null; then
  echo "Configuring Ruby and installing Cocoapods..."
  echo 'eval "$(rbenv init -)"' >>~/.zshrc
  source ~/.zshrc
  rbenv install 3.2.6
  rbenv global 3.2.6
  ruby -v
  gem install cocoapods
else
  echo "Ruby and Cocoapods are already installed, skipping."
fi

# Completion of installation

# Check and output the version information of all tools


# Display System Information
echo "System Information:"
echo "Operating System: $(uname -s)"
echo "Kernel Version: $(uname -r)"
echo "Architecture: $(uname -m)"
echo "CPU Information: $(sysctl -n machdep.cpu.brand_string)"
echo "Total Memory: $(($(sysctl -n hw.memsize) / 1024 / 1024 / 1024)) GB"


# Check and output the version information of all installed tools
echo "Checking installed tool versions:"
echo ""
if command -v wget &>/dev/null; then
  echo "wget Version: $(wget -V | head -n 1)"
else
  echo "wget is not installed."
fi
echo ""
if command -v pod &>/dev/null; then
  echo "Cocoapods Version: $(pod --version)"
else
  echo "Cocoapods is not installed."
fi
echo ""
if command -v flutter &>/dev/null; then
  echo "Flutter Version: $(flutter --version)"
else
  echo "Flutter is not installed."
fi
echo ""
if command -v rbenv &>/dev/null; then
  echo "rbenv Version: $(rbenv -v)"
else
  echo "rbenv is not installed."
fi
echo ""
if command -v ruby &>/dev/null; then
  echo "Ruby Version: $(ruby -v)"
else
  echo "Ruby is not installed."
fi


echo "Installation completed! Please verify if all tools have been correctly installed."