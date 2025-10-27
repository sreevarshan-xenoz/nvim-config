-- ⚡ Elite Neovim 0.11.4+ Beast Mode Configuration
-- Hyper-optimized setup with 65+ plugins, <150ms startup, ByteBot integration
-- Modular Lua architecture for Arch Linux (cross-OS compatible)

-- 🎯 Set leader key early (space-based mappings)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 🚀 Beast mode performance optimizations for 0.11.4+
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- 🏎️ Hyper-performance settings for <150ms startup
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 10
vim.opt.redrawtime = 1500
vim.opt.synmaxcol = 240  -- Limit syntax highlighting for long lines

-- 🔥 0.11.4+ exclusive features
if vim.fn.has("nvim-0.11") == 1 then
  -- Enable native UI improvements
  vim.opt.pumblend = 10  -- Popup menu transparency
  vim.opt.winblend = 10  -- Window transparency
  
  -- Enhanced diff algorithm for better Git performance
  vim.opt.diffopt:append("algorithm:patience")
  vim.opt.diffopt:append("indent-heuristic")
  vim.opt.diffopt:append("linematch:60")
end

-- 🎨 Beast mode UI enhancements
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"  -- Only highlight line number
vim.opt.fillchars = {
  eob = " ",  -- Remove ~ from empty lines
  fold = " ",
  foldopen = "",
  foldsep = " ",
  foldclose = "",
}

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

-- 🌙 LunarVim-inspired Modular Architecture - <100ms startup
local lvim = require("lvim")

-- Load LunarVim-style modular plugins
local plugins = lvim.setup()

-- Merge with existing beast mode plugins for compatibility
local beast_modules = {
  'plugins.navigation',  -- Flash, Telescope, Oil, Harpoon (enhanced)
  'plugins.editing',     -- Comment, surround, mini.ai, dial, undotree
  'plugins.ai',          -- Copilot, ChatGPT, ByteBot integration
  'plugins.debug',       -- nvim-dap, neotest, testing suite
  'plugins.project',     -- project.nvim, persistence, workspaces
  'plugins.git',         -- Neogit, gitsigns, diffview, auto-backup
  'plugins.collab',      -- live-share.nvim for real-time collaboration
  'plugins.rust',        -- rust-tools, crates.nvim
  'plugins.python',      -- venv-selector, dap-python
  'plugins.markdown',    -- markdown-preview, vim-markdown
  'plugins.web',         -- typescript, package-info
  'plugins.data',        -- schemastore, yaml-companion
  'plugins.tex',         -- vimtex for LaTeX
  'plugins.utils',       -- specter, bqf, todo-comments, nerd fonts
}

-- Load beast mode plugins (for compatibility and additional features)
for _, module in ipairs(beast_modules) do
  local ok, plugin_list = pcall(require, module)
  if ok then
    plugins = vim.list_extend(plugins, plugin_list)
  else
    vim.notify("Failed to load beast module: " .. module, vim.log.levels.WARN)
  end
end

require("lazy").setup(plugins, {
  -- 🚀 Beast mode performance optimizations
  performance = {
    cache = {
      enabled = true,
      path = vim.fn.stdpath("cache") .. "/lazy/cache",
      ttl = 3600 * 24 * 5, -- 5 days
      disable_events = { "UIEnter", "BufReadPre" },
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin",
        "tohtml", "tutor", "zipPlugin", "2html_plugin", "getscript",
        "getscriptPlugin", "logipat", "rrhelper", "spellfile_plugin",
        "vimball", "vimballPlugin",
      },
    },
  },
  -- 🎯 Beast mode UI
  ui = {
    size = { width = 0.8, height = 0.8 },
    wrap = true,
    border = "rounded",
    backdrop = 60,
    title = "⚡ Elite Neovim Beast Mode",
    title_pos = "center",
    pills = true,
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = "",
      task = "✔ ",
      list = { "●", "➜", "★", "‒" },
    },
  },
  -- 🔧 Beast mode installation
  install = {
    missing = true,
    colorscheme = { "tokyonight", "catppuccin", "gruvbox" },
  },
  checker = {
    enabled = true,
    notify = false,
    frequency = 3600, -- Check every hour
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
})

-- Health check mapping
vim.keymap.set('n', '<leader>ch', '<cmd>checkhealth<CR>', { noremap = true, silent = true })

-- 🎨 Beast mode theme management with Hyprland sync
require('configs.theme')

-- 🤖 ByteBot integration hook
_G.bytebot_send = function(prompt)
  local buf_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  local filename = vim.api.nvim_buf_get_name(0)
  
  local data = {
    prompt = prompt or "Analyze and improve this code",
    content = buf_content,
    filename = filename,
    filetype = vim.bo.filetype
  }
  
  -- Send to ByteBot container on localhost:9991
  local cmd = string.format(
    'curl -s -X POST -H "Content-Type: application/json" -d %s http://localhost:9991/analyze',
    vim.fn.shellescape(vim.json.encode(data))
  )
  
  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data_out)
      if data_out and #data_out > 0 then
        vim.notify("ByteBot: " .. table.concat(data_out, '\n'), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, err)
      if err and #err > 0 then
        vim.notify("ByteBot Error: " .. table.concat(err, '\n'), vim.log.levels.ERROR)
      end
    end
  })
end

-- 🚀 Beast mode keymaps
vim.keymap.set('n', '<leader>bb', function()
  local prompt = vim.fn.input("ByteBot prompt: ")
  if prompt ~= "" then
    _G.bytebot_send(prompt)
  end
end, { desc = 'ByteBot: Send buffer for analysis' })

vim.keymap.set('n', '<leader>ch', '<cmd>checkhealth<CR>', { 
  desc = 'Health Check', 
  noremap = true, 
  silent = true 
})

-- 🔥 Beast mode auto-commands
local beast_group = vim.api.nvim_create_augroup("BeastMode", { clear = true })

-- Auto-save and git backup on write
vim.api.nvim_create_autocmd("BufWritePost", {
  group = beast_group,
  callback = function()
    -- Auto-git backup (if in git repo)
    local git_dir = vim.fn.finddir('.git', '.;')
    if git_dir ~= '' then
      vim.fn.jobstart('git add . && git commit -m "Auto-backup: ' .. 
        vim.fn.strftime('%Y-%m-%d %H:%M:%S') .. '"', {
        cwd = vim.fn.fnamemodify(git_dir, ':h'),
        on_exit = function(_, code)
          if code == 0 then
            vim.notify("Auto-backup committed", vim.log.levels.INFO)
          end
        end
      })
    end
  end,
})

-- Hyprland theme sync (if detected)
if os.getenv("HYPRLAND_INSTANCE_SIGNATURE") then
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = beast_group,
    callback = function()
      local theme = vim.g.colors_name
      if theme then
        -- Sync with Hyprland theme
        vim.fn.jobstart('hyprctl keyword general:col.active_border "rgb(' .. 
          (theme == 'tokyonight' and '7aa2f7' or 
           theme == 'catppuccin' and 'cba6f7' or 
           theme == 'gruvbox' and 'fabd2f' or 'abb2bf') .. ')"')
      end
    end,
  })
end

-- 🌙 Setup LunarVim-style commands and keymaps
vim.defer_fn(function()
  lvim.setup_commands()
  lvim.setup_which_key()
end, 200)

-- 📊 Beast mode startup profiling
if vim.env.NVIM_PROFILE then
  vim.defer_fn(function()
    require("lazy").profile()
  end, 100)
end