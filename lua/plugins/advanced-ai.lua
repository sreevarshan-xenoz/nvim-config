-- Plugins/advanced-ai.lua: Next-generation AI and ML tools for 0.11+
-- Why amazing: Local AI models, advanced code analysis, intelligent refactoring

return {
  -- Codeium (Free AI alternative with more features)
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
        enable_chat = true,
        enable_local_search = true,
        enable_index_service = true,
      })
    end,
    keys = {
      { "<leader>ai", function() return vim.fn['codeium#Chat']() end, desc = "Codeium Chat" },
    },
  },

  -- Neural code completion and analysis
  {
    "dense-analysis/neural",
    config = function()
      require('neural').setup({
        source = {
          openai = {
            api_key = vim.env.OPENAI_API_KEY,
          },
        },
      })
    end,
    keys = {
      { "<leader>an", ":Neural ", desc = "Neural AI" },
    },
  },

  -- Advanced code context understanding
  {
    "sourcegraph/sg.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("sg").setup({
        enable_cody = true,
        accept_tos = true,
        download_binaries = true,
      })
    end,
    keys = {
      { "<leader>sg", "<cmd>SourcegraphSearch<cr>", desc = "Sourcegraph Search" },
      { "<leader>sc", "<cmd>CodyChat<cr>", desc = "Cody Chat" },
    },
  },

  -- Intelligent code suggestions based on your codebase
  {
    "tzachar/cmp-tabnine",
    build = "./install.sh",
    dependencies = "hrsh7th/nvim-cmp",
    config = function()
      local tabnine = require('cmp_tabnine.config')
      tabnine:setup({
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = '..',
        ignored_file_types = {},
        show_prediction_strength = false,
      })
    end,
  },
}