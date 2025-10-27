-- Neovim init.lua for 0.11+ modular config
-- Bootstraps Lazy.nvim, loads modules, sets options and theme

-- Set leader key early
vim.g.mapleader = ' '

-- Basic options (more in lua/options.lua)
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

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

-- Load core modules
require('options')  -- Settings optimized for 0.11
require('keymaps')  -- Leader mappings and which-key

-- Setup Lazy with plugins
local plugins = {}
local plugin_modules = {
  'plugins.core',
  'plugins.ui', 
  'plugins.editing',
  'plugins.lsp',
  'plugins.git',
  'plugins.extras',
  'plugins.debug',        -- Debugging & Testing
  'plugins.ai',           -- AI-powered coding
  'plugins.enhanced-ui',  -- Beautiful UI enhancements
  'plugins.motions',      -- Enhanced navigation
  'plugins.project',      -- Project & session management
  'plugins.languages',    -- Language-specific tools
  -- 🚀 FUTURISTIC UPGRADES
  'plugins.advanced-ai',     -- Next-gen AI & ML
  'plugins.futuristic-ui',   -- Holographic UI & animations
  'plugins.advanced-dev',    -- Cutting-edge dev tools
  'plugins.collaborative',   -- Real-time collaboration
  'plugins.performance',     -- Performance monitoring
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

-- Setup themes and cycle function after plugins are loaded
vim.defer_fn(function()
  local themes = { 'tokyonight', 'catppuccin', 'gruvbox', 'onedarkpro' }
  local current_theme = 1

  local function cycle_theme()
    current_theme = (current_theme % #themes) + 1
    local theme = themes[current_theme]
    local ok, _ = pcall(vim.cmd.colorscheme, theme)
    if ok then
      print("Switched to " .. theme)
    else
      print("Theme " .. theme .. " not available")
    end
  end

  -- Set default theme (tokyonight) with fallback
  local ok, _ = pcall(vim.cmd.colorscheme, 'tokyonight')
  if not ok then
    vim.cmd.colorscheme('default')
    print("Using default colorscheme - install themes with :Lazy sync")
  end

  -- Expose cycle function for keymap
  _G.cycle_theme = cycle_theme
end, 200)  -- Delay to ensure themes are loaded