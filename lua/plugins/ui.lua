-- Plugins/ui.lua: Themes and UI enhancements for 0.11+
-- Why amazing: Treesitter for syntax and folds (0.11+), lualine for status, themes for experimentation

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "python", "javascript", "typescript", "rust", "cpp" },
        highlight = { enable = true },
        indent = { enable = true },
        fold = { enable = true },  -- 0.11+ fold support with vim.opt.foldmethod=expr
      })
    end,
    -- Test: In Python file, check folds with zc/zo; :TSInstall python for parsers
  },
  { "nvim-lualine/lualine.nvim", event = "VeryLazy", config = true },  -- Status line
  { "lukas-reineke/indent-blankline.nvim", event = "BufReadPost", config = true },  -- Indent guides
  { "nvim-tree/nvim-web-devicons", lazy = true },  -- Icons
  { "folke/tokyonight.nvim", lazy = true, config = function() vim.g.tokyonight_style = "night" end },  -- Default theme
  { "catppuccin/nvim", name = "catppuccin", lazy = true, config = true },
  { "ellisonleao/gruvbox.nvim", lazy = true, config = true },
  { "olimorris/onedarkpro.nvim", lazy = true, config = true },
  -- Test: :colorscheme catppuccin; <leader>th to cycle
}