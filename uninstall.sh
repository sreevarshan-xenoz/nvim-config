#!/bin/bash
# 🗑️ Elite Neovim Uninstaller
# Safely removes the Elite Neovim configuration and optionally cleans up dependencies

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

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
    echo -e "${PURPLE}🗑️  $1${NC}"
    echo -e "${PURPLE}$(printf '=%.0s' {1..50})${NC}"
}

# Confirm uninstallation
confirm_uninstall() {
    log_header "Elite Neovim Uninstaller"
    echo ""
    log_warning "This will remove your Elite Neovim configuration."
    log_info "Your original Neovim config backup (if any) will be restored."
    echo ""
    
    read -p "Are you sure you want to uninstall? (y/N): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Uninstallation cancelled."
        exit 0
    fi
}

# Remove Neovim configuration
remove_config() {
    log_info "Removing Neovim configuration..."
    
    if [ -d "$HOME/.config/nvim" ]; then
        # Create a final backup before removal
        local backup_dir="$HOME/.config/nvim.removed.$(date +%Y%m%d_%H%M%S)"
        mv "$HOME/.config/nvim" "$backup_dir"
        log_success "Configuration backed up to: $backup_dir"
        
        # Restore original backup if it exists
        local latest_backup=$(find "$HOME/.config" -maxdepth 1 -name "nvim.backup.*" -type d | sort | tail -n1)
        if [ -n "$latest_backup" ] && [ -d "$latest_backup" ]; then
            log_info "Restoring original configuration from: $latest_backup"
            mv "$latest_backup" "$HOME/.config/nvim"
            log_success "Original configuration restored"
        else
            log_info "No original backup found. Neovim config directory removed."
        fi
    else
        log_warning "Neovim configuration directory not found"
    fi
}

# Remove plugin data
remove_plugin_data() {
    log_info "Removing plugin data..."
    
    local data_dirs=(
        "$HOME/.local/share/nvim"
        "$HOME/.local/state/nvim"
        "$HOME/.cache/nvim"
    )
    
    for dir in "${data_dirs[@]}"; do
        if [ -d "$dir" ]; then
            rm -rf "$dir"
            log_success "Removed: $dir"
        fi
    done
}

# Remove language servers and tools (optional)
remove_language_servers() {
    log_info "Do you want to remove language servers and development tools? (y/N): "
    read -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Removing language servers and tools..."
        
        # Remove Mason installations
        if [ -d "$HOME/.local/share/nvim/mason" ]; then
            rm -rf "$HOME/.local/share/nvim/mason"
            log_success "Removed Mason language servers"
        fi
        
        # Remove global npm packages (optional)
        log_info "Remove global npm packages installed for Neovim? (y/N): "
        read -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            local npm_packages=(
                "neovim"
                "typescript"
                "typescript-language-server"
                "prettier"
                "eslint"
                "@typescript-eslint/parser"
                "@typescript-eslint/eslint-plugin"
                "vscode-langservers-extracted"
                "yaml-language-server"
                "dockerfile-language-server-nodejs"
                "bash-language-server"
                "vim-language-server"
                "tree-sitter-cli"
            )
            
            for package in "${npm_packages[@]}"; do
                if npm list -g "$package" &>/dev/null; then
                    npm uninstall -g "$package" 2>/dev/null || log_warning "Failed to remove $package"
                    log_success "Removed npm package: $package"
                fi
            done
        fi
        
        # Remove Python packages (optional)
        log_info "Remove Python packages installed for Neovim? (y/N): "
        read -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            local python_packages=(
                "pynvim"
                "debugpy"
                "black"
                "flake8"
                "mypy"
                "isort"
                "autopep8"
                "pylint"
                "bandit"
                "safety"
            )
            
            local pip_cmd="pip3"
            if ! command -v pip3 &>/dev/null; then
                pip_cmd="pip"
            fi
            
            for package in "${python_packages[@]}"; do
                if $pip_cmd show "$package" &>/dev/null; then
                    $pip_cmd uninstall "$package" -y 2>/dev/null || log_warning "Failed to remove $package"
                    log_success "Removed Python package: $package"
                fi
            done
        fi
        
        # Remove Rust components (optional)
        if command -v rustup &>/dev/null; then
            log_info "Remove Rust components installed for Neovim? (y/N): "
            read -n 1 -r
            echo ""
            
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rustup component remove rust-analyzer 2>/dev/null || log_warning "rust-analyzer not installed via rustup"
                log_success "Removed Rust components"
            fi
        fi
    fi
}

# Clean up temporary files
cleanup_temp_files() {
    log_info "Cleaning up temporary files..."
    
    local temp_files=(
        "/tmp/nvim-health*.txt"
        "/tmp/nvim-startup*.log"
        "$HOME/.cache/nvim"
    )
    
    for pattern in "${temp_files[@]}"; do
        rm -f $pattern 2>/dev/null || true
    done
    
    log_success "Temporary files cleaned up"
}

# Remove repository clone (if exists)
remove_repository() {
    if [ -d "$HOME/.config/nvim-elite" ]; then
        log_info "Remove cloned repository? (y/N): "
        read -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$HOME/.config/nvim-elite"
            log_success "Repository removed"
        fi
    fi
}

# Main uninstall function
main() {
    confirm_uninstall
    echo ""
    
    remove_config
    echo ""
    
    remove_plugin_data
    echo ""
    
    remove_language_servers
    echo ""
    
    cleanup_temp_files
    echo ""
    
    remove_repository
    echo ""
    
    log_header "Uninstallation Complete"
    echo ""
    
    log_success "Elite Neovim configuration has been removed successfully!"
    echo ""
    
    log_info "What was removed:"
    echo "  • Neovim configuration (~/.config/nvim)"
    echo "  • Plugin data (~/.local/share/nvim)"
    echo "  • Cache files (~/.cache/nvim)"
    echo "  • State files (~/.local/state/nvim)"
    echo ""
    
    log_info "What was preserved:"
    echo "  • System packages (git, nodejs, python, etc.)"
    echo "  • Neovim binary (if you want to remove it, use your package manager)"
    echo "  • Configuration backup (if restoration was not possible)"
    echo ""
    
    log_info "To completely remove Neovim:"
    echo "  Arch Linux: sudo pacman -R neovim"
    echo "  Ubuntu/Debian: sudo apt remove neovim"
    echo "  macOS: brew uninstall neovim"
    echo "  Fedora: sudo dnf remove neovim"
    echo ""
    
    log_info "Thank you for trying Elite Neovim! 👋"
}

# Run uninstaller
main "$@"