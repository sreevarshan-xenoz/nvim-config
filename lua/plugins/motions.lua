-- Plugins/motions.lua: Enhanced navigation and text objects for 0.11+
-- Why amazing: Flash for lightning-fast navigation, better text objects, multiple cursors

return {
  -- Flash - Enhanced f/t motions and jump anywhere
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("flash").setup({
        labels = "asdfghjklqwertyuiopzxcvbnm",
        search = {
          multi_window = true,
          forward = true,
          wrap = true,
          mode = "exact",
          incremental = false,
          exclude = {
            "notify",
            "cmp_menu",
            "noice",
            "flash_prompt",
            function(win)
              return not vim.api.nvim_win_get_config(win).focusable
            end,
          },
        },
        jump = {
          jumplist = true,
          pos = "start",
          history = false,
          register = false,
          nohlsearch = false,
          autojump = false,
        },
        label = {
          uppercase = true,
          exclude = "",
          current = true,
          after = true,
          before = false,
          style = "overlay",
          reuse = "lowercase",
          distance = true,
          min_pattern_length = 0,
          rainbow = {
            enabled = false,
            shade = 5,
          },
        },
        highlight = {
          backdrop = true,
          matches = true,
          priority = 5000,
          groups = {
            match = "FlashMatch",
            current = "FlashCurrent",
            backdrop = "FlashBackdrop",
            label = "FlashLabel",
          },
        },
        modes = {
          search = {
            enabled = true,
            highlight = { backdrop = false },
            jump = { history = true, register = true, nohlsearch = true },
            search = {
              mode = "search",
              max_length = false,
            },
          },
          char = {
            enabled = true,
            config = function(opts)
              opts.autohide = opts.autohide == nil and (vim.fn.mode(true):find("no") and vim.v.operator == "y")
              opts.jump_labels = opts.jump_labels == nil and (vim.fn.mode(true):find("no") and vim.v.operator ~= "y")
            end,
            autohide = false,
            jump_labels = false,
            multi_line = true,
            label = { exclude = "hjkliardc" },
            keys = { "f", "F", "t", "T", ";", "," },
            char_actions = function(motion)
              return {
                [";"] = "next", -- set to `right` to always go right
                [","] = "prev", -- set to `left` to always go left
                [motion:lower()] = "next",
                [motion:upper()] = "prev",
              }
            end,
            search = { wrap = false },
            highlight = { backdrop = true },
            jump = { register = false },
          },
          treesitter = {
            labels = "abcdefghijklmnopqrstuvwxyz",
            jump = { pos = "range" },
            search = { incremental = false },
            label = { before = true, after = true, style = "inline" },
            highlight = {
              backdrop = false,
              matches = false,
            },
          },
          treesitter_search = {
            jump = { pos = "range" },
            search = { multi_window = true, wrap = true, incremental = false },
            remote_op = { restore = true },
            label = { before = true, after = true, style = "inline" },
          },
          remote = {
            remote_op = { restore = true, motion = true },
          },
        },
        prompt = {
          enabled = true,
          prefix = { { "⚡", "FlashPromptIcon" } },
          win_config = {
            relative = "editor",
            width = 1,
            height = 1,
            row = -1,
            col = 0,
            zindex = 1000,
          },
        },
        remote_op = {
          restore = false,
          motion = false,
        },
      })
    end,
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  
  -- Better text objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup({
        custom_textobjects = {
          o = require("mini.ai").gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = require("mini.ai").gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          u = require("mini.ai").gen_spec.function_call(), -- u for "Usage"
          U = require("mini.ai").gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
        n_lines = 500,
        search_method = "cover_or_next",
      })
    end,
  },
  
  -- Multiple cursors
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
        ["Select Cursor Down"] = "<M-C-Down>",
        ["Select Cursor Up"] = "<M-C-Up>",
        ["Add Cursor Down"] = "<C-Down>",
        ["Add Cursor Up"] = "<C-Up>",
        ["Add Cursor At Pos"] = "<C-x>",
        ["Visual Regex"] = "\\\\",
        ["Visual All"] = "\\\\A",
        ["Visual Add"] = "\\\\a",
        ["Visual Find"] = "\\\\f",
        ["Visual Cursors"] = "\\\\c",
      }
      vim.g.VM_leader = "\\\\"
      vim.g.VM_highlight_matches = "underline"
    end,
  },
  
  -- Enhanced increment/decrement
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end },
      { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end },
      { "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, mode = "v" },
      { "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, mode = "v" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = "v" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = "v" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group{
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new{
            elements = {"and", "or"},
            word = true,
            cyclic = true,
          },
          augend.constant.new{
            elements = {"True", "False"},
            word = true,
            cyclic = true,
          },
          augend.constant.new{
            elements = {"&&", "||"},
            word = false,
            cyclic = true,
          },
        },
      }
    end,
  },
  
  -- Better f/F/t/T motions
  {
    "rhysd/clever-f.vim",
    event = "VeryLazy",
    init = function()
      vim.g.clever_f_mark_direct = 1
      vim.g.clever_f_mark_direct_color = "Cursor"
      vim.g.clever_f_mark_char_color = "CleverFDefaultLabel"
      vim.g.clever_f_hide_cursor_on_cmdline = 1
      vim.g.clever_f_timeout_ms = 0
      vim.g.clever_f_repeat_last_char_inputs = { "\r", "\t" }
    end,
  },
  -- Test: 's' + 2 chars to jump anywhere, Ctrl+d for multiple cursors, enhanced text objects
}