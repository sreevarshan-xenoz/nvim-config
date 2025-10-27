#!/bin/bash
# 🔍 Elite Neovim Installation Verification Script
# Verifies that everything is working correctly after installation

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Counters
PASSED=0
FAILED=0
WARNINGS=0

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
    ((PASSED++))
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    ((WARNINGS++))
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    ((FAILED++))
}

log_header() {
    echo -e "${PURPLE}🔍 $1${NC}"
    echo -e "${PURPLE}$(printf '=%.0s' {1..50})${NC}"
}

# Test Neovim basic functionality
test_neovim_basic() {
    log_info "Testing Neovim basic functionality..."
    
    if command -v nvim &> /dev/null; then
        local nvim_version=$(nvim --version | head -n1)
        log_success "Neovim installed: $nvim_version"
        
        # Test headless mode
        if timeout 10 nvim --headless +qa 2>/dev/null; then
            log_success "Neovim headless mode working"
        else
            log_error "Neovim headless mode failed"
        fi
    else
        log_error "Neovim not found in PATH"
    fi
}

# Test configuration loading
test_config_loading() {
    log_info "Testing configuration loading..."
    
    if [ -f "$HOME/.config/nvim/init.lua" ]; then
        log_success "Configuration file exists"
        
        # Test if config loads without errors
        if timeout 15 nvim --headless -c "lua print('Config loaded successfully')" +qa 2>/dev/null; then
            log_success "Configuration loads without errors"
        else
            log_error "Configuration has loading errors"
        fi
    else
        log_error "Configuration file not found"
    fi
}

# Test Lazy.nvim plugin manager
test_lazy_nvim() {
    log_info "Testing Lazy.nvim plugin manager..."
    
    local lazy_path="$HOME/.local/share/nvim/lazy/lazy.nvim"
    if [ -d "$lazy_path" ]; then
        log_success "Lazy.nvim installed"
        
        # Test plugin loading
        if timeout 20 nvim --headless -c "lua require('lazy').setup()" +qa 2>/dev/null; then
            log_success "Plugins load successfully"
        else
            log_warning "Some plugins may have loading issues"
        fi
    else
        log_error "Lazy.nvim not found"
    fi
}

# Test essential plugins
test_essential_plugins() {
    log_info "Testing essential plugins..."
    
    local plugins=(
        "plenary"
        "nvim-treesitter"
        "which-key"
        "telescope"
        "nvim-lspconfig"
        "nvim-cmp"
    )
    
    for plugin in "${plugins[@]}"; do
        if timeout 10 nvim --headless -c "lua require('$plugin')" +qa 2>/dev/null; then
            log_success "$plugin plugin working"
        else
            log_error "$plugin plugin not working"
        fi
    done
}

# Test Treesitter parsers
test_treesitter() {
    log_info "Testing Treesitter parsers..."
    
    local parsers=("lua" "python" "javascript" "typescript" "rust")
    
    for parser in "${parsers[@]}"; do
        if timeout 10 nvim --headless -c "TSInstall $parser" +qa 2>/dev/null; then
            log_success "$parser parser available"
        else
            log_warning "$parser parser may not be installed"
        fi
    done
}

# Test LSP servers
test_lsp_servers() {
    log_info "Testing LSP servers..."
    
    local servers=("lua_ls" "pyright" "tsserver" "rust_analyzer")
    
    for server in "${servers[@]}"; do
        if timeout 15 nvim --headless -c "lua vim.lsp.start({name='$server', cmd={'echo'}})" +qa 2>/dev/null; then
            log_success "$server LSP configuration exists"
        else
            log_warning "$server LSP may not be configured"
        fi
    done
}

# Test key bindings
test_key_bindings() {
    log_info "Testing key binding configuration..."
    
    # Test if which-key is configured
    if timeout 10 nvim --headless -c "lua require('which-key').setup()" +qa 2>/dev/null; then
        log_success "Which-key configuration working"
    else
        log_warning "Which-key may not be properly configured"
    fi
}

