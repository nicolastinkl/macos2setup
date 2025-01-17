#!/bin/bash
 

echo "Starting installation of Xcode 15.1, VS Code, Flutter, and Cocoapods..."

pause() {
  echo ""
  read -p "Press Enter to continue to the next step..."
}

# Install Homebrew
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zshrc
  echo 'eval "$(/usr/local/bin/brew shellenv)"' >>~/.zshrc
  eval "$(/usr/local/bin/brew shellenv)" 
  source ~/.zshrc 
else
  echo "Homebrew is already installed, skipping."
fi

if command -v brew &>/dev/null; then
  echo "brew Version: $(brew -v)"
else
  echo "brew is not installed."
fi

pause

# Install Required Dependencies
echo "Installing development tools..."
brew install wget git rbenv ruby-build || echo "Required dependencies are already installed, skipping."
pause

# Install VS Code
# Install VS Code
if [ ! -d "/Applications/Visual Studio Code.app" ]; then
  echo "Installing VS Code..."
  if [ ! -f "vscode.zip" ]; then
    echo "Downloading VS Code..."
    wget -O vscode.zip "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal"
  else
    echo "vscode.zip already exists, skipping download."
  fi

  # Verify the integrity of the downloaded file
  if [ -f "vscode.zip" ]; then
    FILE_SIZE=$(stat -c%s "vscode.zip")
    MIN_SIZE=$((10 * 1024 * 1024)) # 10MB in bytes

    if [ "$FILE_SIZE" -lt "$MIN_SIZE" ]; then
      echo "File size is too small ($FILE_SIZE bytes). Download might have failed."
      echo "Deleting corrupted vscode.zip and retrying download..."
      rm -f vscode.zip
      wget -O vscode.zip "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal"
    else
      echo "File size is valid ($FILE_SIZE bytes). Proceeding to unzip."
    fi
  else
    echo "vscode.zip not found. Download failed."
    exit 1
  fi

  # Attempt to unzip the file
  if ! unzip vscode.zip -d /Applications/; then
    echo "Unzipping failed! The file might be corrupted."
    rm -f vscode.zip
  
  fi

  # Clean up
  rm vscode.zip
else
  echo "VS Code is already installed, skipping."
fi
pause

# Install Flutter
if [ ! -d "$HOME/Developer/flutter" ]; then
  echo "Installing Flutter..."
  wget https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.27.1-stable.zip
  unzip flutter_macos_3.27.1-stable.zip -d ~/Developer/
  rm flutter_macos_3.27.1-stable.zip
  export PATH="$PATH:$HOME/Developer/flutter/bin"

  # Verify Flutter Installation
  echo "Verifying Flutter installation..."
  flutter doctor
  flutter --disable-analytics
else
  echo "Flutter is already installed, skipping."

  if ! command -v flutter &>/dev/null; then
    export PATH="$PATH:$HOME/Developer/flutter/bin"
    source ~/.zshrc
  fi
fi
pause


# Install Oh My Zsh
# if [ ! -d "$HOME/.oh-my-zsh" ]; then
#   echo "Installing Oh My Zsh..."
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# else
#   echo "Oh My Zsh is already installed, skipping."
# fi
# pause
 

# Configure Ruby and Install Cocoapods
if ! command -v rbenv &>/dev/null; then
  echo "Configuring Ruby and installing Cocoapods..."
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >>~/.zshrc
  echo 'eval "$(rbenv init -)"' >>~/.zshrc
  source ~/.zshrc
 
else
  echo "Ruby and Cocoapods are already installed, skipping."
fi
pause

if command -v pod &>/dev/null; then
  echo "Cocoapods Version: $(pod --version)"
else
  echo "Cocoapods is not installed."
  # rbenv install 3.2.6
  # rbenv global 3.2.6
  RUBY_VERSION="3.1.0"  # Specify the desired Ruby version

  echo "Installing and setting Ruby version to $RUBY_VERSION..."
  rbenv install -s $RUBY_VERSION  # Install the version if not already installed
  rbenv global $RUBY_VERSION     # Set the version globally
  source ~/.zshrc                 # Reload the shell configuration
  
  rbenv versions
  rbenv which ruby 

  ruby -v 
  # sudo gem install cocoapods
   # Install Cocoapods
  if ! gem list cocoapods -i; then
    echo "Installing Cocoapods..."
    gem install cocoapods
    rbenv rehash                  # Ensure rbenv recognizes new executables
  else
    echo "Cocoapods is already installed."
  fi

  pod --version

fi

source ~/.zshrc 
 
# Display System Information
echo "System Information:"
echo "Operating System: $(uname -s)"
echo "Kernel Version: $(uname -r)"
echo "Architecture: $(uname -m)"
echo "CPU Information: $(sysctl -n machdep.cpu.brand_string)"
echo "Total Memory: $(($(sysctl -n hw.memsize) / 1024 / 1024 / 1024)) GB"
pause

# Check and output the version information of all installed tools
echo "Checking installed tool versions:"
if command -v wget &>/dev/null; then
  echo "wget Version: $(wget -V | head -n 1)"
else
  echo "wget is not installed."
fi
if command -v pod &>/dev/null; then
  echo "Cocoapods Version: $(pod --version)"
else
  echo "Cocoapods is not installed."
fi
if command -v flutter &>/dev/null; then
  echo "Flutter Version: $(flutter --version)"
else
  echo "Flutter is not installed."
fi
if command -v rbenv &>/dev/null; then
  echo "rbenv Version: $(rbenv -v)"
else
  echo "rbenv is not installed."
fi
if command -v ruby &>/dev/null; then
  echo "Ruby Version: $(ruby -v)"
else
  echo "Ruby is not installed."
fi

echo "Installation completed! Please verify if all tools have been correctly installed."