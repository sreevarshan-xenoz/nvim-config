# 🚀 Neovim Supercharged - Complete Cheat Sheet

## 🎯 **Essential Vim Basics**

### Modes
- `Esc` → Normal mode (navigation/commands)
- `i` → Insert mode (typing)
- `v` → Visual mode (selection)
- `:` → Command mode

### Navigation
- `hjkl` → Left/Down/Up/Right
- `w/b` → Word forward/back
- `0/$` → Line start/end
- `gg/G` → File start/end

### Basic Editing
- `dd` → Delete line
- `yy` → Copy line
- `p` → Paste
- `u` → Undo
- `Ctrl+r` → Redo

## ⚡ **Enhanced Navigation (Flash.nvim)**

- `s` + 2 characters → Jump anywhere instantly
- `S` → Treesitter jump (functions, classes)
- `f/F` + character → Find character forward/back
- `t/T` + character → Till character forward/back

## 🔍 **File & Project Management**

### Finding Files
- `<Space>ff` → Find files (fuzzy search)
- `<Space>fg` → Live grep (search in files)
- `<Space>fb` → Browse buffers
- `<Space>fh` → Help tags

### Project Management
- `<Space>fp` → Switch projects
- `<Space>fw` → Switch workspaces
- `<Space>qs` → Restore session
- `<Space>ql` → Restore last session
- `-` → Open Oil file manager
- `<Space>-` → Oil in floating window

## 🎨 **Themes & UI**

- `<Space>th` → Cycle themes (tokyonight/catppuccin/gruvbox/onedarkpro)
- Smooth scrolling automatically enabled
- Beautiful notifications for all messages
- Breadcrumbs at top showing code context

## ✏️ **Advanced Editing**

### Text Objects (Enhanced)
- `vif` → Select inside function
- `vaf` → Select around function
- `vic` → Select inside class
- `vac` → Select around class
- `vii` → Select inside indent level
- `vai` → Select around indent level

### Multiple Cursors
- `Ctrl+d` → Select next occurrence of word
- `Ctrl+d` (repeat) → Add more cursors
- `\\c` → Create cursors with visual selection
- `\\A` → Select all occurrences

### Smart Operations
- `Ctrl+a/x` → Increment/decrement numbers, dates, booleans
- `gcc` → Comment/uncomment line
- `gc` + motion → Comment motion (e.g., `gcap` for paragraph)
- `ys` + motion + char → Surround with character
- `ds` + char → Delete surrounding character
- `cs` + old + new → Change surrounding character

## 🤖 **AI-Powered Coding**

### GitHub Copilot
- `Ctrl+J` → Accept suggestion (insert mode)
- `Ctrl+N/P` → Next/previous suggestion
- `Ctrl+H` → Dismiss suggestion
- `<Space>cp` → Open Copilot panel

### ChatGPT (if enabled)
- `<Space>cc` → Open ChatGPT chat
- `<Space>ce` → Edit with instruction
- `<Space>cx` → Explain code
- `<Space>cf` → Fix bugs
- `<Space>co` → Optimize code
- `<Space>cd` → Generate docstring
- `<Space>ca` → Add tests

## 🐛 **Debugging & Testing**

### Debugging
- `F5` → Start/Continue debugging
- `F10` → Step over
- `F11` → Step into
- `F12` → Step out
- `<Space>db` → Toggle breakpoint
- `<Space>dB` → Conditional breakpoint
- `<Space>du` → Toggle debug UI

### Testing
- `<Space>tt` → Run nearest test
- `<Space>tf` → Run all tests in file
- `<Space>td` → Debug nearest test
- `<Space>ts` → Toggle test summary
- `<Space>to` → Show test output

## 🔧 **LSP & Code Intelligence**

### Navigation
- `gd` → Go to definition
- `gi` → Go to implementation
- `gr` → Go to references
- `K` → Hover documentation
- `<Space>ca` → Code actions

