#!/bin/bash
# 🔧 Installation Configuration - Centralized settings for modular installer
# This file contains all configuration variables and settings

# 🎯 Installation Configuration
export INSTALL_CONFIG_VERSION="1.0.0"

# 📦 Package Lists by OS
declare -A OS_PACKAGES
OS_PACKAGES[arch]="git nodejs npm ripgrep fd gcc make python python-pip clang rustup go unzip curl wget tree-sitter luarocks base-devel cmake pkg-config"
OS_PACKAGES[debian]="git nodejs npm ripgrep fd-find gcc make python3 python3-pip clang rustc cargo golang-go unzip curl wget build-essential cmake pkg-config libtool-bin gettext"
OS_PACKAGES[fedora]="git nodejs npm ripgrep fd-find gcc make python3 python3-pip clang rust cargo golang unzip curl wget gcc-c++ cmake pkgconfig libtool gettext-devel"
OS_PACKAGES[rhel]="git nodejs npm gcc make python3 python3-pip clang golang unzip curl wget cmake pkgconfig libtool gettext-devel"
OS_PACKAGES[opensuse]="git nodejs npm ripgrep fd gcc make python3 python3-pip clang rust cargo go unzip curl wget gcc-c++ cmake pkg-config libtool gettext-tools"
OS_PACKAGES[macos]="git node ripgrep fd gcc make python3 llvm rust go unzip curl wget cmake pkg-config libtool gettext tree-sitter luarocks"

# 🐍 Python Packages
PYTHON_PACKAGES=(
    "pynvim" "debugpy" "black" "flake8" "mypy" "isort" "autopep8"
    "pylint" "bandit" "safety" "pytest" "pytest-cov"
)

# 🟢 Node.js Packages
NODE_PACKAGES=(
    "neovim" "typescript" "typescript-language-server"
    "prettier" "eslint" "@typescript-eslint/parser"
    "@typescript-eslint/eslint-plugin" "vscode-langservers-extracted"
    "yaml-language-server" "dockerfile-language-server-nodejs"
    "bash-language-server" "vim-language-server"
    "live-server" "browser-sync" "nodemon"
)

# 🦀 Rust Components
RUST_COMPONENTS=(
    "rust-analyzer" "clippy" "rustfmt"
)

# 🛠️ Language Servers (Mason)
LANGUAGE_SERVERS=(
    "lua-language-server" "pyright" "typescript-language-server"
    "rust-analyzer" "clangd" "gopls" "jdtls" "jsonls" "yamlls"
    "html" "cssls" "tailwindcss" "eslint" "prettier" "black"
    "stylua" "shfmt"
)

# 🌳 Treesitter Parsers
TREESITTER_PARSERS=(
    "lua" "vim" "vimdoc" "query"
    "python" "javascript" "typescript" "tsx"
    "rust" "go" "c" "cpp" "java"
    "html" "css" "json" "yaml" "toml"
    "markdown" "markdown_inline" "bash" "dockerfile"
)

# 🎨 Themes
THEMES=("tokyonight" "catppuccin" "gruvbox" "onedarkpro")

# ⚡ Performance Targets
STARTUP_TARGET_MS=100  # LunarVim mode target
BEAST_TARGET_MS=150    # Beast mode target
STANDARD_TARGET_MS=200 # Standard target

# 🔧 Installation Options (can be overridden by environment variables)
INSTALL_NEOVIDE=${INSTALL_NEOVIDE:-true}
INSTALL_BYTEBOT=${INSTALL_BYTEBOT:-true}
INSTALL_LUNARVIM=${INSTALL_LUNARVIM:-true}
INSTALL_AI=${INSTALL_AI:-true}
INSTALL_DEBUG=${INSTALL_DEBUG:-true}
INSTALL_GIT=${INSTALL_GIT:-true}

# 📁 Directory Structure
CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
INSTALL_SCRIPTS_DIR="$HOME/.local/bin"  # Renamed to avoid conflict
CACHE_DIR="$HOME/.cache/nvim-install"

# 🌐 URLs and Endpoints
BYTEBOT_ENDPOINT="http://localhost:9991"
GITHUB_RELEASES_API="https://api.github.com/repos"

# 📊 Logging Configuration
LOG_LEVEL=${LOG_LEVEL:-"INFO"}  # DEBUG, INFO, WARN, ERROR
LOG_FILE="$CACHE_DIR/install.log"

# 🎯 Feature Flags
ENABLE_PROFILING=${ENABLE_PROFILING:-false}
ENABLE_HEALTH_CHECK=${ENABLE_HEALTH_CHECK:-true}
ENABLE_VERIFICATION=${ENABLE_VERIFICATION:-true}
SKIP_CONFIRMATION=${SKIP_CONFIRMATION:-false}

# 🔒 Security Settings
ALLOW_ROOT=${ALLOW_ROOT:-false}
VERIFY_CHECKSUMS=${VERIFY_CHECKSUMS:-true}

# 📦 Module Configuration
declare -A MODULES
MODULES[core]="Essential foundation (plenary, treesitter, which-key)"
MODULES[ui]="Themes and beautiful interface"
MODULES[navigation]="Telescope, flash, oil navigation"
MODULES[lsp]="Language servers and completion"
MODULES[ai]="Copilot, ChatGPT, ByteBot integration"
MODULES[debug]="DAP debugging and testing"
MODULES[git]="Git integration and workflows"
MODULES[editing]="Enhanced editing tools"
MODULES[project]="Project and session management"
MODULES[languages]="Language-specific tools"

# 🎮 Default Module States
declare -A MODULE_ENABLED
MODULE_ENABLED[core]=true
MODULE_ENABLED[ui]=true
MODULE_ENABLED[navigation]=true
MODULE_ENABLED[lsp]=true
MODULE_ENABLED[ai]=${INSTALL_AI}
MODULE_ENABLED[debug]=${INSTALL_DEBUG}
MODULE_ENABLED[git]=${INSTALL_GIT}
MODULE_ENABLED[editing]=true
MODULE_ENABLED[project]=true
MODULE_ENABLED[languages]=true

# 🔧 Export all configuration
export OS_PACKAGES PYTHON_PACKAGES NODE_PACKAGES RUST_COMPONENTS
export LANGUAGE_SERVERS TREESITTER_PARSERS THEMES
export STARTUP_TARGET_MS BEAST_TARGET_MS STANDARD_TARGET_MS
export CONFIG_DIR BACKUP_DIR INSTALL_SCRIPTS_DIR CACHE_DIR
export BYTEBOT_ENDPOINT GITHUB_RELEASES_API
export LOG_LEVEL LOG_FILE
export MODULES MODULE_ENABLED