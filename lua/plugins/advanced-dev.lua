-- Plugins/advanced-dev.lua: Cutting-edge development tools for 0.11+
-- Why amazing: Advanced refactoring, code analysis, performance profiling

return {
  -- Advanced refactoring tools
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup({
        prompt_func_return_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        prompt_func_param_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        printf_statements = {},
        print_var_statements = {},
      })
    end,
    keys = {
      { "<leader>re", function() require('refactoring').refactor('Extract Function') end, mode = "x", desc = "Extract Function" },
      { "<leader>rf", function() require('refactoring').refactor('Extract Function To File') end, mode = "x", desc = "Extract Function To File" },
      { "<leader>rv", function() require('refactoring').refactor('Extract Variable') end, mode = "x", desc = "Extract Variable" },
      { "<leader>ri", function() require('refactoring').refactor('Inline Variable') end, mode = { "n", "x" }, desc = "Inline Variable" },
      { "<leader>rb", function() require('refactoring').refactor('Extract Block') end, desc = "Extract Block" },
      { "<leader>rbf", function() require('refactoring').refactor('Extract Block To File') end, desc = "Extract Block To File" },
    },
  },

  -- Advanced code analysis and metrics
  {
    "Wansmer/treesj",
    keys = { '<space>m', '<space>j', '<space>s' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
        check_syntax_error = true,
        max_join_length = 120,
        cursor_behavior = 'hold',
        notify = true,
        langs = {
          javascript = {
            array_expression = {
              target_nodes = { 'array_expression' },
              join = {
                space_in_brackets = false,
                no_insert_if = { 'comment' },
              },
            },
          },
        },
      })
    end,
  },

  -- Symbols outline (simpler alternative to complex analysis tools)
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup({
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = false,
        position = 'right',
        relative_width = true,
        width = 25,
        auto_close = false,
        show_numbers = false,
        show_relative_numbers = false,
        show_symbol_details = true,
        preview_bg_highlight = 'Pmenu',
        autofold_depth = nil,
        auto_unfold_hover = true,
        fold_markers = { '', '' },
        wrap = false,
        keymaps = {
          close = {"<Esc>", "q"},
          goto_location = "<Cr>",
          focus_location = "o",
          hover_symbol = "<C-space>",
          toggle_preview = "K",
          rename_symbol = "r",
          code_actions = "a",
          fold = "h",
          unfold = "l",
          fold_all = "W",
          unfold_all = "E",
          fold_reset = "R",
        },
        lsp_blacklist = {},
        symbol_blacklist = {},
      })
    end,
    keys = {
      { "<leader>so", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" },
    },
  },

  -- Advanced code documentation
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require('neogen').setup({
        enabled = true,
        input_after_comment = true,
        languages = {
          python = {
            template = {
              annotation_convention = "google_docstrings"
            }
          },
          typescript = {
            template = {
              annotation_convention = "jsdoc"
            }
          },
          rust = {
            template = {
              annotation_convention = "rustdoc"
            }
          },
        }
      })
    end,
    keys = {
      { "<leader>nf", function() require('neogen').generate({ type = "func" }) end, desc = "Generate Function Doc" },
      { "<leader>nc", function() require('neogen').generate({ type = "class" }) end, desc = "Generate Class Doc" },
      { "<leader>nt", function() require('neogen').generate({ type = "type" }) end, desc = "Generate Type Doc" },
    },
  },

  -- Advanced code folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return {'treesitter', 'indent'}
        end
      })
    end,
    keys = {
      { "zR", function() require('ufo').openAllFolds() end, desc = "Open All Folds" },
      { "zM", function() require('ufo').closeAllFolds() end, desc = "Close All Folds" },
      { "zr", function() require('ufo').openFoldsExceptKinds() end, desc = "Fold Less" },
      { "zm", function() require('ufo').closeFoldsWith() end, desc = "Fold More" },
    },
  },

  -- Code execution (disabled - complex build process)
  {
    "michaelb/sniprun",
    build = "sh install.sh",
    enabled = false, -- Disabled due to complex build requirements
    config = function()
      require("sniprun").setup({
        selected_interpreters = {},
        repl_enable = {},
        repl_disable = {},
        interpreter_options = {},
        display = {
          "Classic",
          "VirtualTextOk",
          "VirtualTextErr",
          "TempFloatingWindow",
          "LongTempFloatingWindow",
          "Terminal",
          "TerminalWithCode",
          "NvimNotify",
          "Api"
        },
        live_display = { "VirtualTextOk", "VirtualTextErr" },
        display_options = {
          terminal_scrollback = vim.o.scrollback,
          terminal_line_number = false,
          terminal_signcolumn = false,
          terminal_persistence = true,
          terminal_width = 45,
          notification_timeout = 5
        },
        show_no_output = {
          "Classic",
          "TempFloatingWindow",
        },
        snipruncolors = {
          SniprunVirtualTextOk = {bg="#66eeff",fg="#000000",ctermbg="Cyan",ctermfg="Black"},
          SniprunFloatingWinOk = {fg="#66eeff",ctermfg="Cyan"},
          SniprunVirtualTextErr = {bg="#881515",fg="#000000",ctermbg="DarkRed",ctermfg="Black"},
          SniprunFloatingWinErr = {fg="#881515",ctermfg="DarkRed"},
        },
        live_mode_toggle = 'off',
        borders = 'single',
      })
    end,
    keys = {
      { "<leader>rr", "<cmd>SnipRun<cr>", desc = "Run Code Snippet" },
      { "<leader>rf", "<cmd>%SnipRun<cr>", desc = "Run File" },
      { "<leader>rc", "<cmd>SnipClose<cr>", desc = "Close Sniprun" },
      { "<leader>rl", "<cmd>SnipLive<cr>", desc = "Live Mode" },
    },
  },
}