### Diagnostics
- `]d/[d` → Next/previous diagnostic
- `<Space>e` → Show line diagnostics
- `:Trouble` → Show all diagnostics

## 📝 **Language-Specific Features**

### Rust
- `Ctrl+Space` → Hover actions (in Rust files)
- `<Space>a` → Code action group
- Inlay hints automatically shown
- Crates.io integration in Cargo.toml

### Python
- `<Space>vs` → Select virtual environment
- `<Space>vc` → Select cached venv
- Automatic pytest integration
- DAP debugging support

### Markdown
- `<Space>mp` → Toggle markdown preview
- Enhanced editing with folding
- Math support enabled

### JSON/YAML
- Automatic schema validation
- Intelligent autocompletion
- Error highlighting

## 🎮 **Git Integration**

- `<Space>gg` → Open Neogit (full Git UI)
- `<Space>gs` → Stage current hunk
- `]c/[c` → Next/previous Git hunk
- `:DiffviewOpen` → Open diff view
- Git signs in gutter automatically

## ⚙️ **System & Configuration**

### Health & Maintenance
- `:checkhealth` → System diagnostics
- `:Lazy` → Plugin manager
- `:Lazy sync` → Update all plugins
- `:Mason` → LSP server manager
- `:TSUpdate` → Update Treesitter parsers

### Performance
- `:Lazy profile` → Check startup time
- Target: <200ms startup
- Lazy loading optimized

## 🔥 **Pro Tips**

### Workflow Optimization
1. **Start your day**: `<Space>ql` (restore last session)
2. **Switch projects**: `<Space>fp` (instant project switching)
3. **Find anything**: `<Space>ff` then type partial filename
4. **Navigate code**: `s` + 2 chars to jump anywhere
5. **Multiple edits**: `Ctrl+d` to select all instances

### Debugging Workflow
1. Set breakpoints with `<Space>db`
2. Start debugging with `F5`
3. Step through with `F10/F11`
4. Inspect variables in debug UI

### Testing Workflow
1. Write tests in your language
2. Run with `<Space>tt` (nearest) or `<Space>tf` (file)
3. Debug failing tests with `<Space>td`
4. View results with `<Space>ts`

### AI-Assisted Coding
1. Let Copilot suggest as you type
2. Accept with `Ctrl+J`
3. For complex refactoring: `<Space>ce`
4. For explanations: Select code + `<Space>cx`

## 🆘 **Troubleshooting**

### Common Issues
- **Plugins not loading**: `:Lazy sync`
- **LSP not working**: `:Mason` to install servers
- **Treesitter errors**: `:TSInstall all`
- **Copilot not working**: `:Copilot setup`
- **Slow startup**: `:Lazy profile` to identify issues

### Getting Help
- `<Space>` then wait → See available shortcuts
- `:help` + topic → Built-in help
- `K` on any function → Documentation
- `:checkhealth` → System status

---

## 🐟 **Fish Shell Integration**

### **Fish Functions for Neovim**
```fish
nvim-profile          # Profile Neovim startup performance
nvim-clean           # Start Neovim with clean config
nvim-startup         # Measure and log startup time
nvim-project ~/code  # Open project directory in Neovim
nvim-config          # Edit Neovim configuration
dev-setup            # Show development environment status
```

### **Enhanced Fish Aliases**
```fish
ll                   # Enhanced ls with exa
cat file.txt         # Enhanced cat with bat
find . -name "*.py"  # Enhanced find with fd
grep "pattern"       # Enhanced grep with ripgrep
```

### **Git Workflow in Fish**
```fish
gs                   # git status
ga .                 # git add
gc -m "message"      # git commit
gp                   # git push
gl                   # git pull
```

**Remember**: Start with the basics (hjkl, i, Esc, :w, :q) and gradually add more features. The key is building muscle memory! 🎯

**Fish Users**: Your shell is now optimized for Neovim development with custom functions and completions! 🐟