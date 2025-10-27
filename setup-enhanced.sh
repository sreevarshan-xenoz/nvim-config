#!/bin/bash

# Enhanced Neovim Setup Script
# Installs additional dependencies for the new plugins

echo "🚀 Setting up enhanced Neovim dependencies..."

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ Don't run this script as root. It will use sudo when needed."
   exit 1
fi

# Core dependencies (if not already installed)
echo "📦 Installing core dependencies..."
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

# Enhanced dependencies for new plugins
echo "🔧 Installing enhanced dependencies..."
sudo pacman -S --needed --noconfirm \
    lldb \
    gdb \
    python-debugpy \
    python-pytest \
    tree-sitter \
    tree-sitter-cli

# Rust toolchain (for rust-analyzer and debugging)
echo "🦀 Setting up Rust toolchain..."
if ! command -v rustup &> /dev/null; then
    sudo pacman -S --needed --noconfirm rustup
    rustup default stable
    rustup component add rust-analyzer
    rustup component add llvm-tools-preview
else
    echo "✅ Rust already installed, updating components..."
    rustup component add rust-analyzer
    rustup component add llvm-tools-preview
fi

# Python support
echo "🐍 Installing Python support..."
sudo pacman -S --needed --noconfirm python-pynvim python-debugpy
pip install --user pynvim debugpy pytest

# Node.js support
echo "📦 Installing Node.js support..."
sudo npm install -g neovim typescript typescript-language-server

# Optional: LaTeX support (for vimtex)
read -p "📄 Install LaTeX support? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed --noconfirm texlive-core texlive-bin zathura zathura-pdf-mupdf
fi

# Optional: Markdown preview dependencies
read -p "📝 Install Markdown preview dependencies? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed --noconfirm pandoc
fi

echo ""
echo "✅ Enhanced setup complete!"
echo ""
echo "🎯 Next steps:"
echo "1. Start Neovim: nvim"
echo "2. Let all plugins install (this may take a few minutes)"
echo "3. Run :Mason to install LSP servers"
echo "4. Run :TSInstall all to install syntax parsers"
echo "5. For GitHub Copilot: :Copilot setup (requires GitHub account)"
echo "6. For ChatGPT: Set OPENAI_API_KEY environment variable"
echo ""
echo "🔧 Key features to try:"
echo "- Press 's' + 2 characters to jump anywhere (Flash)"
echo "- Use Ctrl+d to select multiple instances of a word"
echo "- Press F5 to start debugging in any supported language"
echo "- Use <leader>fp to switch between projects"
echo "- Try <leader>tt to run tests in Python/JS/Rust files"
echo ""
echo "🎉 Happy coding with your supercharged Neovim!"