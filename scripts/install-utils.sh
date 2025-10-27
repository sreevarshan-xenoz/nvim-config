#!/bin/bash
# 🛠️ Installation Utilities - Reusable functions for modular installer
# Common utilities, logging, and helper functions

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/install-config.sh"

# 🎨 Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# 📝 Enhanced Logging Functions
setup_logging() {
    mkdir -p "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"
}

log_debug() {
    [[ "$LOG_LEVEL" == "DEBUG" ]] && echo -e "${CYAN}🔍 DEBUG: $1${NC}" | tee -a "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}❌ $1${NC}" | tee -a "$LOG_FILE"
}

log_header() {
    local header="🚀 $1"
    local separator=$(printf '=%.0s' $(seq 1 ${#header}))
    echo -e "${PURPLE}$header${NC}" | tee -a "$LOG_FILE"
    echo -e "${PURPLE}$separator${NC}" | tee -a "$LOG_FILE"
}

# 🔍 System Detection Functions
detect_os() {
    log_debug "Detecting operating system..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v pacman &> /dev/null; then
            OS="arch"
            DISTRO="Arch Linux"
            PACKAGE_MANAGER="pacman"
        elif command -v apt &> /dev/null; then
            OS="debian"
            DISTRO="Ubuntu/Debian"
            PACKAGE_MANAGER="apt"
        elif command -v dnf &> /dev/null; then
            OS="fedora"
            DISTRO="Fedora/RHEL"
            PACKAGE_MANAGER="dnf"
        elif command -v yum &> /dev/null; then
            OS="rhel"
            DISTRO="RHEL/CentOS"
            PACKAGE_MANAGER="yum"
        elif command -v zypper &> /dev/null; then
            OS="opensuse"
            DISTRO="openSUSE"
            PACKAGE_MANAGER="zypper"
        else
            OS="unknown"
            DISTRO="Unknown Linux"
            PACKAGE_MANAGER="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        DISTRO="macOS"
        PACKAGE_MANAGER="brew"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
        DISTRO="Windows"
        PACKAGE_MANAGER="unknown"
    else
        OS="unknown"
        DISTRO="Unknown OS"
        PACKAGE_MANAGER="unknown"
    fi
    
    export OS DISTRO PACKAGE_MANAGER
    log_debug "Detected: $DISTRO ($OS) with $PACKAGE_MANAGER"
}

detect_environment() {
    log_debug "Detecting environment features..."
    
    # Check for Hyprland
    if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
        HYPRLAND_DETECTED=true
        log_info "Hyprland detected - theme sync will be enabled"
    else
        HYPRLAND_DETECTED=false
    fi
    
    # Check for Neovide
    if command -v neovide &> /dev/null; then
        NEOVIDE_DETECTED=true
        log_info "Neovide detected - GPU acceleration available"
    else
        NEOVIDE_DETECTED=false
    fi
    
    # Check for GPU
    if command -v nvidia-smi &> /dev/null; then
        GPU_TYPE="nvidia"
        GPU_INFO=$(nvidia-smi --query-gpu=name --format=csv,noheader,nounits | head -n1)
    elif lspci 2>/dev/null | grep -i vga | grep -i amd &> /dev/null; then
        GPU_TYPE="amd"
        GPU_INFO="AMD GPU detected"
    elif lspci 2>/dev/null | grep -i vga | grep -i intel &> /dev/null; then
        GPU_TYPE="intel"
        GPU_INFO="Intel integrated graphics"
    else
        GPU_TYPE="unknown"
        GPU_INFO="GPU information not available"
    fi
    
    export HYPRLAND_DETECTED NEOVIDE_DETECTED GPU_TYPE GPU_INFO
}

# 🔧 System Requirements Checking
check_requirements() {
    log_info "Checking system requirements..."
    local requirements_met=true
    
    # Check if running as root (not recommended)
    if [[ $EUID -eq 0 ]] && [[ "$ALLOW_ROOT" != "true" ]]; then
        if [[ "$SKIP_CONFIRMATION" != "true" ]]; then
            log_warning "Running as root is not recommended. Continue? (y/N)"
            read -r response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
                log_error "Installation cancelled."
                exit 1
            fi
        else
            log_warning "Running as root (allowed by configuration)"
        fi
    fi
    
    # Check available disk space (need at least 1GB)
    local available_space=$(df "$HOME" | awk 'NR==2 {print $4}')
    if [[ $available_space -lt 1048576 ]]; then
        log_warning "Less than 1GB available space (${available_space}KB available)"
        if [[ "$SKIP_CONFIRMATION" != "true" ]]; then
            log_warning "Continue with limited space? (y/N)"
            read -r response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
                log_error "Installation cancelled."
                exit 1
            fi
        fi
    fi
    
    # Check internet connection
    if ! ping -c 1 google.com &> /dev/null; then
        log_error "No internet connection detected. Please check your connection."
        requirements_met=false
    fi
    
    # Check essential commands
    local essential_commands=("git" "curl")
    for cmd in "${essential_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            log_error "Essential command '$cmd' not found"
            requirements_met=false
        fi
    done
    
    if [[ "$requirements_met" == "true" ]]; then
        log_success "System requirements check passed"
    else
        log_error "System requirements not met"
        exit 1
    fi
}

# 📦 Package Management Utilities
install_package() {
    local package="$1"
    local package_manager="$2"
    
    log_debug "Installing package: $package using $package_manager"
    
    case "$package_manager" in
        "pacman")
            sudo pacman -S --needed --noconfirm "$package" 2>/dev/null || return 1
            ;;
        "apt")
            sudo apt install -y "$package" 2>/dev/null || return 1
            ;;
        "dnf")
            sudo dnf install -y "$package" 2>/dev/null || return 1
            ;;
        "yum")
            sudo yum install -y "$package" 2>/dev/null || return 1
            ;;
        "zypper")
            sudo zypper install -y "$package" 2>/dev/null || return 1
            ;;
        "brew")
            brew install "$package" 2>/dev/null || return 1
            ;;
        *)
            log_error "Unknown package manager: $package_manager"
            return 1
            ;;
    esac
}

