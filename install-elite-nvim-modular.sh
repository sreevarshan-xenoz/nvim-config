#!/bin/bash
# 🚀 Elite Neovim Modular Installer - LunarVim-inspired Beast Mode
# Modular architecture with configurable components and <100ms startup
# Version: 2.0.0 - Complete rewrite with modular design

set -e

# 📁 Script directory and module loading
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

# 🔧 Load core modules
if [[ -f "$SCRIPTS_DIR/install-config.sh" ]]; then
    source "$SCRIPTS_DIR/install-config.sh"
else
    echo "❌ Configuration module not found. Please ensure scripts/install-config.sh exists."
    exit 1
fi

if [[ -f "$SCRIPTS_DIR/install-utils.sh" ]]; then
    source "$SCRIPTS_DIR/install-utils.sh"
else
    echo "❌ Utilities module not found. Please ensure scripts/install-utils.sh exists."
    exit 1
fi

# 🎯 Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_help
                exit 0
                ;;
            --config|-c)
                CONFIG_FILE="$2"
                shift 2
                ;;
            --mode|-m)
                INSTALL_MODE="$2"
                shift 2
                ;;
            --skip-confirmation)
                SKIP_CONFIRMATION=true
                shift
                ;;
            --enable-module)
                enable_module "$2"
                shift 2
                ;;
            --disable-module)
                disable_module "$2"
                shift 2
                ;;
            --list-modules)
                list_modules
                exit 0
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --verbose|-v)
                LOG_LEVEL="DEBUG"
                shift
                ;;
            --quiet|-q)
                LOG_LEVEL="ERROR"
                shift
                ;;
            --no-ai)
                disable_module "ai"
                shift
                ;;
            --no-debug)
                disable_module "debug"
                shift
                ;;
            --minimal)
                # Minimal installation - only core modules
                for module in "${!MODULE_ENABLED[@]}"; do
                    if [[ "$module" != "core" && "$module" != "ui" && "$module" != "lsp" ]]; then
                        disable_module "$module"
                    fi
                done
                shift
                ;;
            --full)
                # Full installation - enable all modules
                for module in "${!MODULE_ENABLED[@]}"; do
                    enable_module "$module"
                done
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# 📖 Show help information
show_help() {
    cat << EOF
🚀 Elite Neovim Modular Installer v2.0.0
========================================

A modular, high-performance Neovim configuration installer with LunarVim-inspired
architecture, supporting 60+ plugins with <100ms startup time.

USAGE:
    $0 [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    -c, --config FILE       Use custom configuration file
    -m, --mode MODE         Installation mode (minimal|standard|full|beast|lunar)
    --skip-confirmation     Skip all confirmation prompts
    --enable-module MODULE  Enable specific module
    --disable-module MODULE Disable specific module
    --list-modules          List all available modules
    --dry-run              Show what would be installed without doing it
    -v, --verbose          Enable verbose logging
    -q, --quiet            Quiet mode (errors only)
    --no-ai                Disable AI modules (Copilot, ChatGPT, ByteBot)
    --no-debug             Disable debugging modules
    --minimal              Install only core modules (core, ui, lsp)
    --full                 Install all available modules

INSTALLATION MODES:
    minimal     Core functionality only (~30 plugins, <80ms startup)
    standard    Balanced setup (~45 plugins, <120ms startup)
    full        All features (~60 plugins, <150ms startup)
    beast       Beast mode with optimizations (~65 plugins, <150ms startup)
    lunar       LunarVim-inspired mode (~70 plugins, <100ms startup)

MODULES:
EOF
    
    for module in "${!MODULES[@]}"; do
        local status="${MODULE_ENABLED[$module]}"
        local icon="❌"
        [[ "$status" == "true" ]] && icon="✅"
        printf "    %s %-12s %s\\n" "$icon" "$module" "${MODULES[$module]}"
    done
    
    cat << EOF

EXAMPLES:
    # Standard installation
    $0
    
    # Minimal setup for low-end systems
    $0 --minimal
    
    # Full setup with all features
    $0 --full
    
    # Custom setup without AI
    $0 --no-ai --disable-module debug
    
    # LunarVim mode with verbose output
    $0 --mode lunar --verbose
    
    # Dry run to see what would be installed
    $0 --dry-run --full

For more information, visit: https://github.com/sreevarshan-xenoz/nvim-config
EOF
}

# 🎯 Set installation mode
set_installation_mode() {
    local mode="${INSTALL_MODE:-standard}"
    
    log_info "Setting installation mode: $mode"
    
    case "$mode" in
        "minimal")
            # Only core essentials
            for module in "${!MODULE_ENABLED[@]}"; do
                if [[ "$module" != "core" && "$module" != "ui" && "$module" != "lsp" ]]; then
                    disable_module "$module"
                fi
            done
            STARTUP_TARGET=$STARTUP_TARGET_MS
            ;;
        "standard")
            # Balanced setup
            disable_module "debug"
            disable_module "ai"
            STARTUP_TARGET=$STANDARD_TARGET_MS
            ;;
        "full")
            # All features
            for module in "${!MODULE_ENABLED[@]}"; do
                enable_module "$module"
            done
            STARTUP_TARGET=$BEAST_TARGET_MS
            ;;
        "beast")
            # Beast mode optimizations
            for module in "${!MODULE_ENABLED[@]}"; do
                enable_module "$module"
            done
            ENABLE_PROFILING=true
            STARTUP_TARGET=$BEAST_TARGET_MS
            ;;
        "lunar")
            # LunarVim-inspired mode
            for module in "${!MODULE_ENABLED[@]}"; do
                enable_module "$module"
            done
            INSTALL_LUNARVIM=true
            STARTUP_TARGET=$STARTUP_TARGET_MS
            ;;
        *)
            log_warning "Unknown mode: $mode, using standard"
            set_installation_mode "standard"
            ;;
    esac
    
    log_info "Target startup time: <${STARTUP_TARGET}ms"
}

