-- Plugins/core.lua: Essential plugins for Neovim 0.11+
-- Why amazing: Plenary for utilities, Impatient for caching to hit <200ms startup

return {
  { "nvim-lua/plenary.nvim", lazy = true },  -- Required by many, utility functions
  {
    "lewis6991/impatient.nvim",
    lazy = false,
    config = function()
      -- Caches Lua modules for faster startup (0.11+ compatible)
    end,
  },
  -- Test: :Lazy profile to check startup time
}