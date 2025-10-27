#!/bin/bash

# 🚀 FUTURISTIC Neovim Setup Script
# Installs cutting-edge dependencies for next-level development

echo "🚀 Setting up FUTURISTIC Neovim environment..."
echo "This will install advanced AI, collaboration, and performance tools."

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ Don't run this script as root. It will use sudo when needed."
   exit 1
fi

# Update system
echo "📦 Updating system packages..."
sudo pacman -Syu --noconfirm

# Core dependencies (enhanced)
echo "🔧 Installing enhanced core dependencies..."
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
    wl-clipboard \
    curl \
    wget \
    jq \
    sqlite \
    postgresql \
    redis

# Advanced development tools
echo "🛠️ Installing advanced development tools..."
sudo pacman -S --needed --noconfirm \
    lldb \
    gdb \
    valgrind \
    perf \
    strace \
    ltrace \
    tree-sitter \
    tree-sitter-cli \
    pandoc \
    graphviz \
    plantuml

# Rust ecosystem (enhanced)
echo "🦀 Setting up enhanced Rust toolchain..."
if ! command -v rustup &> /dev/null; then
    sudo pacman -S --needed --noconfirm rustup
    rustup default stable
fi
rustup component add rust-analyzer
rustup component add llvm-tools-preview
rustup component add clippy
rustup component add rustfmt
cargo install code-minimap  # For minimap.vim
cargo install flamegraph    # For performance profiling

# Python ecosystem (enhanced)
echo "🐍 Setting up enhanced Python environment..."
sudo pacman -S --needed --noconfirm \
    python-pynvim \
    python-debugpy \
    python-pytest \
    python-black \
    python-isort \
    python-flake8 \
    python-mypy

pip install --user \
    pynvim \
    debugpy \
    pytest \
    black \
    isort \
    flake8 \
    mypy \
    jupytext \
    notebook

# Node.js ecosystem (enhanced)
echo "📦 Setting up enhanced Node.js environment..."
sudo npm install -g \
    neovim \
    typescript \
    typescript-language-server \
    @fsouza/prettierd \
    eslint_d \
    @tailwindcss/language-server \
    vscode-langservers-extracted \
    yaml-language-server \
    dockerfile-language-server-nodejs

# Database tools
echo "🗄️ Installing database tools..."
sudo pacman -S --needed --noconfirm \
    postgresql-libs \
    sqlite \
    redis

# Performance and profiling tools
echo "⚡ Installing performance tools..."
sudo pacman -S --needed --noconfirm \
    htop \
    btop \
    hyperfine \
    bandwhich \
    dust \
    tokei

# AI and ML tools (optional)
read -p "🤖 Install AI/ML tools (TensorFlow, PyTorch)? This is large (~2GB). (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    pip install --user torch torchvision tensorflow numpy pandas scikit-learn
fi

# Collaboration tools
echo "🤝 Setting up collaboration tools..."
sudo pacman -S --needed --noconfirm \
    tmux \
    screen \
    openssh

# LaTeX and documentation (optional)
read -p "📄 Install LaTeX and documentation tools? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed --noconfirm \
        texlive-core \
        texlive-bin \
        texlive-latexextra \
        zathura \
        zathura-pdf-mupdf
fi

# Container and cloud tools (optional)
read -p "☁️ Install container and cloud tools (Docker, kubectl)? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed --noconfirm \
        docker \
        docker-compose \
        kubectl \
        helm
    
    # Add user to docker group
    sudo usermod -aG docker $USER
    echo "⚠️ You'll need to log out and back in for Docker permissions to take effect."
fi

# Web development tools
echo "🌐 Installing web development tools..."
sudo pacman -S --needed --noconfirm \
    firefox \
    chromium

# Additional utilities
echo "🔧 Installing additional utilities..."
sudo pacman -S --needed --noconfirm \
    fzf \
    bat \
    exa \
    zoxide \
    starship

# Set up environment variables for Fish shell
echo "🐟 Setting up Fish shell environment variables..."

# Create Fish config directory if it doesn't exist
mkdir -p ~/.config/fish

# Add environment variables to Fish config
cat >> ~/.config/fish/config.fish << 'EOF'

# Neovim Futuristic Setup
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx NVIM_PROFILE 1  # Enable performance profiling

# Enhanced development environment
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -gx BAT_THEME "TwoDark"

# AI/ML environment (if installed)
set -gx CUDA_VISIBLE_DEVICES 0

# Performance monitoring aliases
alias nvim-profile='env NVIM_PROFILE=start nvim'
alias nvim-clean='nvim --clean'
alias nvim-startup='nvim --startuptime startup.log'

# Enhanced Fish aliases for development
alias ll='exa -la'
alias cat='bat'
alias find='fd'
alias grep='rg'

EOF

echo ""
echo "✅ Futuristic setup complete!"
echo ""
echo "🎯 What's new in your setup:"
echo "• 🤖 Advanced AI tools (Codeium, Neural, Sourcegraph)"
echo "• 🎨 Holographic UI (Dashboard, Zen mode, Minimap)"
echo "• 🔧 Cutting-edge dev tools (Refactoring, Code analysis)"
echo "• 🤝 Collaboration features (Real-time editing, REST client)"
echo "• ⚡ Performance monitoring (Profiling, Memory tracking)"
echo ""
echo "🚀 Next steps:"
echo "1. Restart your terminal (or run: source ~/.config/fish/config.fish)"
echo "2. Start Neovim: nvim"
echo "3. Let all plugins install (this may take 5-10 minutes)"
echo "4. Run :Mason to install enhanced LSP servers"
echo "5. Try the new dashboard and futuristic features!"
echo ""
echo "🔥 New keybindings to try:"
echo "• <Space>zz - Zen mode for distraction-free coding"
echo "• <Space>mm - Toggle minimap for code overview"
echo "• <Space>tw - Twilight mode for focus"
echo "• <Space>rr - Run code snippets instantly"
echo "• <Space>so - Symbols outline for navigation"
echo "• <Space>pm - Performance monitoring"
echo ""
echo "🎉 Welcome to the future of coding!"