# 🔍 Pre-installation checks
run_pre_checks() {
    log_header "Pre-Installation System Check"
    
    detect_os
    detect_environment
    check_requirements
    
    # Show installation summary
    log_info "Installation Summary:"
    log_info "  OS: $DISTRO ($OS)"
    log_info "  Mode: ${INSTALL_MODE:-standard}"
    log_info "  Target: <${STARTUP_TARGET}ms startup"
    
    if [[ "$HYPRLAND_DETECTED" == "true" ]]; then
        log_info "  Hyprland: Theme sync enabled"
    fi
    
    if [[ "$NEOVIDE_DETECTED" == "true" ]]; then
        log_info "  Neovide: GPU acceleration available"
    fi
    
    log_info "  Enabled modules:"
    for module in "${!MODULE_ENABLED[@]}"; do
        if [[ "${MODULE_ENABLED[$module]}" == "true" ]]; then
            log_info "    ✅ $module"
        fi
    done
    
    # Confirmation prompt
    if [[ "$SKIP_CONFIRMATION" != "true" && "$DRY_RUN" != "true" ]]; then
        echo ""
        read -p "Continue with installation? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Installation cancelled by user."
            exit 0
        fi
    fi
}

# 🏗️ Main installation orchestrator
run_installation() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log_header "DRY RUN - No changes will be made"
        return 0
    fi
    
    log_header "Starting Elite Neovim Installation"
    
    # Create necessary directories
    create_directories
    
    # Backup existing configuration
    backup_existing_config
    
    # Load and run installation modules
    local modules_to_run=()
    
    # System dependencies (always required)
    modules_to_run+=("system")
    
    # Language packages (if languages module enabled)
    if is_module_enabled "languages"; then
        modules_to_run+=("languages")
    fi
    
    # Neovim installation and configuration
    modules_to_run+=("neovim")
    
    # Plugin installation
    modules_to_run+=("plugins")
    
    # Additional features
    if [[ "$INSTALL_BYTEBOT" == "true" ]]; then
        modules_to_run+=("bytebot")
    fi
    
    if [[ "$INSTALL_LUNARVIM" == "true" ]]; then
        modules_to_run+=("lunarvim")
    fi
    
    # Run each module
    local total=${#modules_to_run[@]}
    local current=0
    
    for module in "${modules_to_run[@]}"; do
        ((current++))
        show_progress $current $total "Installing $module module"
        
        case "$module" in
            "system")
                source "$SCRIPTS_DIR/install-system.sh"
                install_system
                ;;
            "languages")
                source "$SCRIPTS_DIR/install-languages.sh"
                install_languages
                ;;
            "neovim")
                install_neovim_and_config
                ;;
            "plugins")
                install_plugins_and_tools
                ;;
            "bytebot")
                setup_bytebot_integration
                ;;
            "lunarvim")
                setup_lunarvim_features
                ;;
        esac
    done
    
    echo "" # New line after progress
}

# 🔧 Install Neovim and configuration
install_neovim_and_config() {
    log_header "Installing Neovim and Configuration"
    
    # Install/update Neovim
    install_neovim_binary
    
    # Copy configuration files
    copy_configuration_files
    
    log_success "Neovim and configuration installed"
}

