#!/bin/bash
# 🖥️ System Installation Module - OS-specific package installation
# Handles system dependencies, package managers, and OS-specific setup

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/install-utils.sh"

# 📦 Install system dependencies based on OS
install_system_dependencies() {
    log_header "Installing System Dependencies for $DISTRO"
    
    local packages="${OS_PACKAGES[$OS]}"
    if [[ -z "$packages" ]]; then
        log_error "No package list defined for OS: $OS"
        return 1
    fi
    
    case $OS in
        "arch")
            install_arch_packages "$packages"
            ;;
        "debian")
            install_debian_packages "$packages"
            ;;
        "fedora")
            install_fedora_packages "$packages"
            ;;
        "rhel")
            install_rhel_packages "$packages"
            ;;
        "opensuse")
            install_opensuse_packages "$packages"
            ;;
        "macos")
            install_macos_packages "$packages"
            ;;
        *)
            log_error "Unsupported operating system: $OS"
            return 1
            ;;
    esac
    
    log_success "System dependencies installed successfully"
}

# 🏗️ Arch Linux installation
install_arch_packages() {
    local packages="$1"
    
    log_info "Updating package database..."
    sudo pacman -Syu --noconfirm
    
    log_info "Installing packages: $packages"
    sudo pacman -S --needed --noconfirm $packages
    
    # Install Neovide for enhanced UI
    if [[ "$INSTALL_NEOVIDE" == "true" ]] && ! command -v neovide &> /dev/null; then
        log_info "Installing Neovide for GPU-accelerated UI..."
        if ! sudo pacman -S --needed --noconfirm neovide; then
            log_warning "Neovide not available in repos, trying AUR..."
            install_from_aur "neovide"
        fi
    fi
}

# 🐧 Debian/Ubuntu installation
install_debian_packages() {
    local packages="$1"
    
    log_info "Updating package database..."
    sudo apt update
    
    log_info "Installing packages: $packages"
    sudo apt install -y $packages
    
    # Install additional tools
    sudo npm install -g tree-sitter-cli
    
    # Install luarocks if not available
    if ! command -v luarocks &> /dev/null; then
        sudo apt install -y luarocks
    fi
    
    # Install Neovide
    if [[ "$INSTALL_NEOVIDE" == "true" ]] && ! command -v neovide &> /dev/null; then
        install_neovide_from_releases
    fi
}

# 🎩 Fedora installation
install_fedora_packages() {
    local packages="$1"
    
    log_info "Updating package database..."
    sudo dnf update -y
    
    log_info "Installing packages: $packages"
    sudo dnf install -y $packages
    
    sudo npm install -g tree-sitter-cli
    
    if ! command -v luarocks &> /dev/null; then
        sudo dnf install -y luarocks
    fi
    
    if [[ "$INSTALL_NEOVIDE" == "true" ]] && ! command -v neovide &> /dev/null; then
        install_neovide_from_releases
    fi
}

# 🎯 RHEL/CentOS installation
install_rhel_packages() {
    local packages="$1"
    
    log_info "Updating package database..."
    sudo yum update -y
    sudo yum groupinstall -y "Development Tools"
    
    log_info "Installing packages: $packages"
    sudo yum install -y $packages
    
    # Install tools from GitHub releases
    install_tool_from_github "ripgrep" "BurntSushi/ripgrep" "ripgrep-.*-x86_64-unknown-linux-musl.tar.gz"
    install_tool_from_github "fd" "sharkdp/fd" "fd-.*-x86_64-unknown-linux-musl.tar.gz"
    
    # Install Rust if not available
    if ! command -v rustc &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    
    sudo npm install -g tree-sitter-cli
}

# 🦎 openSUSE installation
install_opensuse_packages() {
    local packages="$1"
    
    log_info "Updating package database..."
    sudo zypper refresh
    
    log_info "Installing packages: $packages"
    sudo zypper install -y $packages
    
    sudo npm install -g tree-sitter-cli
}

# 🍎 macOS installation
install_macos_packages() {
    local packages="$1"
    
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
    
    log_info "Updating Homebrew..."
    brew update
    
    log_info "Installing packages: $packages"
    brew install $packages
}

# 🏗️ AUR installation helper
install_from_aur() {
    local package="$1"
    
    if command -v yay &> /dev/null; then
        yay -S --noconfirm "$package"
    elif command -v paru &> /dev/null; then
        paru -S --noconfirm "$package"
    else
        log_warning "No AUR helper found. Install $package manually if desired."
        log_info "Manual install: yay -S $package or paru -S $package"
    fi
}

