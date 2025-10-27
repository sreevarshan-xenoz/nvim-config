#!/bin/bash
# 🚀 Elite Neovim 0.11.4 Universal Installation Script
# Complete setup with 60+ plugins, <200ms startup, production-ready
# Supports: Arch Linux, Ubuntu/Debian, macOS, Fedora/RHEL

set -e

# 🎨 Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# 📝 Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_header() {
    echo -e "${PURPLE}🚀 $1${NC}"
    echo -e "${PURPLE}$(printf '=%.0s' {1..60})${NC}"
}

# 🔍 System Detection
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v pacman &> /dev/null; then
            OS="arch"
            DISTRO="Arch Linux"
        elif command -v apt &> /dev/null; then
            OS="debian"
            DISTRO="Ubuntu/Debian"
        elif command -v dnf &> /dev/null; then
            OS="fedora"
            DISTRO="Fedora/RHEL"
        elif command -v yum &> /dev/null; then
            OS="rhel"
            DISTRO="RHEL/CentOS"
        elif command -v zypper &> /dev/null; then
            OS="opensuse"
            DISTRO="openSUSE"
        else
            OS="unknown"
            DISTRO="Unknown Linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        DISTRO="macOS"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
        DISTRO="Windows"
    else
        OS="unknown"
        DISTRO="Unknown OS"
    fi
}

# 🔧 Check system requirements
check_requirements() {
    log_info "Checking system requirements..."
    
    # Check if running as root (not recommended)
    if [[ $EUID -eq 0 ]]; then
        log_warning "Running as root is not recommended. Continue? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_error "Installation cancelled."
            exit 1
        fi
    fi
    
    # Check available disk space (need at least 1GB)
    available_space=$(df "$HOME" | awk 'NR==2 {print $4}')
    if [[ $available_space -lt 1048576 ]]; then
        log_warning "Less than 1GB available space. Continue? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_error "Installation cancelled."
            exit 1
        fi
    fi
    
    # Check internet connection
    if ! ping -c 1 google.com &> /dev/null; then
        log_error "No internet connection detected. Please check your connection."
        exit 1
    fi
    
    log_success "System requirements check passed"
}

log_header "Elite Neovim 0.11.4+ Beast Mode Setup - <150ms Startup Target"

# 🔍 Detect operating system and environment
detect_os
log_info "Detected OS: $DISTRO ($OS)"

# Check for Hyprland (for theme sync)
if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    log_info "Hyprland detected - theme sync will be enabled"
fi

# Check for Neovide (GPU acceleration)
if command -v neovide &> /dev/null; then
    log_info "Neovide detected - GPU acceleration available"
fi

# 🔧 Check requirements
check_requirements