# 📦 Install Neovim binary
install_neovim_binary() {
    log_info "Installing/updating Neovim..."
    
    if command -v nvim &> /dev/null; then
        local nvim_version=$(nvim --version | head -n1 | grep -oP 'v\K[0-9]+\.[0-9]+')
        log_info "Found Neovim version: $nvim_version"
        
        # Check if version is 0.9.0 or higher
        if [[ $(echo "$nvim_version >= 0.9" | bc -l 2>/dev/null || echo "0") -eq 1 ]]; then
            log_success "Neovim version is compatible"
            return 0
        else
            log_warning "Neovim version $nvim_version is too old. Need 0.9.0+"
        fi
    fi
    
    case $OS in
        "arch")
            sudo pacman -S --needed --noconfirm neovim
            ;;
        "debian")
            # Install from PPA for latest version
            sudo add-apt-repository ppa:neovim-ppa/unstable -y
            sudo apt update
            sudo apt install -y neovim
            ;;
        "fedora")
            sudo dnf install -y neovim
            ;;
        "rhel")
            # Install from GitHub releases
            install_tool_from_github "nvim" "neovim/neovim" "nvim-linux64.tar.gz"
            ;;
        "opensuse")
            sudo zypper install -y neovim
            ;;
        "macos")
            brew install neovim
            ;;
    esac
    
    verify_installation "Neovim" "nvim"
}

# 📁 Copy configuration files
copy_configuration_files() {
    log_info "Copying configuration files..."
    
    # Copy all Lua configuration
    if [[ -d "lua" ]]; then
        cp -r lua "$CONFIG_DIR/"
        log_success "Lua configuration copied"
    fi
    
    # Copy init.lua
    if [[ -f "init.lua" ]]; then
        cp init.lua "$CONFIG_DIR/"
        log_success "init.lua copied"
    fi
    
    # Set proper permissions
    chmod -R 755 "$CONFIG_DIR"
}

# 🔌 Install plugins and tools
install_plugins_and_tools() {
    log_header "Installing Plugins and Development Tools"
    
    # Bootstrap Lazy.nvim and install plugins
    log_info "Bootstrapping Lazy.nvim and installing plugins..."
    if run_with_timeout 300 "Plugin installation" nvim --headless "+Lazy! sync" +qa; then
        log_success "Plugins installed successfully"
    else
        log_warning "Plugin installation had issues. Run :Lazy sync manually."
    fi
    
    # Install language servers
    log_info "Installing language servers with Mason..."
    local servers_cmd="MasonInstall $(printf '%s ' "${LANGUAGE_SERVERS[@]}")"
    if run_with_timeout 300 "Language servers" nvim --headless "+$servers_cmd" +qa; then
        log_success "Language servers installed"
    else
        log_warning "Some language servers may not have installed. Check :Mason"
    fi
    
    # Install Treesitter parsers
    log_info "Installing Treesitter parsers..."
    local parsers_cmd="TSInstall $(printf '%s ' "${TREESITTER_PARSERS[@]}")"
    if run_with_timeout 180 "Treesitter parsers" nvim --headless "+$parsers_cmd" +qa; then
        log_success "Treesitter parsers installed"
    else
        log_warning "Some parsers may not have installed. Check :TSInstall"
    fi
}

# 🤖 Setup ByteBot integration
setup_bytebot_integration() {
    log_header "Setting up ByteBot Integration"
    
    log_info "ByteBot will be available on $BYTEBOT_ENDPOINT"
    log_info "You can run your own ByteBot container or service"
    
    # Test ByteBot connection
    if curl -s --connect-timeout 5 "$BYTEBOT_ENDPOINT/health" &>/dev/null; then
        log_success "ByteBot service detected and ready!"
    else
        log_warning "ByteBot service not running. Start it manually when needed."
    fi
    
    # Create ByteBot helper script
    cat > "$SCRIPTS_DIR/bytebot-test" << 'EOF'
#!/bin/bash
# Test ByteBot connection
echo "Testing ByteBot connection..."
if curl -s --connect-timeout 5 http://localhost:9991/health; then
    echo "✅ ByteBot is ready!"
else
    echo "❌ ByteBot not available. Start your ByteBot service first."
fi
EOF
    chmod +x "$SCRIPTS_DIR/bytebot-test"
    log_success "ByteBot test script created: $SCRIPTS_DIR/bytebot-test"
}

# 🌙 Setup LunarVim features
setup_lunarvim_features() {
    log_header "Setting up LunarVim-inspired Features"
    
    # Test LunarVim module loading
    if run_with_timeout 15 "LunarVim modules" nvim --headless -c "lua require('lvim')" +qa; then
        log_success "LunarVim modules loaded successfully"
    else
        log_warning "LunarVim modules may have loading issues"
    fi
    
    # Create LunarVim status script
    cat > "$SCRIPTS_DIR/lvim-status" << 'EOF'
#!/bin/bash
# LunarVim status checker
echo "🌙 LunarVim Status Check"
echo "======================="
nvim --headless "+LvimModules" +qa 2>/dev/null || echo "❌ LunarVim modules not loaded"
nvim --headless -c "lua require('lvim.ai').check_ai_status()" +qa 2>/dev/null || echo "❌ AI status check failed"
echo "✅ Status check complete"
EOF
    chmod +x "$SCRIPTS_DIR/lvim-status"
    log_success "LunarVim status script created: $SCRIPTS_DIR/lvim-status"
}

