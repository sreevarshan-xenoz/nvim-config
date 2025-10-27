-- ⚙️ Neovim 0.11+ Options - Optimized for Performance & UX
-- All settings with explanations for learning

local opt = vim.opt

-- 📊 Line Numbers & Display
opt.number = true                    -- Show line numbers
opt.relativenumber = true            -- Relative line numbers for motions
opt.signcolumn = "yes"              -- Always show sign column (git, diagnostics)
opt.wrap = false                    -- Don't wrap long lines
opt.scrolloff = 8                   -- Keep 8 lines visible when scrolling
opt.sidescrolloff = 8               -- Keep 8 columns visible when scrolling

-- 🎨 Colors & UI - VS Code-like appearance
opt.termguicolors = true            -- Enable 24-bit RGB colors
opt.background = "dark"             -- Dark background
opt.cursorline = true               -- Highlight current line
opt.colorcolumn = "80"              -- Show column at 80 chars

-- VS Code-like transparency and blending (0.11.4+ features)
if vim.fn.has("nvim-0.11") == 1 then
  opt.pumblend = 10                 -- Popup menu transparency (0-100)
  opt.winblend = 0                  -- Window transparency (0 for solid, 10 for slight transparency)
else
  -- Fallback for older versions
  opt.pumblend = 0
  opt.winblend = 0
end

-- 🔍 Search & Replace
opt.hlsearch = false                -- Don't highlight all search matches
opt.incsearch = true                -- Show search matches as you type
opt.ignorecase = true               -- Case insensitive search
opt.smartcase = true                -- Case sensitive if uppercase present

-- 📝 Indentation & Formatting
opt.tabstop = 2                     -- Tab width
opt.softtabstop = 2                 -- Soft tab width
opt.shiftwidth = 2                  -- Indent width
opt.expandtab = true                -- Use spaces instead of tabs
opt.smartindent = true              -- Smart auto-indenting
opt.breakindent = true              -- Maintain indent when wrapping

-- 💾 Files & Backup
opt.swapfile = false                -- Disable swap files
opt.backup = false                  -- Disable backup files
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true                 -- Persistent undo history
opt.autowrite = true                -- Auto-save when switching buffers

-- 🖱️ Mouse & Clipboard
opt.mouse = "a"                     -- Enable mouse in all modes
opt.clipboard = "unnamedplus"       -- Use system clipboard

-- ⚡ Performance & Responsiveness
opt.updatetime = 50                 -- Faster completion (default: 4000ms)
opt.timeoutlen = 300                -- Faster key sequence timeout
opt.lazyredraw = false              -- Don't redraw during macros (0.11+ handles this)

-- 🔄 Completion & Wildmenu
opt.completeopt = { "menuone", "noselect", "noinsert" }
opt.wildmode = "longest:full,full"  -- Command completion behavior
opt.pumheight = 10                  -- Popup menu height

-- 📁 Folding (0.11+ Treesitter integration)
opt.foldmethod = "expr"             -- Use expression for folding
opt.foldexpr = "nvim_treesitter#foldexpr()"  -- Treesitter-based folding
opt.foldenable = false              -- Start with folds open
opt.foldlevel = 99                  -- High fold level = most folds open

-- 🪟 Splits & Windows
opt.splitbelow = true               -- Horizontal splits go below
opt.splitright = true               -- Vertical splits go right

-- 🔔 Notifications & Messages
opt.shortmess:append("c")           -- Don't show completion messages
opt.iskeyword:append("-")           -- Treat dash as part of word

-- 🚀 0.11+ Specific Optimizations
if vim.fn.has("nvim-0.11") == 1 then
  -- Enable async formatting for snappier LSP
  vim.lsp.buf.format = function(opts)
    opts = opts or {}
    opts.async = true
    return vim.lsp.buf.format(opts)
  end
  
  -- Improved diff algorithm
  opt.diffopt:append("algorithm:patience")
  opt.diffopt:append("indent-heuristic")
end

-- 🎯 Leader key (set early in init.lua but confirmed here)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 🐍 Python provider (for performance)
vim.g.python3_host_prog = vim.fn.exepath("python3")

-- 📦 Disable unused providers for faster startup
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- 🎨 Enable syntax highlighting (fallback if treesitter fails)
vim.cmd("syntax enable")