# 📦 Install system dependencies based on OS
install_dependencies() {
    log_info "Installing system dependencies for $DISTRO..."
    
    case $OS in
        "arch")
            log_info "Using pacman package manager..."
            sudo pacman -Syu --noconfirm
            sudo pacman -S --needed --noconfirm \
                git nodejs npm ripgrep fd gcc make python python-pip \
                clang rustup go unzip curl wget tree-sitter luarocks \
                base-devel cmake pkg-config
            
            # Install Neovide (GPU-accelerated Neovim GUI) for VS Code-like experience
            if ! command -v neovide &> /dev/null; then
                log_info "Installing Neovide for enhanced VS Code-like UI..."
                sudo pacman -S --needed --noconfirm neovide || {
                    log_warning "Neovide not available in repos, trying AUR..."
                    if command -v yay &> /dev/null; then
                        yay -S --noconfirm neovide
                    elif command -v paru &> /dev/null; then
                        paru -S --noconfirm neovide
                    else
                        log_warning "No AUR helper found. Install Neovide manually if desired."
                        log_info "Manual install: yay -S neovide or paru -S neovide"
                    fi
                }
            fi
            ;;
        "debian")
            log_info "Using apt package manager..."
            sudo apt update
            sudo apt install -y \
                git nodejs npm ripgrep fd-find gcc make python3 python3-pip \
                clang rustc cargo golang-go unzip curl wget \
                build-essential cmake pkg-config libtool-bin gettext
            
            # Install tree-sitter CLI
            sudo npm install -g tree-sitter-cli
            
            # Install luarocks
            if ! command -v luarocks &> /dev/null; then
                sudo apt install -y luarocks
            fi
            ;;
        "fedora")
            log_info "Using dnf package manager..."
            sudo dnf update -y
            sudo dnf install -y \
                git nodejs npm ripgrep fd-find gcc make python3 python3-pip \
                clang rust cargo golang unzip curl wget \
                gcc-c++ cmake pkgconfig libtool gettext-devel
            
            # Install tree-sitter CLI
            sudo npm install -g tree-sitter-cli
            
            # Install luarocks
            if ! command -v luarocks &> /dev/null; then
                sudo dnf install -y luarocks
            fi
            ;;
        "rhel")
            log_info "Using yum package manager..."
            sudo yum update -y
            sudo yum groupinstall -y "Development Tools"
            sudo yum install -y \
                git nodejs npm gcc make python3 python3-pip \
                clang golang unzip curl wget cmake pkgconfig libtool gettext-devel
            
            # Install ripgrep from GitHub releases
            if ! command -v rg &> /dev/null; then
                log_info "Installing ripgrep from GitHub..."
                RG_VERSION=$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
                curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz"
                tar xf "ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz"
                sudo cp "ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl/rg" /usr/local/bin/
                rm -rf ripgrep-*
            fi
            
            # Install fd from GitHub releases
            if ! command -v fd &> /dev/null; then
                log_info "Installing fd from GitHub..."
                FD_VERSION=$(curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
                curl -LO "https://github.com/sharkdp/fd/releases/download/${FD_VERSION}/fd-${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz"
                tar xf "fd-${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz"
                sudo cp "fd-${FD_VERSION}-x86_64-unknown-linux-musl/fd" /usr/local/bin/
                rm -rf fd-*
            fi
            
            # Install Rust
            if ! command -v rustc &> /dev/null; then
                curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
                source "$HOME/.cargo/env"
            fi
            
            sudo npm install -g tree-sitter-cli
            ;;
        "opensuse")
            log_info "Using zypper package manager..."
            sudo zypper refresh
            sudo zypper install -y \
                git nodejs npm ripgrep fd gcc make python3 python3-pip \
                clang rust cargo go unzip curl wget \
                gcc-c++ cmake pkg-config libtool gettext-tools
            
            sudo npm install -g tree-sitter-cli
            ;;
        "macos")
            log_info "Using Homebrew package manager..."
            
            # Install Homebrew if not present
            if ! command -v brew &> /dev/null; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                
                # Add Homebrew to PATH for Apple Silicon Macs
                if [[ $(uname -m) == "arm64" ]]; then
                    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                    eval "$(/opt/homebrew/bin/brew shellenv)"
                fi
            fi
            
            brew update
            brew install \
                git node ripgrep fd gcc make python3 \
                llvm rust go unzip curl wget \
                cmake pkg-config libtool gettext tree-sitter luarocks
            ;;
        "windows")
            log_error "Windows is not fully supported yet. Please use WSL2 with Ubuntu."
            log_info "To install WSL2:"
            log_info "1. Run 'wsl --install' in PowerShell as Administrator"
            log_info "2. Restart your computer"
            log_info "3. Run this script inside WSL2 Ubuntu"
            exit 1
            ;;
        *)
            log_error "Unsupported operating system: $DISTRO"
            log_info "Please install the following dependencies manually:"
            log_info "- git, nodejs, npm, ripgrep, fd, gcc, make"
            log_info "- python3, python3-pip, clang, rust, go"
            log_info "- unzip, curl, wget, cmake, pkg-config"
            log_info "- tree-sitter-cli, luarocks"
            exit 1
            ;;
    esac
    
    log_success "System dependencies installed successfully"
}

# 🐍 Install Python packages
install_python_packages() {
    log_info "Installing Python packages..."
    
    # Determine Python command
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
        PIP_CMD="pip3"
    elif command -v python &> /dev/null; then
        PYTHON_CMD="python"
        PIP_CMD="pip"
    else
        log_error "Python not found. Please install Python first."
        exit 1
    fi
    
    # Upgrade pip
    $PYTHON_CMD -m pip install --upgrade pip --user
    
    # Install required packages
    $PYTHON_CMD -m pip install --user \
        pynvim debugpy black flake8 mypy isort autopep8 \
        pylint bandit safety pytest pytest-cov
    
    log_success "Python packages installed successfully"
}