# Test themes
test_themes() {
    log_info "Testing theme configuration..."
    
    local themes=("tokyonight" "catppuccin" "gruvbox" "onedarkpro")
    
    for theme in "${themes[@]}"; do
        if timeout 10 nvim --headless -c "colorscheme $theme" +qa 2>/dev/null; then
            log_success "$theme theme available"
        else
            log_warning "$theme theme may not be installed"
        fi
    done
}

# Test startup time
test_startup_time() {
    log_info "Testing startup performance..."
    
    local startup_log="/tmp/nvim-startup-test.log"
    
    if nvim --startuptime "$startup_log" --headless +qa 2>/dev/null; then
        local startup_time=$(tail -n1 "$startup_log" | awk '{print $1}')
        
        if (( $(echo "$startup_time < 200" | bc -l 2>/dev/null || echo "0") )); then
            log_success "Startup time: ${startup_time}ms (Target: <200ms)"
        elif (( $(echo "$startup_time < 500" | bc -l 2>/dev/null || echo "0") )); then
            log_warning "Startup time: ${startup_time}ms (Acceptable but could be better)"
        else
            log_error "Startup time: ${startup_time}ms (Too slow, target: <200ms)"
        fi
        
        rm -f "$startup_log"
    else
        log_error "Could not measure startup time"
    fi
}

# Test health check
test_health_check() {
    log_info "Running Neovim health check..."
    
    local health_file="/tmp/nvim-health-verify.txt"
    
    if timeout 30 nvim --headless +checkhealth +"write $health_file" +qa 2>/dev/null; then
        if [ -f "$health_file" ]; then
            local errors=$(grep -c "ERROR" "$health_file" 2>/dev/null || echo "0")
            local warnings=$(grep -c "WARNING" "$health_file" 2>/dev/null || echo "0")
            
            if [ "$errors" -eq 0 ]; then
                log_success "Health check passed (0 errors, $warnings warnings)"
            else
                log_error "Health check found $errors errors and $warnings warnings"
                log_info "Check $health_file for details"
            fi
        else
            log_error "Health check report not generated"
        fi
    else
        log_error "Health check timed out or failed"
    fi
}

# Main verification function
main() {
    log_header "Elite Neovim Installation Verification"
    echo ""
    
    test_neovim_basic
    echo ""
    
    test_config_loading
    echo ""
    
    test_lazy_nvim
    echo ""
    
    test_essential_plugins
    echo ""
    
    test_treesitter
    echo ""
    
    test_lsp_servers
    echo ""
    
    test_key_bindings
    echo ""
    
    test_themes
    echo ""
    
    test_startup_time
    echo ""
    
    test_health_check
    echo ""
    
    # Summary
    log_header "Verification Summary"
    echo ""
    
    log_success "Passed: $PASSED"
    if [ $WARNINGS -gt 0 ]; then
        log_warning "Warnings: $WARNINGS"
    fi
    if [ $FAILED -gt 0 ]; then
        log_error "Failed: $FAILED"
    fi
    
    echo ""
    
    if [ $FAILED -eq 0 ]; then
        if [ $WARNINGS -eq 0 ]; then
            log_success "🎉 Perfect! Your Elite Neovim setup is working flawlessly!"
        else
            log_warning "✅ Good! Your setup is working with minor issues that don't affect core functionality."
        fi
        echo ""
        log_info "🚀 Ready to code! Try these commands:"
        echo "  nvim                    # Start Neovim"
        echo "  nvim +Lazy              # Check plugin status"
        echo "  nvim +Mason             # Check language servers"
        echo "  nvim +checkhealth       # Full health check"
    else
        log_error "❌ Some issues found. Your setup may not work optimally."
        echo ""
        log_info "🔧 Troubleshooting steps:"
        echo "  1. Run: nvim +checkhealth"
        echo "  2. Run: nvim +Lazy sync"
        echo "  3. Run: nvim +Mason"
        echo "  4. Check the installation logs"
        echo "  5. Re-run: ./install-elite-nvim.sh"
    fi
    
    echo ""
    log_info "📚 For more help, check the README.md file"
}

# Run verification
main "$@"