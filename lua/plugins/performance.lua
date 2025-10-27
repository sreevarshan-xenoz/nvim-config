-- Plugins/performance.lua: Essential performance tools only
-- Keeping only the most useful performance monitoring tools

return {
  -- Startup time analysis (useful for optimization)
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Simple memory monitoring function
  {
    "nvim-lua/plenary.nvim",
    config = function()
      -- Custom memory monitoring function
      local function show_memory_usage()
        local memory_kb = vim.fn.luaeval("collectgarbage('count')")
        local memory_mb = memory_kb / 1024
        vim.notify(string.format("Lua Memory Usage: %.2f MB", memory_mb))
      end
      
      vim.keymap.set("n", "<leader>mem", show_memory_usage, { desc = "Show Memory Usage" })
      
      -- Auto garbage collection on focus lost
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          collectgarbage("collect")
        end,
      })
    end,
  },
}