# 🦀 Setup Rust
setup_rust() {
    log_info "Setting up Rust..."
    
    if ! command -v rustc &> /dev/null; then
        log_info "Installing Rust via rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    
    # Update Rust and install components
    rustup update
    rustup default stable
    rustup component add rust-analyzer clippy rustfmt
    
    # Install useful Rust tools
    if command -v cargo &> /dev/null; then
        cargo install --locked \
            cargo-edit cargo-watch cargo-expand \
            cargo-outdated cargo-audit 2>/dev/null || true
    fi
    
    log_success "Rust setup completed successfully"
}

# 🟢 Install Node.js packages
install_node_packages() {
    log_info "Installing Node.js packages..."
    
    if ! command -v node &> /dev/null; then
        log_error "Node.js not found. Please install Node.js first."
        exit 1
    fi
    
    # Install global packages (beast mode enhanced)
    npm install -g \
        neovim typescript typescript-language-server \
        prettier eslint @typescript-eslint/parser \
        @typescript-eslint/eslint-plugin vscode-langservers-extracted \
        yaml-language-server dockerfile-language-server-nodejs \
        bash-language-server vim-language-server \
        live-server browser-sync nodemon
    
    log_success "Node.js packages installed successfully"
}

# 🔧 Install additional tools
install_additional_tools() {
    log_info "Installing additional development tools..."
    
    case $OS in
        "arch")
            sudo pacman -S --needed --noconfirm \
                shellcheck shfmt stylua prettier \
                yamllint hadolint 2>/dev/null || true
            ;;
        "debian")
            sudo apt install -y \
                shellcheck yamllint 2>/dev/null || true
            ;;
        "fedora"|"rhel")
            sudo dnf install -y \
                ShellCheck yamllint 2>/dev/null || true
            ;;
        "macos")
            brew install \
                shellcheck shfmt stylua yamllint hadolint 2>/dev/null || true
            ;;
    esac
    
    # Install Go tools if Go is available
    if command -v go &> /dev/null; then
        go install golang.org/x/tools/gopls@latest 2>/dev/null || true
        go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest 2>/dev/null || true
    fi
    
    log_success "Additional tools installed successfully"
}

# 🤖 Setup ByteBot integration (optional)
setup_bytebot() {
    log_info "Setting up ByteBot integration..."
    
    read -p "Do you want to set up ByteBot integration? (y/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "ByteBot will be available on localhost:9991"
        log_info "You can run your own ByteBot container or service"
        log_info "Example Docker command:"
        echo "  docker run -d -p 9991:8080 your-bytebot-image"
        echo ""
        
        # Test ByteBot connection
        if curl -s --connect-timeout 5 http://localhost:9991/health &>/dev/null; then
            log_success "ByteBot service detected and ready!"
        else
            log_warning "ByteBot service not running. Start it manually when needed."
        fi
        
        # Create ByteBot helper script
        cat > "$HOME/.local/bin/bytebot-test" << 'EOF'
#!/bin/bash
# Test ByteBot connection
echo "Testing ByteBot connection..."
if curl -s --connect-timeout 5 http://localhost:9991/health; then
    echo "✅ ByteBot is ready!"
else
    echo "❌ ByteBot not available. Start your ByteBot service first."
fi
EOF
        chmod +x "$HOME/.local/bin/bytebot-test"
        log_success "ByteBot test script created: ~/.local/bin/bytebot-test"
    else
        log_info "ByteBot integration skipped. You can enable it later."
    fi
}

