#!/bin/bash
# 🔍 Elite Neovim System Requirements Checker
# Checks if your system is ready for the installation

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

# Check functions
check_command() {
    local cmd=$1
    local name=$2
    local required=${3:-true}
    
    if command -v "$cmd" &> /dev/null; then
        local version=""
        case $cmd in
            "nvim") version=$(nvim --version 2>/dev/null | head -n1 | grep -oP 'v\K[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown") ;;
            "node") version=$(node --version 2>/dev/null || echo "unknown") ;;
            "python3") version=$(python3 --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' || echo "unknown") ;;
            "git") version=$(git --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' || echo "unknown") ;;
            *) version=$(${cmd} --version 2>/dev/null | head -n1 | grep -oP '\d+\.\d+\.\d+' || echo "installed") ;;
        esac
        
        echo -e "${GREEN}✅ $name${NC} - $version"
        ((PASSED++))
        return 0
    else
        if [ "$required" = true ]; then
            echo -e "${RED}❌ $name${NC} - Not found (Required)"
            ((FAILED++))
        else
            echo -e "${YELLOW}⚠️  $name${NC} - Not found (Optional)"
            ((WARNINGS++))
        fi
        return 1
    fi
}

check_disk_space() {
    local required_mb=1024  # 1GB
    local available_kb=$(df "$HOME" | awk 'NR==2 {print $4}')
    local available_mb=$((available_kb / 1024))
    
    if [ $available_mb -ge $required_mb ]; then
        echo -e "${GREEN}✅ Disk Space${NC} - ${available_mb}MB available"
        ((PASSED++))
    else
        echo -e "${RED}❌ Disk Space${NC} - Only ${available_mb}MB available (need ${required_mb}MB)"
        ((FAILED++))
    fi
}

check_internet() {
    if ping -c 1 google.com &> /dev/null; then
        echo -e "${GREEN}✅ Internet Connection${NC} - Available"
        ((PASSED++))
    else
        echo -e "${RED}❌ Internet Connection${NC} - Not available"
        ((FAILED++))
    fi
}

check_os() {
    local os_info=""
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v lsb_release &> /dev/null; then
            os_info=$(lsb_release -d | cut -f2)
        elif [ -f /etc/os-release ]; then
            os_info=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
        else
            os_info="Linux (Unknown distribution)"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        os_info="macOS $(sw_vers -productVersion)"
    else
        os_info="$OSTYPE"
    fi
    
    echo -e "${BLUE}🖥️  Operating System:${NC} $os_info"
}

check_shell() {
    local shell_name=$(basename "$SHELL")
    echo -e "${BLUE}🐚 Shell:${NC} $shell_name"
}

echo -e "${PURPLE}🔍 Elite Neovim System Requirements Check${NC}"
echo -e "${PURPLE}$(printf '=%.0s' {1..45})${NC}"
echo ""

# System info
check_os
check_shell
echo ""

echo -e "${BLUE}📋 Checking System Requirements...${NC}"
echo ""

# Essential requirements
echo -e "${BLUE}🔧 Essential Tools:${NC}"
check_command "git" "Git"
check_command "curl" "cURL"
check_command "wget" "wget" false
check_command "unzip" "unzip"
check_disk_space
check_internet
echo ""

# Development tools
echo -e "${BLUE}🛠️  Development Tools:${NC}"
check_command "gcc" "GCC Compiler"
check_command "make" "Make"
check_command "cmake" "CMake" false
check_command "pkg-config" "pkg-config" false
echo ""

# Programming languages
echo -e "${BLUE}💻 Programming Languages:${NC}"
check_command "nvim" "Neovim"
check_command "node" "Node.js"
check_command "npm" "NPM"
check_command "python3" "Python 3"
check_command "pip3" "pip3"
check_command "rustc" "Rust" false
check_command "cargo" "Cargo" false
check_command "go" "Go" false
echo ""

# CLI tools
echo -e "${BLUE}🔍 CLI Tools:${NC}"
check_command "rg" "ripgrep"
check_command "fd" "fd"
check_command "tree-sitter" "tree-sitter" false
check_command "luarocks" "LuaRocks" false
echo ""

# Optional tools
echo -e "${BLUE}🎨 Optional Tools:${NC}"
check_command "shellcheck" "ShellCheck" false
check_command "prettier" "Prettier" false
check_command "black" "Black" false
check_command "stylua" "StyLua" false
echo ""

# Summary
echo -e "${PURPLE}📊 Summary:${NC}"
echo -e "${GREEN}✅ Passed: $PASSED${NC}"
if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Warnings: $WARNINGS${NC}"
fi
if [ $FAILED -gt 0 ]; then
    echo -e "${RED}❌ Failed: $FAILED${NC}"
fi
echo ""

# Recommendations
if [ $FAILED -gt 0 ]; then
    echo -e "${RED}❌ System not ready for installation${NC}"
    echo -e "${BLUE}💡 Install missing requirements and run this check again${NC}"
    echo ""
    echo -e "${BLUE}🔧 Installation commands by OS:${NC}"
    echo ""
    echo -e "${BLUE}Arch Linux:${NC}"
    echo "sudo pacman -S git nodejs npm python python-pip gcc make unzip ripgrep fd"
    echo ""
    echo -e "${BLUE}Ubuntu/Debian:${NC}"
    echo "sudo apt update && sudo apt install git nodejs npm python3 python3-pip gcc make unzip ripgrep fd-find"
    echo ""
    echo -e "${BLUE}macOS:${NC}"
    echo "brew install git node python gcc make ripgrep fd"
    echo ""
    echo -e "${BLUE}Fedora:${NC}"
    echo "sudo dnf install git nodejs npm python3 python3-pip gcc make unzip ripgrep fd-find"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠️  System mostly ready with some optional tools missing${NC}"
    echo -e "${BLUE}💡 You can proceed with installation, but some features may be limited${NC}"
    echo ""
    echo -e "${BLUE}🚀 Ready to install? Run:${NC}"
    echo "./install-elite-nvim.sh"
    exit 0
else
    echo -e "${GREEN}🎉 System is fully ready for Elite Neovim installation!${NC}"
    echo ""
    echo -e "${BLUE}🚀 Ready to install? Run:${NC}"
    echo "./install-elite-nvim.sh"
    exit 0
fi