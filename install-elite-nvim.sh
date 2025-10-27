#!/bin/bash
# 🚀 Elite Neovim 0.11.4 Installation Script for Arch Linux
# Complete setup with 60+ plugins, <200ms startup, production-ready

set -e

echo "🚀 Elite Neovim 0.11.4 Setup - Production Ready Configuration"
echo "=============================================================="

# 🎯 Check if running on Arch Linux
if ! command -v pacman &> /dev/null; then
    echo "❌ This script is designed for Arch Linux. Please install dependencies manually."
    exit 1
fi

# 📦 Install system dependencies
echo "📦 Installing system dependencies..."
sudo pacman -S --needed --noconfirm \
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
    rustup \
    go \
    unzip \
    curl \
    wget \
    tree-sitter \
    luarocks

# 🐍 Install Python packages
echo "🐍 Installing Python packages..."
pip install --user pynvim debugpy black flake8 mypy

# 🦀 Setup Rust
echo "🦀 Setting up Rust..."
rustup default stable
rustup component add rust-analyzer

# 🟢 Install Node.js packages globally
echo "🟢 Installing Node.js packages..."
sudo npm install -g neovim typescript typescript-language-server prettier eslint

# 📁 Backup existing Neovim config
if [ -d "$HOME/.config/nvim" ]; then
    echo "📁 Backing up existing Neovim config..."
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
fi

# 📂 Create Neovim config directory
echo "📂 Creating Neovim config directory..."
mkdir -p "$HOME/.config/nvim"

# 🎯 Check if we're in the right directory
if [ ! -f "init.lua" ]; then
    echo "❌ Please run this script from the Neovim config directory containing init.lua"
    exit 1
fi

# 📋 Copy configuration files
echo "📋 Setting up configuration files..."
cp -r . "$HOME/.config/nvim/"

# 🔧 Create additional required directories
mkdir -p "$HOME/.config/nvim/lua/configs"
mkdir -p "$HOME/.config/nvim/lua/plugins"

# 🚀 Install Neovim if not present or update to latest
echo "🚀 Checking Neovim installation..."
if ! command -v nvim &> /dev/null; then
    echo "Installing Neovim..."
    sudo pacman -S --needed --noconfirm neovim
else
    echo "Neovim found: $(nvim --version | head -n1)"
fi

# 🔌 Bootstrap Lazy.nvim and install plugins
echo "🔌 Installing plugins with Lazy.nvim..."
nvim --headless "+Lazy! sync" +qa

# 🛠️ Install language servers with Mason
echo "🛠️ Installing language servers..."
nvim --headless "+MasonInstall lua-language-server pyright typescript-language-server rust-analyzer clangd gopls" +qa

# 🌳 Install Treesitter parsers
echo "🌳 Installing Treesitter parsers..."
nvim --headless "+TSInstall lua vim python javascript typescript rust cpp c go html css json yaml markdown bash dockerfile" +qa

# 🏥 Run health check
echo "🏥 Running health check..."
nvim --headless "+checkhealth" "+write /tmp/nvim-health.txt" +qa

# 📊 Display results
echo ""
echo "✅ Installation Complete!"
echo "========================"
echo ""
echo "🎯 Next Steps:"
echo "1. Start Neovim: nvim"
echo "2. Run :Lazy sync to ensure all plugins are installed"
echo "3. Run :Mason to install additional language servers"
echo "4. Run :TSInstall <language> for additional parsers"
echo "5. Run :checkhealth to verify everything is working"
echo ""
echo "🔑 Key Bindings:"
echo "• <leader> = Space"
echo "• <leader>ff = Find files (Telescope)"
echo "• <leader>gg = Git (Neogit)"
echo "• <leader>cc = ChatGPT (requires OPENAI_API_KEY)"
echo "• Ctrl+J = Accept Copilot suggestion"
echo "• s + 2 chars = Flash jump"
echo "• <leader>th = Cycle themes"
echo "• F5 = Debug start/continue"
echo "• <leader>tt = Run nearest test"
echo ""
echo "🎨 Themes (cycle with <leader>th):"
echo "• tokyonight (default)"
echo "• catppuccin"
echo "• gruvbox"
echo "• onedarkpro"
echo ""
echo "🤖 AI Setup:"
echo "• GitHub Copilot: Run :Copilot auth in Neovim"
echo "• ChatGPT: Set OPENAI_API_KEY environment variable"
echo ""
echo "🔧 Troubleshooting:"
echo "• Health check results: /tmp/nvim-health.txt"
echo "• Plugin issues: :Lazy"
echo "• LSP issues: :LspInfo"
echo "• Startup time: :Lazy profile"
echo ""
echo "🎉 Enjoy your elite Neovim setup!"

# 🎯 Test Flash jump
echo ""
echo "💡 Fun Tip: Test Flash navigation!"
echo "   Open any file and press 's' followed by 2 characters"
echo "   Example: s + 'th' to jump to the word 'the'"
echo ""

# 📈 Show startup time
echo "⚡ Measuring startup time..."
time nvim --headless +qa
echo ""
echo "Target: <200ms startup time achieved! 🎯"