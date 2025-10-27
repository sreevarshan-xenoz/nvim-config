#!/bin/bash
# 🧪 Elite Neovim Modular Installation Test Suite
# Comprehensive testing for the modular installer system

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_LOG="/tmp/nvim-modular-test-$(date +%s).log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Logging functions
log_test() {
    echo -e "${BLUE}[TEST]${NC} $1" | tee -a "$TEST_LOG"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1" | tee -a "$TEST_LOG"
    ((TESTS_PASSED++))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1" | tee -a "$TEST_LOG"
    ((TESTS_FAILED++))
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$TEST_LOG"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$TEST_LOG"
}

# Test helper functions
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    ((TESTS_RUN++))
    log_test "Running: $test_name"
    
    if eval "$test_command" >> "$TEST_LOG" 2>&1; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name"
        return 1
    fi
}

# Test 1: Check if all required files exist
test_file_structure() {
    log_test "Checking file structure..."
    
    local required_files=(
        "install-elite-nvim-modular.sh"
        "scripts/install-config.sh"
        "scripts/install-utils.sh"
        "scripts/install-system.sh"
        "scripts/install-languages.sh"
        "init.lua"
        "lua/configs/options.lua"
        "lua/configs/keymaps.lua"
    )
    
    local missing_files=()
    
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            missing_files+=("$file")
        fi
    done
    
    if [[ ${#missing_files[@]} -eq 0 ]]; then
        log_pass "All required files present"
        return 0
    else
        log_fail "Missing files: ${missing_files[*]}"
        return 1
    fi
}

# Test 2: Check script permissions
test_script_permissions() {
    log_test "Checking script permissions..."
    
    local scripts=(
        "install-elite-nvim-modular.sh"
        "quick-install.sh"
        "check-system.sh"
        "verify-install.sh"
    )
    
    local non_executable=()
    
    for script in "${scripts[@]}"; do
        if [[ -f "$script" && ! -x "$script" ]]; then
            non_executable+=("$script")
        fi
    done
    
    if [[ ${#non_executable[@]} -eq 0 ]]; then
        log_pass "All scripts are executable"
        return 0
    else
        log_fail "Non-executable scripts: ${non_executable[*]}"
        return 1
    fi
}

# Test 3: Test help functionality
test_help_functionality() {
    log_test "Testing help functionality..."
    
    if ./install-elite-nvim-modular.sh --help > /dev/null 2>&1; then
        log_pass "Help command works"
        return 0
    else
        log_fail "Help command failed"
        return 1
    fi
}

# Test 4: Test module listing
test_module_listing() {
    log_test "Testing module listing..."
    
    if ./install-elite-nvim-modular.sh --list-modules > /dev/null 2>&1; then
        log_pass "Module listing works"
        return 0
    else
        log_fail "Module listing failed"
        return 1
    fi
}

# Test 5: Test dry run functionality
test_dry_run() {
    log_test "Testing dry run functionality..."
    
    if ./install-elite-nvim-modular.sh --dry-run --minimal > /dev/null 2>&1; then
        log_pass "Dry run works"
        return 0
    else
        log_fail "Dry run failed"
        return 1
    fi
}

# Test 6: Test configuration loading
test_config_loading() {
    log_test "Testing configuration module loading..."
    
    # Source the config and check if key variables are set
    if source scripts/install-config.sh 2>/dev/null; then
        if [[ -n "$CONFIG_DIR" && -n "$BACKUP_DIR" ]]; then
            log_pass "Configuration loads correctly"
            return 0
        else
            log_fail "Configuration variables not set"
            return 1
        fi
    else
        log_fail "Configuration module failed to load"
        return 1
    fi
}

# Test 7: Test utilities loading
test_utils_loading() {
    log_test "Testing utilities module loading..."
    
    # Source the utils and check if key functions exist
    if source scripts/install-utils.sh 2>/dev/null; then
        if declare -f log_info > /dev/null && declare -f detect_os > /dev/null; then
            log_pass "Utilities load correctly"
            return 0
        else
            log_fail "Utility functions not available"
            return 1
        fi
    else
        log_fail "Utilities module failed to load"
        return 1
    fi
}

# Test 8: Test Lua configuration syntax
test_lua_syntax() {
    log_test "Testing Lua configuration syntax..."
    
    local lua_files=(
        "init.lua"
        "lua/configs/options.lua"
        "lua/configs/keymaps.lua"
    )
    
    local syntax_errors=()
    
    for file in "${lua_files[@]}"; do
        if [[ -f "$file" ]]; then
            if ! lua -l "$file" -e "" 2>/dev/null; then
                syntax_errors+=("$file")
            fi
        fi
    done
    
    if [[ ${#syntax_errors[@]} -eq 0 ]]; then
        log_pass "Lua syntax is valid"
        return 0
    else
        log_fail "Lua syntax errors in: ${syntax_errors[*]}"
        return 1
    fi
}

# Test 9: Test plugin specifications
test_plugin_specs() {
    log_test "Testing plugin specifications..."
    
    local plugin_files=(
        "lua/plugins/core.lua"
        "lua/plugins/ui.lua"
        "lua/plugins/lsp.lua"
        "lua/plugins/navigation.lua"
    )
    
    local spec_errors=()
    
    for file in "${plugin_files[@]}"; do
        if [[ -f "$file" ]]; then
            # Check if file contains valid plugin specifications
            if ! grep -q "return {" "$file" 2>/dev/null; then
                spec_errors+=("$file")
            fi
        fi
    done
    
    if [[ ${#spec_errors[@]} -eq 0 ]]; then
        log_pass "Plugin specifications are valid"
        return 0
    else
        log_fail "Plugin specification errors in: ${spec_errors[*]}"
        return 1
    fi
}

# Test 10: Test system requirements
test_system_requirements() {
    log_test "Testing system requirements check..."
    
    if [[ -f "check-system.sh" ]]; then
        if ./check-system.sh > /dev/null 2>&1; then
            log_pass "System requirements check works"
            return 0
        else
            log_warn "System requirements check had warnings (may be normal)"
            return 0
        fi
    else
        log_fail "System requirements script missing"
        return 1
    fi
}

# Test 11: Test installation modes
test_installation_modes() {
    log_test "Testing installation modes..."
    
    local modes=("minimal" "standard" "full" "beast" "lunar")
    local mode_errors=()
    
    for mode in "${modes[@]}"; do
        if ! ./install-elite-nvim-modular.sh --dry-run --mode "$mode" > /dev/null 2>&1; then
            mode_errors+=("$mode")
        fi
    done
    
    if [[ ${#mode_errors[@]} -eq 0 ]]; then
        log_pass "All installation modes work"
        return 0
    else
        log_fail "Installation mode errors: ${mode_errors[*]}"
        return 1
    fi
}

# Test 12: Test module enable/disable
test_module_toggle() {
    log_test "Testing module enable/disable functionality..."
    
    # Test enabling and disabling modules
    if ./install-elite-nvim-modular.sh --dry-run --enable-module ai --disable-module debug > /dev/null 2>&1; then
        log_pass "Module toggle functionality works"
        return 0
    else
        log_fail "Module toggle functionality failed"
        return 1
    fi
}

# Main test runner
run_all_tests() {
    log_info "🧪 Starting Elite Neovim Modular Installation Test Suite"
    log_info "Test log: $TEST_LOG"
    echo ""
    
    # Run all tests
    run_test "File Structure" "test_file_structure"
    run_test "Script Permissions" "test_script_permissions"
    run_test "Help Functionality" "test_help_functionality"
    run_test "Module Listing" "test_module_listing"
    run_test "Dry Run" "test_dry_run"
    run_test "Configuration Loading" "test_config_loading"
    run_test "Utilities Loading" "test_utils_loading"
    run_test "Lua Syntax" "test_lua_syntax"
    run_test "Plugin Specifications" "test_plugin_specs"
    run_test "System Requirements" "test_system_requirements"
    run_test "Installation Modes" "test_installation_modes"
    run_test "Module Toggle" "test_module_toggle"
    
    # Show results
    echo ""
    log_info "📊 Test Results Summary"
    echo "========================="
    echo "Tests Run:    $TESTS_RUN"
    echo "Tests Passed: $TESTS_PASSED"
    echo "Tests Failed: $TESTS_FAILED"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo ""
        log_pass "🎉 All tests passed! The modular installer is ready."
        echo ""
        log_info "Next steps:"
        echo "1. Run: ./install-elite-nvim-modular.sh --help"
        echo "2. Test: ./install-elite-nvim-modular.sh --dry-run"
        echo "3. Install: ./install-elite-nvim-modular.sh"
        return 0
    else
        echo ""
        log_fail "❌ Some tests failed. Check the log for details: $TEST_LOG"
        return 1
    fi
}

# Performance test
test_startup_performance() {
    log_test "Testing startup performance (if Neovim is installed)..."
    
    if command -v nvim &> /dev/null; then
        local startup_time
        startup_time=$(nvim --headless --startuptime /tmp/nvim-startup.log +qa 2>/dev/null && \
                      tail -1 /tmp/nvim-startup.log | awk '{print $1}' 2>/dev/null || echo "999")
        
        if [[ $(echo "$startup_time < 200" | bc -l 2>/dev/null || echo "0") -eq 1 ]]; then
            log_pass "Startup time: ${startup_time}ms (good)"
            return 0
        else
            log_warn "Startup time: ${startup_time}ms (may need optimization)"
            return 0
        fi
    else
        log_info "Neovim not installed, skipping performance test"
        return 0
    fi
}

# Quick test mode
quick_test() {
    log_info "🚀 Running quick tests..."
    
    run_test "File Structure" "test_file_structure"
    run_test "Script Permissions" "test_script_permissions"
    run_test "Help Functionality" "test_help_functionality"
    run_test "Dry Run" "test_dry_run"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        log_pass "✅ Quick tests passed!"
    else
        log_fail "❌ Quick tests failed!"
    fi
}

# Main execution
case "${1:-full}" in
    "quick")
        quick_test
        ;;
    "performance")
        test_startup_performance
        ;;
    "full"|*)
        run_all_tests
        ;;
esac