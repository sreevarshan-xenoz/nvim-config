-- 🎨 UI & Themes - Beautiful interface with 4 themes + enhancements
-- tokyonight (default), catppuccin, gruvbox, onedarkpro + lualine + notify

return {
  -- 🌈 Four Beautiful Themes (cycle with <leader>th)
  {
    "folke/tokyonight.nvim",
    lazy = false,  -- Load immediately for default theme
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",  -- storm, moon, night, day
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
        },
        sidebars = { "qf", "help", "terminal" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
      })
    end,
  },
  
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",  -- latte, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = true,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = true,
          mini = true,
        },
      })
    end,
  },
  
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "",  -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
    end,
  },
  
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    config = function()
      require("onedarkpro").setup({
        colors = {},
        highlights = {},
        styles = {
          types = "NONE",
          methods = "NONE",
          numbers = "NONE",
          strings = "NONE",
          comments = "italic",
          keywords = "bold,italic",
          constants = "NONE",
          functions = "italic",
          operators = "NONE",
          variables = "NONE",
          parameters = "NONE",
          conditionals = "italic",
          virtual_text = "NONE",
        },
        filetypes = {
          c = true,
          cpp = true,
          cs = true,
          java = true,
          javascript = true,
          lua = true,
          python = true,
          rust = true,
          typescript = true,
        },
        plugins = {
          native_lsp = true,
          polygot = false,
          treesitter = true,
        },
        options = {
          cursorline = false,
          transparency = false,
          terminal_colors = true,
          highlight_inactive_windows = false,
        },
      })
    end,
  },

  -- 📊 Status Line - Beautiful and informative
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",  -- Matches current colorscheme
          globalstatus = true,  -- Single statusline for all windows
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { 
            "branch", 
            "diff",
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = " ", warn = " ", info = " " },
            }
          },
          lualine_c = { 
            {
              "filename",
              file_status = true,  -- Shows if file is modified
              path = 1,  -- 0: Just filename, 1: Relative path, 2: Absolute path
            }
          },
          lualine_x = { 
            "encoding", 
            "fileformat", 
            "filetype" 
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { "oil", "trouble", "lazy" },
      })
    end,
  },

  -- 🔔 Beautiful Notifications
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({
        background_colour = "#000000",
        fps = 30,
        icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "",
          TRACE = "✎",
          WARN = ""
        },
        level = 2,
        minimum_width = 50,
        render = "default",  -- "default", "minimal", "simple"
        stages = "fade_in_slide_out",
        timeout = 3000,
        top_down = true
      })
      
      -- Replace default notify
      vim.notify = notify
    end,
  },

  -- 🌊 Smooth Scrolling
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,  -- Default easing function
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
      })
    end,
  },

  -- 📏 Indent Guides - Visual indentation
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = { 
          enabled = false,  -- Disable scope highlighting for performance
        },
        exclude = {
          filetypes = {
            "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason",
            "notify", "toggleterm", "lazyterm", "oil", "TelescopePrompt"
          },
        },
      })
    end,
  },

  -- 🎯 Icons - Beautiful file and folder icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup({
        override = {},
        default = true,
      })
    end,
  },

  -- 🌟 UI Enhancements
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "Input:",
          prompt_align = "left",
          insert_only = true,
          start_in_insert = true,
          border = "rounded",
          relative = "cursor",
          prefer_width = 40,
          width = nil,
          max_width = { 140, 0.9 },
          min_width = { 20, 0.2 },
        },
        select = {
          enabled = true,
          backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
          trim_prompt = true,
          telescope = require("telescope.themes").get_dropdown(),
        },
      })
    end,
  },
}