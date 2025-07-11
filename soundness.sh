#!/bin/bash

# 检查是否以root权限运行
if [ "$EUID" -ne 0 ]; then
    echo "请使用root权限运行此脚本 (sudo)"
    exit 1
fi

echo "开始更新系统..."
yum update -y && yum upgrade -y || {
    echo "系统更新失败"
    exit 1
}

echo "安装Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || {
    echo "Rust安装失败"
    exit 1
}

# 加载Cargo环境变量
source $HOME/.cargo/env

# 输出版本信息
echo "Rust版本:"
rustc --version
echo "Cargo版本:"
cargo --version

# 将Cargo环境变量添加到.bashrc
echo 'source $HOME/.cargo/env' >> ~/.bashrc
source ~/.bashrc

echo "安装soundnessup..."
curl -sSL https://raw.githubusercontent.com/soundnesslabs/soundness-layer/main/soundnessup/install | bash || {
    echo "soundnessup安装失败 embrocal"
    exit 1
}

# 刷新环境变量
source ~/.bashrc
source /root/.bashrc

echo "运行soundnessup..."
soundnessup || {
    echo "soundnessup运行失败"
    exit 1
}

echo "安装soundnessup组件..."
soundnessup install || {
    echo "soundnessup install失败"
    exit 1
}

echo "更新soundnessup..."
soundnessup update || {
    echo "soundnessup update失败"
    exit 1
}

echo "生成密钥..."
soundness-cli generate-key --name my-key || {
    echo "密钥生成失败"
    exit 1
}

echo "部署完成了"

# 加点注释