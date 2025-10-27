-- Plugins/extras.lua: Additional utilities for 0.11+
-- Why amazing: Comment for commenting, surround for editing, leap for motion

return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup({
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
          line = "gcc",
          block = "gbc",
        },
        opleader = {
          line = "gc",
          block = "gb",
        },
        extra = {
          above = "gcO",
          below = "gco",
          eol = "gcA",
        },
        mappings = {
          basic = true,
          extra = true,
        },
        pre_hook = nil,
        post_hook = nil,
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
          change_line = "cS",
        },
      })
    end,
  },
  -- Leap removed - redundant with Flash.nvim
  -- Mini.surround removed - redundant with nvim-surround
  { "nvim-pack/nvim-spectre", lazy = true },  -- Search/replace
  -- Test: gcc for comment; ys for surround; s for leap
}