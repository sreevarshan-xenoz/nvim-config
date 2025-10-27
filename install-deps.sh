#!/bin/bash

# Neovim 0.11+ Dependencies Installation Script for Arch Linux
# Run this script to install any missing dependencies

echo "🚀 Installing Neovim dependencies for Arch Linux..."

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ Don't run this script as root. It will use sudo when needed."
   exit 1
fi

# Update system first
echo "📦 Updating system packages..."
sudo pacman -Syu --noconfirm

# Core dependencies
echo "🔧 Installing core dependencies..."
sudo pacman -S --needed --noconfirm \
    neovim \
    git \
    nodejs \
    npm \
    ripgrep \
    fd \
    gcc \
    make \
    python \
    python-pip \
    clang \
    xclip \
    wl-clipboard

# Optional but recommended for Rust development
echo "🦀 Installing Rust toolchain..."
if ! command -v rustup &> /dev/null; then
    sudo pacman -S --needed --noconfirm rustup
    rustup default stable
else
    echo "✅ Rust already installed"
fi

# Python neovim support
echo "🐍 Installing Python neovim support..."
pip install --user pynvim

# Node.js neovim support
echo "📦 Installing Node.js neovim support..."
npm install -g neovim

echo "✅ All dependencies installed!"
echo ""
echo "Next steps:"
echo "1. Start Neovim: nvim"
echo "2. Let plugins install automatically"
echo "3. Run :checkhealth to verify everything works"
echo "4. Run :Mason to install LSP servers"
echo "5. Run :TSInstall all to install syntax parsers"
echo ""
echo "🎉 Happy coding!"