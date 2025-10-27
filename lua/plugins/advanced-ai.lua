-- Plugins/advanced-ai.lua: Minimal AI tools for 0.11+
-- Keeping only essential AI features, removing redundant/heavy plugins

return {
  -- Keep Codeium as backup to Copilot (lightweight alternative)
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    enabled = false, -- Disabled by default, enable if needed as Copilot alternative
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
}