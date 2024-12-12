#!/bin/bash

# 检查是否为管理员权限
if [ "$EUID" -ne 0 ]; then
  echo "请使用管理员权限运行脚本 (sudo)。"
  exit
fi

echo "开始安装 Xcode 15.1、VS Code、Flutter 和 Cocoapods..."

# 更新系统和工具
echo "更新系统..."
softwareupdate --install --all

# 安装 Oh My Zsh
echo "安装 Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 安装 Homebrew
echo "安装 Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# 安装必要的依赖
echo "安装开发工具..."
brew install wget git rbenv ruby-build

# 安装 Xcode 15.1 (需手动同意许可协议)
echo "安装 Xcode 15.1..."
xcode-select --install
sudo xcodebuild -license accept

# 安装 VS Code
echo "安装 VS Code..."
wget -O vscode.zip https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal
unzip vscode.zip -d /Applications/
rm vscode.zip

# 安装 Flutter
echo "安装 Flutter..."
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.3.10-stable.zip
unzip flutter_macos_3.3.10-stable.zip -d ~/Developer/
rm flutter_macos_3.3.10-stable.zip
export PATH="$PATH:$HOME/Developer/flutter/bin"

# 验证 Flutter 安装
echo "验证 Flutter 安装..."
flutter doctor

# 配置 Ruby 和安装 Cocoapods
echo "配置 Ruby 和安装 Cocoapods..."
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
source ~/.zshrc
rbenv install 3.2.6
rbenv global 3.2.6
ruby -v

gem install cocoapods

# 完成安装
echo "安装完成！请确认各项工具是否正确安装。"
