-- 🌐 Web Development - TypeScript, package-info for modern web dev

return {
  -- 📦 Package.json management
  {
    "vuki656/package-info.nvim",
    ft = "json",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("package-info").setup({
        colors = {
          up_to_date = "#3C4048",
          outdated = "#d19a66",
        },
        icons = {
          enable = true,
          style = {
            up_to_date = "|  ",
            outdated = "|  ",
          },
        },
        autostart = true,
        hide_up_to_date = false,
        hide_unstable_versions = false,
        package_manager = "npm",
      })
      
      vim.keymap.set("n", "<leader>ns", require("package-info").show, { desc = "Show package info" })
      vim.keymap.set("n", "<leader>nc", require("package-info").hide, { desc = "Hide package info" })
      vim.keymap.set("n", "<leader>nt", require("package-info").toggle, { desc = "Toggle package info" })
      vim.keymap.set("n", "<leader>nu", require("package-info").update, { desc = "Update package" })
      vim.keymap.set("n", "<leader>nd", require("package-info").delete, { desc = "Delete package" })
      vim.keymap.set("n", "<leader>ni", require("package-info").install, { desc = "Install package" })
      vim.keymap.set("n", "<leader>np", require("package-info").change_version, { desc = "Change package version" })
    end,
  },

  -- 🎯 TypeScript utilities
  {
    "jose-elias-alvarez/typescript.nvim",
    ft = { "typescript", "typescriptreact" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("typescript").setup({
        disable_commands = false,
        debug = false,
        go_to_source_definition = {
          fallback = true,
        },
        server = {
          on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            
            local ts = require("typescript")
            vim.keymap.set("n", "<leader>to", ts.actions.organizeImports, { buffer = bufnr, desc = "Organize imports" })
            vim.keymap.set("n", "<leader>tr", ts.actions.removeUnused, { buffer = bufnr, desc = "Remove unused" })
            vim.keymap.set("n", "<leader>tf", ts.actions.fixAll, { buffer = bufnr, desc = "Fix all" })
            vim.keymap.set("n", "<leader>ti", ts.actions.addMissingImports, { buffer = bufnr, desc = "Add missing imports" })
          end,
        },
      })
    end,
  },

  -- 🎨 Tailwind CSS support
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    ft = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
  },
}