# 🕐 Timeout wrapper for commands
run_with_timeout() {
    local timeout_duration="$1"
    local description="$2"
    shift 2
    
    log_debug "Running with timeout ${timeout_duration}s: $description"
    
    if timeout "$timeout_duration" "$@" 2>/dev/null; then
        log_debug "Command completed successfully: $description"
        return 0
    else
        log_warning "Command timed out or failed: $description"
        return 1
    fi
}

# 📊 Progress Tracking
show_progress() {
    local current="$1"
    local total="$2"
    local description="$3"
    
    local percentage=$((current * 100 / total))
    local filled=$((percentage / 2))
    local empty=$((50 - filled))
    
    printf "\r${BLUE}[%s%s] %d%% - %s${NC}" \
        "$(printf '█%.0s' $(seq 1 $filled))" \
        "$(printf '░%.0s' $(seq 1 $empty))" \
        "$percentage" \
        "$description"
    
    if [[ $current -eq $total ]]; then
        echo ""
    fi
}

# 🔍 Verification Utilities
verify_installation() {
    local component="$1"
    local command="$2"
    
    if command -v "$command" &> /dev/null; then
        log_success "$component installed successfully"
        return 0
    else
        log_error "$component installation failed"
        return 1
    fi
}

verify_nvim_plugin() {
    local plugin="$1"
    
    if run_with_timeout 10 "Verify $plugin" nvim --headless -c "lua require('$plugin')" +qa; then
        log_success "$plugin plugin working"
        return 0
    else
        log_warning "$plugin plugin may not be working"
        return 1
    fi
}

# 🧹 Cleanup Utilities
cleanup_temp_files() {
    log_debug "Cleaning up temporary files..."
    
    local temp_patterns=(
        "/tmp/nvim-*"
        "/tmp/install-*"
        "$CACHE_DIR/temp-*"
    )
    
    for pattern in "${temp_patterns[@]}"; do
        rm -f $pattern 2>/dev/null || true
    done
}

cleanup_on_exit() {
    log_debug "Performing cleanup on exit..."
    cleanup_temp_files
}

# 🎯 Module Management
is_module_enabled() {
    local module="$1"
    [[ "${MODULE_ENABLED[$module]}" == "true" ]]
}

enable_module() {
    local module="$1"
    MODULE_ENABLED[$module]=true
    log_info "Enabled module: $module"
}

disable_module() {
    local module="$1"
    MODULE_ENABLED[$module]=false
    log_info "Disabled module: $module"
}

list_modules() {
    log_info "Available modules:"
    for module in "${!MODULES[@]}"; do
        local status="${MODULE_ENABLED[$module]}"
        local icon="❌"
        [[ "$status" == "true" ]] && icon="✅"
        echo "  $icon $module - ${MODULES[$module]}"
    done
}

# 🔧 Configuration Management
backup_existing_config() {
    if [ -d "$CONFIG_DIR" ]; then
        log_warning "Backing up existing Neovim config to: $BACKUP_DIR"
        mv "$CONFIG_DIR" "$BACKUP_DIR"
        log_success "Backup created successfully"
    fi
}

create_directories() {
    log_debug "Creating necessary directories..."
    
    local directories=(
        "$CONFIG_DIR"
        "$SCRIPTS_DIR"
        "$CACHE_DIR"
        "$CONFIG_DIR/lua/configs"
        "$CONFIG_DIR/lua/plugins"
        "$CONFIG_DIR/lua/lvim/modules"
    )
    
    for dir in "${directories[@]}"; do
        mkdir -p "$dir"
        log_debug "Created directory: $dir"
    done
}

# 🎯 Performance Measurement
measure_startup_time() {
    local target_ms="$1"
    local mode="$2"
    
    log_info "⚡ Measuring startup time for $mode mode (target: <${target_ms}ms)..."
    
    local startup_log="/tmp/nvim-startup-$(date +%s).log"
    
    if nvim --startuptime "$startup_log" --headless +qa 2>/dev/null; then
        local startup_time=$(tail -n1 "$startup_log" | awk '{print $1}')
        
        if (( $(echo "$startup_time < $target_ms" | bc -l 2>/dev/null || echo "0") )); then
            log_success "Startup time: ${startup_time}ms (Target achieved! 🎯)"
        elif (( $(echo "$startup_time < $(($target_ms + 50))" | bc -l 2>/dev/null || echo "0") )); then
            log_warning "Startup time: ${startup_time}ms (Close to target)"
        else
            log_warning "Startup time: ${startup_time}ms (Above target, consider optimization)"
        fi
        
        rm -f "$startup_log"
        return 0
    else
        log_error "Could not measure startup time"
        return 1
    fi
}

# 🎯 Initialize utilities
setup_logging
trap cleanup_on_exit EXIT

# Export all utility functions
export -f log_debug log_info log_success log_warning log_error log_header
export -f detect_os detect_environment check_requirements
export -f install_package run_with_timeout show_progress
export -f verify_installation verify_nvim_plugin
export -f cleanup_temp_files is_module_enabled enable_module disable_module list_modules
export -f backup_existing_config create_directories measure_startup_time