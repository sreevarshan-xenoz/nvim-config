-- Plugins/lsp.lua: LSP, Mason, and diagnostics for 0.11+
-- Why amazing: Auto-install servers via Mason, Trouble for diagnostics

return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "tsserver", "rust_analyzer", "clangd" },  -- 0.11 compatible
      })
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      -- Setup servers
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.tsserver.setup({ capabilities = capabilities })
      lspconfig.rust_analyzer.setup({ capabilities = capabilities })
      lspconfig.clangd.setup({ capabilities = capabilities })
      -- Keymaps for LSP
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
    end,
  },
  { "williamboman/mason.nvim", lazy = true },
  { "williamboman/mason-lspconfig.nvim", lazy = true },
  { "nvimtools/none-ls.nvim", lazy = true, config = function() require("none-ls").setup() end },
  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    config = function()
      require("trouble").setup({
        icons = false,
      })
    end,
  },
  { "onsails/lspkind.nvim", lazy = true },
  -- Test: :Mason to install servers; :Trouble for diagnostics; gd for go to definition
}