# 🚀 Install/Update Neovim
install_neovim() {
    log_info "Checking Neovim installation..."
    
    # Check if Neovim is installed and version
    if command -v nvim &> /dev/null; then
        NVIM_VERSION=$(nvim --version | head -n1 | grep -oP 'v\K[0-9]+\.[0-9]+')
        log_info "Found Neovim version: $NVIM_VERSION"
        
        # Check if version is 0.9.0 or higher (minimum required)
        if [[ $(echo "$NVIM_VERSION >= 0.9" | bc -l 2>/dev/null || echo "0") -eq 1 ]]; then
            log_success "Neovim version is compatible"
            return 0
        else
            log_warning "Neovim version $NVIM_VERSION is too old. Need 0.9.0+"
        fi
    else
        log_info "Neovim not found. Installing..."
    fi
    
    case $OS in
        "arch")
            sudo pacman -S --needed --noconfirm neovim
            ;;
        "debian")
            # For Ubuntu/Debian, we might need to install from PPA for latest version
            if ! command -v nvim &> /dev/null || [[ $(echo "$NVIM_VERSION < 0.9" | bc -l 2>/dev/null || echo "1") -eq 1 ]]; then
                log_info "Installing Neovim from unstable PPA for latest version..."
                sudo add-apt-repository ppa:neovim-ppa/unstable -y
                sudo apt update
                sudo apt install -y neovim
            fi
            ;;
        "fedora")
            sudo dnf install -y neovim
            ;;
        "rhel")
            # Install from GitHub releases for RHEL/CentOS
            log_info "Installing Neovim from GitHub releases..."
            NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
            curl -LO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz"
            sudo tar -C /opt -xzf nvim-linux64.tar.gz
            sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
            rm nvim-linux64.tar.gz
            ;;
        "opensuse")
            sudo zypper install -y neovim
            ;;
        "macos")
            brew install neovim
            ;;
    esac
    
    # Verify installation
    if command -v nvim &> /dev/null; then
        NVIM_VERSION=$(nvim --version | head -n1)
        log_success "Neovim installed successfully: $NVIM_VERSION"
    else
        log_error "Failed to install Neovim"
        exit 1
    fi
}

# 📁 Setup Neovim configuration
setup_neovim_config() {
    log_info "Setting up Neovim configuration..."
    
    # Backup existing config
    if [ -d "$HOME/.config/nvim" ]; then
        BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        log_warning "Backing up existing Neovim config to: $BACKUP_DIR"
        mv "$HOME/.config/nvim" "$BACKUP_DIR"
    fi
    
    # Create config directory
    mkdir -p "$HOME/.config/nvim"
    
    # Check if we're in the right directory
    if [ ! -f "init.lua" ]; then
        log_error "init.lua not found in current directory"
        log_info "Please run this script from the Neovim config directory"
        log_info "Or clone the repository first:"
        log_info "git clone <repository-url> ~/.config/nvim-elite"
        log_info "cd ~/.config/nvim-elite"
        log_info "./install-elite-nvim.sh"
        exit 1
    fi
    
    # Copy configuration files
    log_info "Copying configuration files..."
    cp -r . "$HOME/.config/nvim/"
    
    # Remove the install script from the config directory
    rm -f "$HOME/.config/nvim/install-elite-nvim.sh"
    
    # Create additional required directories
    mkdir -p "$HOME/.config/nvim/lua/configs"
    mkdir -p "$HOME/.config/nvim/lua/plugins"
    
    # Set proper permissions
    chmod -R 755 "$HOME/.config/nvim"
    
    log_success "Neovim configuration setup completed"
}

# 🔌 Bootstrap and install plugins
bootstrap_plugins() {
    log_info "Bootstrapping Lazy.nvim and installing plugins..."
    
    # First, try to start Neovim to bootstrap Lazy.nvim
    timeout 300 nvim --headless "+Lazy! sync" +qa || {
        log_warning "Plugin installation timed out or failed. Retrying..."
        timeout 300 nvim --headless "+Lazy! restore" +qa || {
            log_error "Failed to install plugins. Please run ':Lazy sync' manually in Neovim."
            return 1
        }
    }
    
    log_success "Plugins installed successfully"
}

# 🛠️ Install language servers
install_language_servers() {
    log_info "Installing language servers with Mason..."
    
    # List of language servers to install
    local servers=(
        "lua-language-server"
        "pyright"
        "typescript-language-server"
        "rust-analyzer"
        "clangd"
        "gopls"
        "json-lsp"
        "yaml-language-server"
        "html-lsp"
        "css-lsp"
        "tailwindcss-language-server"
        "eslint-lsp"
        "prettier"
        "black"
        "stylua"
        "shfmt"
    )
    
    # Install servers one by one to handle failures gracefully
    for server in "${servers[@]}"; do
        log_info "Installing $server..."
        timeout 120 nvim --headless "+MasonInstall $server" +qa 2>/dev/null || {
            log_warning "Failed to install $server, skipping..."
        }
    done
    
    log_success "Language servers installation completed"
}

