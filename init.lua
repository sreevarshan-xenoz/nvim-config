-- ⚡ Elite Neovim 0.11.4 Configuration
-- Production-ready setup with 60+ plugins, <200ms startup
-- Modular Lua architecture for Arch Linux

-- 🎯 Set leader key early (space-based mappings)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 🚀 Essential options for immediate responsiveness
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- 🏎️ Performance boost for 0.11+
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300

-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Cloning Lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 📁 Load core configuration modules
require('configs.options')  -- All settings optimized for 0.11+
require('configs.keymaps')  -- Leader-based mappings with which-key

-- 🔌 Plugin architecture - modular and lazy-loaded
local plugins = {}
local plugin_modules = {
  'plugins.core',        -- Essential foundation (plenary, treesitter)
  'plugins.ui',          -- Themes, lualine, notify, neoscroll
  'plugins.navigation',  -- Flash, Telescope, Oil, Harpoon
  'plugins.editing',     -- Comment, surround, mini.ai, dial
  'plugins.lsp',         -- Mason, lspconfig, cmp, trouble
  'plugins.ai',          -- Copilot, ChatGPT integration
  'plugins.debug',       -- nvim-dap, neotest, testing suite
  'plugins.project',     -- project.nvim, persistence, workspaces
  'plugins.git',         -- Neogit, gitsigns, diffview, fugitive
  'plugins.rust',        -- rust-tools, crates.nvim
  'plugins.python',      -- venv-selector, dap-python
  'plugins.markdown',    -- markdown-preview, vim-markdown
  'plugins.web',         -- typescript, package-info
  'plugins.data',        -- schemastore, yaml-companion
  'plugins.tex',         -- vimtex for LaTeX
  'plugins.utils',       -- specter, bqf, todo-comments
  'plugins.debug',        -- Debugging & Testing
  'plugins.ai',           -- AI-powered coding
  'plugins.enhanced-ui',  -- Beautiful UI enhancements
  'plugins.motions',      -- Enhanced navigation
  'plugins.project',      -- Project & session management
  'plugins.languages',    -- Language-specific tools
  -- 🚀 STREAMLINED UPGRADES (heavy plugins disabled)
  'plugins.advanced-ai',     -- Minimal AI tools
  'plugins.futuristic-ui',   -- UI enhancements (minimap disabled)
  'plugins.advanced-dev',    -- Essential dev tools only
  'plugins.collaborative',   -- REST client only
  'plugins.performance',     -- Basic performance monitoring
}

for _, module in ipairs(plugin_modules) do
  local ok, plugin_list = pcall(require, module)
  if ok then
    plugins = vim.list_extend(plugins, plugin_list)
  else
    print("Failed to load " .. module .. ": " .. plugin_list)
  end
end

require("lazy").setup(plugins, {
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Health check mapping
vim.keymap.set('n', '<leader>ch', '<cmd>checkhealth<CR>', { noremap = true, silent = true })

-- 🎨 Theme management with cycle function
require('configs.theme')

-- 🏥 Health check mapping for troubleshooting
vim.keymap.set('n', '<leader>ch', '<cmd>checkhealth<CR>', { 
  desc = 'Health Check', 
  noremap = true, 
  silent = true 
})