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
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "安装 Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh 已安装，跳过。"
fi

# 安装 Homebrew
if ! command -v brew &>/dev/null; then
  echo "安装 Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew 已安装，跳过。"
fi

# 安装必要的依赖
echo "安装开发工具..."
brew install wget git rbenv ruby-build || echo "必要依赖已安装，跳过。"

# 安装 Xcode 15.1 (需手动同意许可协议)
if ! xcode-select -p &>/dev/null; then
  echo "安装 Xcode 15.1..."
  xcode-select --install
  sudo xcodebuild -license accept
else
  echo "Xcode 已安装，跳过。"
fi

# 安装 VS Code
if [ ! -d "/Applications/Visual Studio Code.app" ]; then
  echo "安装 VS Code..."
  wget -O vscode.zip https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal
  unzip vscode.zip -d /Applications/
  rm vscode.zip
else
  echo "VS Code 已安装，跳过。"
fi

# 安装 Flutter
if [ ! -d "$HOME/Developer/flutter" ]; then
  echo "安装 Flutter..."
  wget https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.27.1-stable.zip
  unzip flutter_macos_3.27.1-stable.zip -d ~/Developer/
  rm flutter_macos_3.27.1-stable.zip
  export PATH="$PATH:$HOME/Developer/flutter/bin"
else
  echo "Flutter 已安装，跳过。"
fi

# 验证 Flutter 安装
echo "验证 Flutter 安装..."
flutter doctor

# 配置 Ruby 和安装 Cocoapods
if ! command -v rbenv &>/dev/null; then
  echo "配置 Ruby 和安装 Cocoapods..."
  echo 'eval "$(rbenv init -)"' >>~/.zshrc
  source ~/.zshrc
  rbenv install 3.2.6
  rbenv global 3.2.6
  ruby -v
  gem install cocoapods
else
  echo "Ruby 和 Cocoapods 已安装，跳过。"
fi

# 完成安装

# 检查并输出所有工具的版本信息


# 显示系统信息
echo "系统信息："
echo "操作系统名称：$(uname -s)"
echo "系统内核版本：$(uname -r)"
echo "系统架构：$(uname -m)"
echo "CPU 信息：$(sysctl -n machdep.cpu.brand_string)"
echo "内存总量：$(($(sysctl -n hw.memsize) / 1024 / 1024 / 1024)) GB"


# 检查并输出所有工具的版本信息
echo "检查已安装工具的版本："
echo ""
if command -v wget &>/dev/null; then
  echo "wget 版本：$(wget -V | head -n 1)"
else
  echo "wget 未安装。"
fi
echo ""
if command -v pod &>/dev/null; then
  echo "Cocoapods 版本：$(pod --version)"
else
  echo "Cocoapods 未安装。"
fi
echo ""
if command -v flutter &>/dev/null; then
  echo "Flutter 版本：$(flutter --version)"
else
  echo "Flutter 未安装。"
fi
echo ""
if command -v rbenv &>/dev/null; then
  echo "rbenv 版本：$(rbenv -v)"
else
  echo "rbenv 未安装。"
fi
echo ""
if command -v ruby &>/dev/null; then
  echo "Ruby 版本：$(ruby -v)"
else
  echo "Ruby 未安装。"
fi


echo "安装完成！请确认各项工具是否正确安装。"