# 📥 Install tool from GitHub releases
install_tool_from_github() {
    local tool_name="$1"
    local repo="$2"
    local pattern="$3"
    
    log_info "Installing $tool_name from GitHub releases..."
    
    local version=$(curl -s "$GITHUB_RELEASES_API/$repo/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
    local download_url=$(curl -s "$GITHUB_RELEASES_API/$repo/releases/latest" | grep -Po '"browser_download_url": "\K.*?(?=")' | grep "$pattern" | head -n1)
    
    if [[ -n "$download_url" ]]; then
        local temp_file="/tmp/${tool_name}.tar.gz"
        curl -L "$download_url" -o "$temp_file"
        tar xf "$temp_file" -C /tmp/
        
        # Find the binary and install it
        local binary_path=$(find /tmp -name "$tool_name" -type f -executable | head -n1)
        if [[ -n "$binary_path" ]]; then
            sudo cp "$binary_path" /usr/local/bin/
            log_success "$tool_name installed successfully"
        else
            log_error "Could not find $tool_name binary in archive"
        fi
        
        rm -f "$temp_file"
        rm -rf "/tmp/${tool_name}-"*
    else
        log_error "Could not find download URL for $tool_name"
    fi
}

# 🖥️ Install Neovide from releases
install_neovide_from_releases() {
    log_info "Installing Neovide from GitHub releases..."
    
    local version=$(curl -s "$GITHUB_RELEASES_API/neovide/neovide/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
    local download_url
    
    case "$OS" in
        "debian"|"fedora"|"rhel"|"opensuse")
            download_url=$(curl -s "$GITHUB_RELEASES_API/neovide/neovide/releases/latest" | grep -Po '"browser_download_url": "\K.*?(?=")' | grep "linux" | head -n1)
            ;;
        "macos")
            download_url=$(curl -s "$GITHUB_RELEASES_API/neovide/neovide/releases/latest" | grep -Po '"browser_download_url": "\K.*?(?=")' | grep "macos" | head -n1)
            ;;
    esac
    
    if [[ -n "$download_url" ]]; then
        local temp_file="/tmp/neovide"
        curl -L "$download_url" -o "$temp_file"
        chmod +x "$temp_file"
        sudo mv "$temp_file" /usr/local/bin/neovide
        log_success "Neovide installed successfully"
    else
        log_warning "Could not install Neovide from releases"
    fi
}

# 🔧 Install additional development tools
install_additional_tools() {
    log_info "Installing additional development tools..."
    
    case $OS in
        "arch")
            sudo pacman -S --needed --noconfirm \
                shellcheck shfmt stylua prettier yamllint hadolint 2>/dev/null || true
            ;;
        "debian")
            sudo apt install -y shellcheck yamllint 2>/dev/null || true
            ;;
        "fedora"|"rhel")
            sudo dnf install -y ShellCheck yamllint 2>/dev/null || true
            ;;
        "macos")
            brew install shellcheck shfmt stylua yamllint hadolint 2>/dev/null || true
            ;;
    esac
    
    # Install Go tools if Go is available
    if command -v go &> /dev/null; then
        log_info "Installing Go development tools..."
        go install golang.org/x/tools/gopls@latest 2>/dev/null || true
        go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest 2>/dev/null || true
    fi
    
    log_success "Additional tools installed successfully"
}

# 🔍 Verify system installation
verify_system_installation() {
    log_info "Verifying system installation..."
    
    local essential_tools=("git" "node" "python3" "gcc" "make" "rg" "fd")
    local failed_tools=()
    
    for tool in "${essential_tools[@]}"; do
        if ! verify_installation "$tool" "$tool"; then
            failed_tools+=("$tool")
        fi
    done
    
    if [[ ${#failed_tools[@]} -eq 0 ]]; then
        log_success "All essential tools installed successfully"
        return 0
    else
        log_error "Failed to install: ${failed_tools[*]}"
        return 1
    fi
}

# 🚀 Main system installation function
install_system() {
    log_header "System Installation Module"
    
    detect_os
    detect_environment
    check_requirements
    
    install_system_dependencies
    install_additional_tools
    verify_system_installation
    
    log_success "System installation completed successfully"
}

# Export functions
export -f install_system_dependencies install_additional_tools verify_system_installation install_system