# 🏥 Post-installation verification
run_post_verification() {
    log_header "Post-Installation Verification"
    
    # Basic Neovim functionality
    if run_with_timeout 10 "Neovim basic test" nvim --headless +qa; then
        log_success "Neovim basic functionality working"
    else
        log_error "Neovim basic functionality failed"
        return 1
    fi
    
    # Configuration loading
    if run_with_timeout 15 "Configuration loading" nvim --headless -c "lua print('Config loaded')" +qa; then
        log_success "Configuration loads without errors"
    else
        log_error "Configuration has loading errors"
        return 1
    fi
    
    # Measure startup time
    measure_startup_time "$STARTUP_TARGET" "${INSTALL_MODE:-standard}"
    
    # Run health check if enabled
    if [[ "$ENABLE_HEALTH_CHECK" == "true" ]]; then
        log_info "Running comprehensive health check..."
        local health_file="/tmp/nvim-health-$(date +%s).txt"
        if run_with_timeout 60 "Health check" nvim --headless "+checkhealth" "+write $health_file" +qa; then
            if [ -f "$health_file" ]; then
                local errors=$(grep -c "ERROR" "$health_file" 2>/dev/null || echo "0")
                if [ "$errors" -eq 0 ]; then
                    log_success "Health check passed with no errors"
                else
                    log_warning "Health check found $errors errors. Check $health_file"
                fi
            fi
        else
            log_warning "Health check timed out or failed"
        fi
    fi
    
    log_success "Post-installation verification completed"
}

# 📊 Show completion summary
show_completion_summary() {
    log_header "Installation Complete!"
    
    echo ""
    log_success "🎉 Elite Neovim installation completed successfully!"
    echo ""
    
    log_info "📊 Installation Summary:"
    log_info "  • Mode: ${INSTALL_MODE:-standard}"
    log_info "  • Target: <${STARTUP_TARGET}ms startup"
    log_info "  • OS: $DISTRO"
    
    local enabled_count=0
    for module in "${!MODULE_ENABLED[@]}"; do
        if [[ "${MODULE_ENABLED[$module]}" == "true" ]]; then
            ((enabled_count++))
        fi
    done
    log_info "  • Modules: $enabled_count enabled"
    
    echo ""
    log_info "🚀 Next Steps:"
    echo "  1. Start Neovim: nvim"
    echo "  2. Check status: :Lazy (plugins) | :Mason (LSP) | :checkhealth"
    if [[ "$INSTALL_LUNARVIM" == "true" ]]; then
        echo "  3. LunarVim guide: :LvimKeymaps"
        echo "  4. Module status: :LvimModules"
    fi
    if [[ "$INSTALL_BYTEBOT" == "true" ]]; then
        echo "  5. Test ByteBot: $SCRIPTS_DIR/bytebot-test"
    fi
    echo ""
    
    log_info "🔑 Essential Keybindings:"
    echo "  • <leader> = Space"
    echo "  • <leader>ff = Find files | <leader>fg = Live grep"
    echo "  • <leader>gg = Git status | <leader>xx = Diagnostics"
    if [[ "$INSTALL_AI" == "true" ]]; then
        echo "  • Ctrl+J = Copilot accept | <leader>cc = ChatGPT"
    fi
    if [[ "$INSTALL_LUNARVIM" == "true" ]]; then
        echo "  • <leader>lk = LunarVim keymaps | <leader>lv = AI assistance"
    fi
    echo "  • s + 2chars = Flash jump | <leader>th = Cycle themes"
    echo ""
    
    log_info "🎨 Themes: tokyonight (default), catppuccin, gruvbox, onedarkpro"
    log_info "📚 Documentation: ~/.config/nvim/README.md"
    log_info "🔧 Logs: $LOG_FILE"
    
    echo ""
    log_success "Happy coding with your Elite Neovim setup! 🚀"
}

# 🚀 Main execution flow
main() {
    # Set up cleanup trap
    trap cleanup_on_exit EXIT
    
    # Parse command line arguments
    parse_arguments "$@"
    
    # Set installation mode
    set_installation_mode
    
    # Run pre-installation checks
    run_pre_checks
    
    # Run the installation
    run_installation
    
    # Verify installation
    if [[ "$ENABLE_VERIFICATION" == "true" && "$DRY_RUN" != "true" ]]; then
        run_post_verification
    fi
    
    # Show completion summary
    if [[ "$DRY_RUN" != "true" ]]; then
        show_completion_summary
    fi
}

# 🎯 Execute main function with all arguments
main "$@"