-- Plugins/enhanced-ui.lua: Beautiful UI enhancements for 0.11+
-- Why amazing: Gorgeous notifications, smooth scrolling, better indents, breadcrumbs

return {
  -- Beautiful notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
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
        render = "compact",
        stages = "fade_in_slide_out",
        timeout = 5000,
        top_down = true
      })
      vim.notify = require("notify")
    end,
  },
  
  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
      })
    end,
  },
  
  -- Indent guides with scope highlighting
  {
    "echasnovski/mini.indentscope",
    event = "BufReadPre",
    config = function()
      require("mini.indentscope").setup({
        symbol = "│",
        options = { 
          try_as_border = true,
          indent_at_cursor = true,
          border = 'both',
        },
        draw = {
          delay = 100,
          animation = require('mini.indentscope').gen_animation.none(),
        },
        mappings = {
          object_scope = 'ii',
          object_scope_with_border = 'ai',
          goto_top = '[i',
          goto_bottom = ']i',
        },
      })
    end,
  },
  
  -- Winbar with LSP context (breadcrumbs)
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("barbecue").setup({
        create_autocmd = false, -- prevent barbecue from updating itself automatically
        attach_navic = false, -- prevent barbecue from automatically attaching nvim-navic
        show_dirname = false,
        show_basename = true,
        show_modified = false,
        modified = function(bufnr) return vim.bo[bufnr].modified end,
        ellipsis = true,
        exclude_filetypes = { "netrw", "toggleterm" },
        modifiers = {
          dirname = ":~:.",
          basename = "",
        },
        show_navic = true,
        lead_custom_section = function() return " " end,
        custom_section = function() return " " end,
        theme = "auto",
        context_follow_icon_color = false,
        symbols = {
          modified = "●",
          ellipsis = "…",
          separator = "",
        },
        kinds = {
          File = "",
          Module = "",
          Namespace = "",
          Package = "",
          Class = "",
          Method = "",
          Property = "",
          Field = "",
          Constructor = "",
          Enum = "",
          Interface = "",
          Function = "",
          Variable = "",
          Constant = "",
          String = "",
          Number = "",
          Boolean = "",
          Array = "",
          Object = "",
          Key = "",
          Null = "",
          EnumMember = "",
          Struct = "",
          Event = "",
          Operator = "",
          TypeParameter = "",
        },
      })
      
      vim.api.nvim_create_autocmd({
        "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",
        -- include this if you have set `show_modified` to `true`
        "BufModifiedSet",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })
    end,
  },
  
  -- Better quickfix window
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup({
        auto_enable = true,
        auto_resize_height = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = {"┃", "━", "┏", "┓", "┗", "┛", "┣", "┫", "━"},
          show_title = false,
          should_preview_cb = function(bufnr, qwinid)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfperm(bufname):match('^..-') and vim.fn.getfsize(bufname) or 0
            if fsize > 100 * 1024 then
              ret = false
            end
            return ret
          end
        },
        func_map = {
          drop = "o",
          openc = "O",
          split = "<C-s>",
          tabdrop = "<C-t>",
          tabc = "",
          ptogglemode = "z,",
        },
        filter = {
          fzf = {
            action_for = {["ctrl-s"] = "split", ["ctrl-t"] = "tab drop"},
            extra_opts = {"--bind", "ctrl-o:toggle-all", "--prompt", "> "}
          }
        }
      })
    end,
  },
  
  -- Highlight colors in code
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = true, -- "Name" codes like Blue or blue
          RRGGBBAA = false, -- #RRGGBBAA hex codes
          AARRGGBB = true, -- 0xAARRGGBB hex codes
          rgb_fn = false, -- CSS rgb() and rgba() functions
          hsl_fn = false, -- CSS hsl() and hsla() functions
          css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          mode = "background", -- Set the display mode.
          tailwind = false, -- Enable tailwind colors
          sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
          virtualtext = "■",
        },
        buftypes = {},
      })
    end,
  },
  -- Test: Smooth scrolling with Ctrl+d/u, beautiful notifications, breadcrumbs at top
}