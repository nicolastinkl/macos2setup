#!/bin/bash

# 检查是否为管理员权限
if [ "$EUID" -ne 0 ]; then
  echo "请使用管理员权限运行脚本 (sudo)。"
  exit
fi

echo "安装 Flutter..."
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.3.10-stable.zip
unzip flutter_macos_3.3.10-stable.zip -d ~/Developer/
rm flutter_macos_3.3.10-stable.zip
export PATH="$PATH:$HOME/Developer/flutter/bin"

# 验证 Flutter 安装
echo "验证 Flutter 安装..."
flutter doctor
