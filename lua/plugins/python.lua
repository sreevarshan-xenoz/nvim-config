-- 🐍 Python Development - venv-selector, dap-python for Python excellence

return {
  -- 🐍 Virtual environment selector
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    config = function()
      require("venv-selector").setup({
        auto_refresh = false,
        search_venv_managers = true,
        search_workspace = true,
        search = true,
        dap_enabled = true,
        parents = 2,
        name = {
          "venv",
          ".venv",
          "env",
          ".env",
        },
        fd_binary_name = "fd",
        notify_user_on_activate = true,
      })
      
      vim.keymap.set("n", "<leader>vs", ":VenvSelect<CR>", { desc = "Select Python venv" })
      vim.keymap.set("n", "<leader>vc", ":VenvSelectCached<CR>", { desc = "Select cached Python venv" })
    end,
  },

  -- 🔧 Python DAP configuration
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-python").setup("python")
      
      vim.keymap.set("n", "<leader>dpr", function()
        require("dap-python").test_method()
      end, { desc = "Debug Python test method" })
      
      vim.keymap.set("n", "<leader>dpc", function()
        require("dap-python").test_class()
      end, { desc = "Debug Python test class" })
      
      vim.keymap.set("v", "<leader>ds", function()
        require("dap-python").debug_selection()
      end, { desc = "Debug Python selection" })
    end,
  },
}