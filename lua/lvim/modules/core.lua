-- 🌙 LunarVim Core Module - Essential foundation
-- Plenary, which-key, impatient for <100ms startup

return {
  -- 📚 Essential Lua library (required by many plugins)
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
    priority = 1000,
  },

  -- 🗝️ Which-key - LunarVim-style keymap guide
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        plugins = { 
          spelling = true,
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          }
        },
        window = {
          border = "rounded",
          position = "bottom",
          margin = { 1, 0, 1, 0 },
          padding = { 2, 2, 2, 2 },
          winblend = 10,
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = "left",
        },
        ignore_missing = false,
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
        show_help = true,
        triggers = "auto",
        triggers_blacklist = {
          i = { "j", "k" },
          v = { "j", "k" },
        },
      })
      
      -- 🌙 LunarVim-style key groups
      wk.register({
        ["<leader>"] = {
          f = { name = "🔍 Find" },
          g = { name = "🌿 Git" },
          l = { name = "🌙 LunarVim" },
          d = { name = "🐛 Debug" },
          t = { name = "🧪 Test" },
          s = { name = "🔍 Search" },
          b = { name = "📄 Buffer" },
          w = { name = "🪟 Window" },
          x = { name = "⚠️ Trouble" },
          n = { name = "📝 Notes" },
          r = { name = "🔄 Replace" },
          q = { name = "💾 Session" },
        }
      })
    end,
  },

  -- ⚡ Impatient - Faster Lua module loading (pre-0.11)
  {
    "lewis6991/impatient.nvim",
    enabled = vim.fn.has("nvim-0.11") == 0,
    config = function()
      require("impatient").enable_profile()
    end,
  },

  -- 🌳 Treesitter - Modern syntax highlighting with LunarVim config
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- LunarVim-style parser configuration
        ensure_installed = {
          "lua", "vim", "vimdoc", "query", "regex", "bash", "markdown", "markdown_inline",
          "python", "javascript", "typescript", "tsx", "json", "jsonc", "yaml", "toml",
          "rust", "go", "c", "cpp", "java", "html", "css", "scss", "dockerfile", "gitignore"
        },
        auto_install = true,
        sync_install = false,
        ignore_install = {},
        
        -- Enhanced highlighting with semantic tokens (0.11.4+)
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          use_languagetree = true,
        },
        
        -- Smart indentation
        indent = { 
          enable = true,
          disable = { "python", "yaml" } -- These can be problematic
        },
        
        -- Incremental selection (LunarVim-style)
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        
        -- Enhanced text objects
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
        
        -- Context showing (breadcrumb-like)
        context = {
          enable = true,
          max_lines = 0,
          min_window_height = 0,
          line_numbers = true,
          multiline_threshold = 20,
          trim_scope = 'outer',
          mode = 'cursor',
          separator = nil,
          zindex = 20,
        },
      })
      
      -- 🔧 Enable folding with Treesitter (0.11.4+ feature)
      if vim.fn.has("nvim-0.11") == 1 then
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt.foldenable = false -- Start with folds open
        vim.opt.foldlevel = 99
      end
    end,
  },

  -- 📸 Session management - LunarVim-style session handling
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        auto_session_use_git_branch = true,
        auto_session_enable_last_session = false,
        auto_restore_enabled = false,
        auto_save_enabled = true,
        session_lens = {
          buftypes_to_ignore = {},
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
      })
      
      -- LunarVim-style session commands
      vim.keymap.set("n", "<leader>qs", ":SessionSave<CR>", { desc = "Save session" })
      vim.keymap.set("n", "<leader>qr", ":SessionRestore<CR>", { desc = "Restore session" })
      vim.keymap.set("n", "<leader>qd", ":SessionDelete<CR>", { desc = "Delete session" })
    end,
  },
}