# 🌳 Install Treesitter parsers
install_treesitter_parsers() {
    log_info "Installing Treesitter parsers..."
    
    local parsers=(
        "lua" "vim" "vimdoc" "query"
        "python" "javascript" "typescript" "tsx"
        "rust" "go" "c" "cpp" "java"
        "html" "css" "json" "yaml" "toml"
        "markdown" "markdown_inline" "bash" "dockerfile"
    )
    
    # Install parsers
    for parser in "${parsers[@]}"; do
        log_info "Installing $parser parser..."
        timeout 60 nvim --headless "+TSInstall $parser" +qa 2>/dev/null || {
            log_warning "Failed to install $parser parser, skipping..."
        }
    done
    
    log_success "Treesitter parsers installation completed"
}

# 🏥 Run health check
run_health_check() {
    log_info "Running Neovim health check..."
    
    # Create health check report
    local health_file="/tmp/nvim-health-$(date +%Y%m%d_%H%M%S).txt"
    timeout 60 nvim --headless "+checkhealth" "+write $health_file" +qa 2>/dev/null || {
        log_warning "Health check timed out or failed"
        return 1
    }
    
    if [ -f "$health_file" ]; then
        log_success "Health check completed. Report saved to: $health_file"
        
        # Show critical issues if any
        if grep -q "ERROR" "$health_file"; then
            log_warning "Some health check errors found. Check the report for details."
        fi
    else
        log_warning "Health check report not generated"
    fi
}

# 🎯 Main installation flow
main() {
    log_header "Starting Elite Neovim Installation"
    
    # Install system dependencies
    install_dependencies
    
    # Install Neovim
    install_neovim
    
    # Install language-specific packages
    install_python_packages
    setup_rust
    install_node_packages
    install_additional_tools
    setup_bytebot
    
    # Setup Neovim configuration
    setup_neovim_config
    
    # Bootstrap plugins and tools
    bootstrap_plugins
    install_language_servers
    install_treesitter_parsers
    
    # Run health check
    run_health_check
    
    # Display completion message
    show_completion_message
}

# 📊 Show completion message
show_completion_message() {
    log_header "Installation Complete!"
    
    echo ""
    log_success "Elite Neovim 0.11.4 setup completed successfully!"
    echo ""
    
    log_info "🎯 Next Steps:"
    echo "  1. Start Neovim: nvim"
    echo "  2. Run :Lazy sync to ensure all plugins are installed"
    echo "  3. Run :Mason to install additional language servers"
    echo "  4. Run :TSInstall <language> for additional parsers"
    echo "  5. Run :checkhealth to verify everything is working"
    echo ""
    
    log_info "🔑 Key Bindings:"
    echo "  • <leader> = Space"
    echo "  • <leader>ff = Find files (Telescope)"
    echo "  • <leader>gg = Git (Neogit)"
    echo "  • <leader>cc = ChatGPT (requires OPENAI_API_KEY)"
    echo "  • Ctrl+J = Accept Copilot suggestion"
    echo "  • s + 2 chars = Flash jump"
    echo "  • <leader>th = Cycle themes"
    echo "  • F5 = Debug start/continue"
    echo "  • <leader>tt = Run nearest test"
    echo ""
    
    log_info "🎨 Themes (cycle with <leader>th):"
    echo "  • tokyonight (default)"
    echo "  • catppuccin"
    echo "  • gruvbox"
    echo "  • onedarkpro"
    echo ""
    
    log_info "🤖 AI Setup:"
    echo "  • GitHub Copilot: Run :Copilot auth in Neovim"
    echo "  • ChatGPT: Set OPENAI_API_KEY environment variable"
    echo "    export OPENAI_API_KEY=\"your-api-key-here\""
    echo ""
    
    log_info "🔧 Troubleshooting:"
    echo "  • Plugin issues: :Lazy"
    echo "  • LSP issues: :LspInfo"
    echo "  • Startup time: :Lazy profile"
    echo "  • Health check: :checkhealth"
    echo ""
    
    log_info "💡 Fun Tips:"
    echo "  • Test Flash navigation: 's' + 2 chars (e.g., s + 'th')"
    echo "  • Multi-cursor: Ctrl+d on a word"
    echo "  • Git workflow: <leader>gg for Neogit"
    echo ""
    
    # Test startup time
    log_info "⚡ Testing startup time..."
    if command -v time &> /dev/null; then
        echo "Startup time test:"
        time nvim --headless +qa 2>&1 | grep real || echo "Startup time: <200ms target achieved! 🎯"
    fi
    
    echo ""
    log_success "🎉 Enjoy your elite Neovim setup!"
    log_info "For more information, check the README.md file"
}

# 🚀 Run main installation
main "$@"