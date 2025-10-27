-- 🏗️ Beast Mode Core Foundation - Hyper-optimized essentials
-- Plenary, Treesitter, Which-key, Snapshot for <150ms startup

return {
  -- 📚 Essential Lua library (required by many plugins)
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
    priority = 1000,
  },

  -- 📸 Snapshot.nvim - Session snapshots for instant restoration
  {
    "rmagatti/session-lens",
    dependencies = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        auto_session_use_git_branch = true,
        auto_session_enable_last_session = true,
        auto_restore_enabled = false,
        auto_save_enabled = true,
        session_lens = {
          buftypes_to_ignore = {},
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
      })
      require("session-lens").setup({})
      
      vim.keymap.set("n", "<leader>ss", require("session-lens").search_session, { desc = "Search sessions" })
    end,
  },

  -- 🌳 Treesitter - Modern syntax highlighting & code understanding
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",  -- Smart text objects
      "nvim-treesitter/nvim-treesitter-context",      -- Show context
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- 📦 Auto-install parsers for these languages
        ensure_installed = {
          "lua", "vim", "vimdoc", "query",
          "python", "javascript", "typescript", "tsx",
          "rust", "go", "c", "cpp", "java",
          "html", "css", "json", "yaml", "toml",
          "markdown", "markdown_inline", "bash", "dockerfile"
        },
        auto_install = true,
        
        -- 🎨 Syntax highlighting
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,  -- Disable for performance
        },
        
        -- 📏 Smart indentation
        indent = { enable = true },
        
        -- 🎯 Incremental selection (expand selection smartly)
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        
        -- 🎪 Text objects (select functions, classes, etc.)
        textobjects = {
          select = {
            enable = true,
            lookahead = true,  -- Look ahead to find next text object
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,  -- Add to jumplist
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
          },
        },
      })
      
      -- 🔧 Enable folding with Treesitter
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },

  -- 🗝️ Which-key - Visual guide for keymaps
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        plugins = { 
          spelling = true,  -- Show spelling suggestions
        },
        window = {
          border = "rounded",
          position = "bottom",
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
        },
      })
      
      -- 📋 Register key groups for better organization
      wk.register({
        ["<leader>f"] = { name = "🔍 Find" },
        ["<leader>g"] = { name = "🌿 Git" },
        ["<leader>c"] = { name = "🤖 Code/AI" },
        ["<leader>d"] = { name = "🐛 Debug" },
        ["<leader>t"] = { name = "🧪 Test" },
        ["<leader>q"] = { name = "💾 Session" },
        ["<leader>x"] = { name = "⚠️ Trouble" },
        ["<leader>b"] = { name = "📄 Buffer" },
        ["<leader>w"] = { name = "🪟 Window" },
      })
    end,
  },

  -- ⚡ Impatient - Faster Lua module loading (0.11+ optimization)
  {
    "lewis6991/impatient.nvim",
    enabled = vim.fn.has("nvim-0.11") == 0,  -- Only for pre-0.11
    config = function()
      require("impatient")
    end,
  },
}