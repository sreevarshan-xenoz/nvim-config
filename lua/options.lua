-- Neovim options.lua: Settings optimized for 0.11+ performance and usability
-- 0.11 benefits: Faster vim.schedule, improved folds, better LSP integration

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 250  -- Faster for 0.11 vim.schedule calls

-- Fold settings for 0.11+ Treesitter folds
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = true
vim.opt.foldlevel = 99  -- Start unfolded

-- Performance tweaks
vim.opt.lazyredraw = true
vim.opt.timeoutlen = 300  -- For which-key and mappings

-- Compatibility notes: Use vim.ui.open for file opens in 0.11
vim.opt.splitright = true
vim.opt.splitbelow = true