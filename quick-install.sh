#!/bin/bash
# 🚀 Quick Elite Neovim Installation Script
# One-liner setup for experienced users

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 Elite Neovim Quick Install${NC}"
echo "================================"

# Check if git is available
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git is required but not installed.${NC}"
    exit 1
fi

# Clone or update repository
if [ -d "$HOME/.config/nvim-elite" ]; then
    echo -e "${BLUE}📁 Updating existing repository...${NC}"
    cd "$HOME/.config/nvim-elite"
    git pull
else
    echo -e "${BLUE}📥 Cloning Elite Neovim configuration...${NC}"
    git clone https://github.com/sreevarshan-xenoz/nvim-config.git "$HOME/.config/nvim"
    cd "$HOME/.config/nvim"
fi

# Make install script executable
chmod +x install-elite-nvim.sh

# Run full installation
echo -e "${BLUE}🔧 Running full installation...${NC}"
./install-elite-nvim.sh

echo -e "${GREEN}✅ Quick installation completed!${NC}"
echo -e "${BLUE}💡 Start Neovim with: nvim${NC}"