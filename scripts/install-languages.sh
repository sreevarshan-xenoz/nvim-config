#!/bin/bash
# 🐍 Language Installation Module - Python, Rust, Node.js setup
# Modular language-specific package installation

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/install-utils.sh"

# 🐍 Install Python packages
install_python_packages() {
    if ! is_module_enabled "languages"; then
        log_info "Languages module disabled, skipping Python packages"
        return 0
    fi
    
    log_header "Installing Python Development Packages"
    
    # Determine Python command
    local python_cmd pip_cmd
    if command -v python3 &> /dev/null; then
        python_cmd="python3"
        pip_cmd="pip3"
    elif command -v python &> /dev/null; then
        python_cmd="python"
        pip_cmd="pip"
    else
        log_error "Python not found. Please install Python first."
        return 1
    fi
    
    log_info "Using Python: $python_cmd"
    
    # Upgrade pip
    log_info "Upgrading pip..."
    $python_cmd -m pip install --upgrade pip --user
    
    # Install packages with progress tracking
    local total=${#PYTHON_PACKAGES[@]}
    local current=0
    
    for package in "${PYTHON_PACKAGES[@]}"; do
        ((current++))
        show_progress $current $total "Installing $package"
        
        if $python_cmd -m pip install --user "$package" &>/dev/null; then
            log_debug "Successfully installed: $package"
        else
            log_warning "Failed to install: $package"
        fi
    done
    
    echo "" # New line after progress bar
    log_success "Python packages installation completed"
    
    # Verify key packages
    local key_packages=("pynvim" "debugpy" "black")
    for package in "${key_packages[@]}"; do
        if $python_cmd -c "import $package" 2>/dev/null; then
            log_success "$package verified"
        else
            log_warning "$package may not be working correctly"
        fi
    done
}

# 🦀 Setup Rust development environment
setup_rust_environment() {
    if ! is_module_enabled "languages"; then
        log_info "Languages module disabled, skipping Rust setup"
        return 0
    fi
    
    log_header "Setting up Rust Development Environment"
    
    # Install Rust if not present
    if ! command -v rustc &> /dev/null; then
        log_info "Installing Rust via rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    
    # Update Rust and install components
    log_info "Updating Rust toolchain..."
    rustup update
    rustup default stable
    
    # Install components with progress tracking
    local total=${#RUST_COMPONENTS[@]}
    local current=0
    
    for component in "${RUST_COMPONENTS[@]}"; do
        ((current++))
        show_progress $current $total "Installing $component"
        
        if rustup component add "$component" &>/dev/null; then
            log_debug "Successfully installed: $component"
        else
            log_warning "Failed to install: $component"
        fi
    done
    
    echo "" # New line after progress bar
    
    # Install useful Rust tools
    if command -v cargo &> /dev/null; then
        log_info "Installing additional Rust tools..."
        local rust_tools=("cargo-edit" "cargo-watch" "cargo-expand" "cargo-outdated" "cargo-audit")
        
        for tool in "${rust_tools[@]}"; do
            log_info "Installing $tool..."
            cargo install --locked "$tool" &>/dev/null || log_warning "Failed to install $tool"
        done
    fi
    
    log_success "Rust environment setup completed"
    
    # Verify installation
    if command -v rustc &> /dev/null && command -v cargo &> /dev/null; then
        local rust_version=$(rustc --version)
        log_success "Rust verified: $rust_version"
    else
        log_error "Rust installation verification failed"
        return 1
    fi
}

# 🟢 Install Node.js packages
install_node_packages() {
    if ! is_module_enabled "languages"; then
        log_info "Languages module disabled, skipping Node.js packages"
        return 0
    fi
    
    log_header "Installing Node.js Development Packages"
    
    if ! command -v node &> /dev/null; then
        log_error "Node.js not found. Please install Node.js first."
        return 1
    fi
    
    local node_version=$(node --version)
    log_info "Using Node.js: $node_version"
    
    # Install packages with progress tracking
    local total=${#NODE_PACKAGES[@]}
    local current=0
    
    for package in "${NODE_PACKAGES[@]}"; do
        ((current++))
        show_progress $current $total "Installing $package"
        
        if npm install -g "$package" &>/dev/null; then
            log_debug "Successfully installed: $package"
        else
            log_warning "Failed to install: $package"
        fi
    done
    
    echo "" # New line after progress bar
    log_success "Node.js packages installation completed"
    
    # Verify key packages
    local key_packages=("neovim" "typescript" "prettier")
    for package in "${key_packages[@]}"; do
        if npm list -g "$package" &>/dev/null; then
            log_success "$package verified"
        else
            log_warning "$package may not be installed correctly"
        fi
    done
}

# 🔧 Install language-specific tools
install_language_tools() {
    log_header "Installing Language-Specific Tools"
    
    # Java (if requested)
    if command -v java &> /dev/null; then
        log_info "Java detected, installing Java tools..."
        # Add Java-specific tools here
    fi
    
    # C/C++ tools
    if command -v gcc &> /dev/null; then
        log_info "GCC detected, installing C/C++ tools..."
        case $OS in
            "arch")
                sudo pacman -S --needed --noconfirm gdb valgrind 2>/dev/null || true
                ;;
            "debian")
                sudo apt install -y gdb valgrind 2>/dev/null || true
                ;;
            "fedora"|"rhel")
                sudo dnf install -y gdb valgrind 2>/dev/null || true
                ;;
            "macos")
                brew install gdb 2>/dev/null || true
                ;;
        esac
    fi
    
    log_success "Language-specific tools installation completed"
}

# 🚀 Main language installation function
install_languages() {
    log_header "Language Installation Module"
    
    install_python_packages
    setup_rust_environment
    install_node_packages
    install_language_tools
    
    log_success "Language installation completed successfully"
}

# Export functions
export -f install_python_packages setup_rust_environment install_node_packages
export -f install_language_tools install_languages