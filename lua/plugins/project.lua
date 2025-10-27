-- 📁 Project & Session Management - project.nvim, persistence, workspaces
-- <leader>fp (switch project), <leader>qs (save session), - (Oil explorer)

return {
  -- 🎯 Project management
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        manual_mode = false,
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "Cargo.toml" },
        ignore_lsp = {},
        exclude_dirs = {},
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = 'global',
        datapath = vim.fn.stdpath("data"),
      })
      
      -- Telescope integration
      require('telescope').load_extension('projects')
      
      vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Find projects" })
    end,
  },

  -- 💾 Session persistence
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
        options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
        pre_save = nil,
      })
      
      vim.keymap.set("n", "<leader>qs", function() require("persistence").save() end, { desc = "Save session" })
      vim.keymap.set("n", "<leader>ql", function() require("persistence").load() end, { desc = "Load session" })
      vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't save session" })
    end,
  },

  -- 🏢 Workspace management
  {
    "natecraddock/workspaces.nvim",
    config = function()
      require("workspaces").setup({
        hooks = {
          open = "Telescope find_files",
        }
      })
      
      require('telescope').load_extension('workspaces')
      
      vim.keymap.set("n", "<leader>fw", ":Telescope workspaces<CR>", { desc = "Find workspaces" })
    end,
  },
}