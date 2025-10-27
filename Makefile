# Elite Neovim Configuration Makefile
# Provides convenient commands for installation and management

.PHONY: help install check verify clean uninstall test

# Default target
help:
	@echo "🚀 Elite Neovim Configuration"
	@echo "============================="
	@echo ""
	@echo "Available commands:"
	@echo "  make install    - Full installation"
	@echo "  make check      - Check system requirements"
	@echo "  make verify     - Verify installation"
	@echo "  make clean      - Clean temporary files"
	@echo "  make uninstall  - Remove configuration"
	@echo "  make test       - Run all tests"
	@echo "  make beast      - Full beast mode optimization"
	@echo "  make bytebot    - Test ByteBot integration"
	@echo "  make help       - Show this help"

# Install Elite Neovim
install:
	@echo "🚀 Starting Elite Neovim installation..."
	@chmod +x install-elite-nvim.sh
	@./install-elite-nvim.sh

# Check system requirements
check:
	@echo "🔍 Checking system requirements..."
	@chmod +x check-system.sh
	@./check-system.sh

# Verify installation
verify:
	@echo "✅ Verifying installation..."
	@chmod +x verify-install.sh
	@./verify-install.sh

# Clean temporary files
clean:
	@echo "🧹 Cleaning temporary files..."
	@rm -f /tmp/nvim-*.txt /tmp/nvim-*.log
	@rm -rf ~/.cache/nvim
	@echo "✅ Cleanup complete"

# Uninstall configuration
uninstall:
	@echo "🗑️  Starting uninstallation..."
	@chmod +x uninstall.sh
	@./uninstall.sh

# Run all tests
test: check verify
	@echo "🧪 All tests completed"

# Quick setup (check + install + verify)
setup: check install verify
	@echo "🎉 Elite Neovim setup completed!"

# Update configuration (pull latest changes)
update:
	@echo "📥 Updating configuration..."
	@git pull origin main
	@echo "🔄 Restarting Neovim to apply changes..."
	@nvim +Lazy sync +qa
	@echo "✅ Update complete"

# Backup current configuration
backup:
	@echo "💾 Creating backup..."
	@cp -r ~/.config/nvim ~/.config/nvim.backup.$$(date +%Y%m%d_%H%M%S)
	@echo "✅ Backup created"

# Show configuration status
status:
	@echo "📊 Elite Neovim Status"
	@echo "====================="
	@echo ""
	@if [ -d ~/.config/nvim ]; then \
		echo "✅ Configuration: Installed"; \
	else \
		echo "❌ Configuration: Not found"; \
	fi
	@if command -v nvim >/dev/null 2>&1; then \
		echo "✅ Neovim: $$(nvim --version | head -n1)"; \
	else \
		echo "❌ Neovim: Not installed"; \
	fi
	@if [ -d ~/.local/share/nvim/lazy ]; then \
		echo "✅ Plugins: Installed"; \
	else \
		echo "❌ Plugins: Not found"; \
	fi

# Development targets
dev-install:
	@echo "🔧 Development installation..."
	@ln -sf $$(pwd) ~/.config/nvim-dev
	@echo "✅ Development symlink created"

dev-test:
	@echo "🧪 Running development tests..."
	@nvim --headless -c "lua print('Dev config test')" +qa
	@echo "✅ Development tests passed"

# Beast mode optimization
beast:
	@echo "🚀 Activating Beast Mode optimization..."
	@echo "📊 Profiling current setup..."
	@nvim --headless -c "lua require('lazy').profile()" +qa
	@echo "🧹 Cleaning cache..."
	@rm -rf ~/.cache/nvim
	@echo "🔄 Rebuilding optimized cache..."
	@nvim --headless +qa
	@echo "⚡ Testing startup time..."
	@time nvim --headless +qa
	@echo "✅ Beast mode optimization complete!"

# ByteBot integration test
bytebot:
	@echo "🤖 Testing ByteBot integration..."
	@if curl -s --connect-timeout 5 http://localhost:9991/health >/dev/null 2>&1; then \
		echo "✅ ByteBot service is running"; \
		echo "🧪 Testing API..."; \
		curl -s -X POST -H "Content-Type: application/json" \
			-d '{"prompt":"test","content":"print(\"hello\")"}' \
			http://localhost:9991/analyze || echo "⚠️  API test failed"; \
	else \
		echo "❌ ByteBot service not running on localhost:9991"; \
		echo "💡 Start your ByteBot service first"; \
	fi

# Performance benchmark
benchmark:
	@echo "📊 Running performance benchmark..."
	@echo "Startup time (5 runs):"
	@for i in 1 2 3 4 5; do \
		echo -n "Run $$i: "; \
		time nvim --headless +qa 2>&1 | grep real; \
	done
	@echo "Plugin count:"
	@nvim --headless -c "lua print('Plugins: ' .. #require('lazy').plugins())" +qa
	@echo "✅ Benchmark complete"