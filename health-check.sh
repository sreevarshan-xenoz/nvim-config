#!/bin/bash

# Neovim Health Check Script
# Quickly verify your Neovim setup

echo "🔍 Neovim Configuration Health Check"
echo "===================================="

# Check Neovim version
echo "📋 Neovim Version:"
nvim --version | head -1

echo ""
echo "🔧 System Dependencies:"

# Check essential tools
tools=("git" "node" "npm" "rg" "fd" "gcc" "make" "python" "pip" "clang" "xclip")
for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo "✅ $tool: $(which $tool)"
    else
        echo "❌ $tool: NOT FOUND"
    fi
done

echo ""
echo "🔌 Neovim Support Libraries:"

# Check Python support
if python -c "import pynvim" 2>/dev/null; then
    echo "✅ Python neovim support: OK"
else
    echo "❌ Python neovim support: MISSING (run: pip install pynvim)"
fi

# Check Node support
if npm list -g neovim 2>/dev/null | grep -q neovim; then
    echo "✅ Node.js neovim support: OK"
else
    echo "❌ Node.js neovim support: MISSING (run: npm install -g neovim)"
fi

echo ""
echo "📁 Configuration Status:"

# Check config files
config_files=(
    "init.lua"
    "lua/options.lua"
    "lua/keymaps.lua"
    "lua/plugins/core.lua"
    "lua/plugins/ui.lua"
    "lua/plugins/editing.lua"
    "lua/plugins/lsp.lua"
    "lua/plugins/git.lua"
    "lua/plugins/extras.lua"
)

for file in "${config_files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✅ $file"
    else
        echo "❌ $file: MISSING"
    fi
done

echo ""
echo "🚀 Quick Test:"
if nvim --headless -c "lua print('OK')" -c "qall" 2>/dev/null; then
    echo "✅ Neovim loads configuration successfully"
else
    echo "❌ Neovim configuration has errors"
fi

echo ""
echo "📝 Next Steps:"
echo "1. Run 'nvim' to start and install plugins"
echo "2. In Neovim, run ':checkhealth' for detailed diagnostics"
echo "3. Run ':Lazy sync' to ensure all plugins are installed"
echo "4. Run ':Mason' to install LSP servers"
echo "5. Run ':TSInstall all' to install syntax parsers"