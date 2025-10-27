-- 🤝 Collaboration & Live Sharing - Real-time editing and ByteBot integration
-- live-share.nvim for pair programming, ByteBot hooks for AI assistance

return {
  -- 🔗 Live Share - Real-time collaborative editing
  {
    "azratul/live-share.nvim",
    dependencies = { "jbyuki/instant.nvim" },
    config = function()
      require("live-share").setup({
        port_internal = 9007,
        max_attempts = 40,
        service = "serveo.net", -- or "localhost.run"
      })
      
      vim.keymap.set("n", "<leader>ls", ":LiveShareServer<CR>", { desc = "Start Live Share server" })
      vim.keymap.set("n", "<leader>lj", ":LiveShareJoin<CR>", { desc = "Join Live Share session" })
      vim.keymap.set("n", "<leader>lq", ":LiveShareClose<CR>", { desc = "Close Live Share session" })
    end,
  },

  -- 🤖 ByteBot Integration Enhancement
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, {
        { "<leader>b", group = "🤖 ByteBot" },
        { "<leader>bb", desc = "Send buffer to ByteBot" },
        { "<leader>be", desc = "Explain code with ByteBot" },
        { "<leader>br", desc = "Refactor with ByteBot" },
        { "<leader>bt", desc = "Add tests with ByteBot" },
        { "<leader>bd", desc = "Add documentation with ByteBot" },
        { "<leader>bo", desc = "Optimize code with ByteBot" },
      })
      return opts
    end,
  },

  -- 📡 Remote Development Support
  {
    "chipsenkbeil/distant.nvim",
    enabled = false, -- Enable if needed for remote development
    branch = "v0.3",
    config = function()
      require("distant"):setup()
    end,
  },

  -- 🔄 Real-time Sync Utilities
  {
    "rktjmp/paperplanes.nvim",
    cmd = "PP",
    config = function()
      require("paperplanes").setup({
        register = "+",
        provider = "0x0.st",
        provider_options = {},
        notifier = vim.notify or print,
      })
      
      vim.keymap.set("v", "<leader>pp", ":PP<CR>", { desc = "Share selection online" })
    end,
  },
}

-- 🤖 Enhanced ByteBot functions
local M = {}

-- Multi-step AI chain: explain then refactor
M.ai_chain_refactor = function()
  local buf_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  local filename = vim.api.nvim_buf_get_name(0)
  
  -- Step 1: Explain
  local explain_data = {
    prompt = "Explain this code in detail, including potential improvements",
    content = buf_content,
    filename = filename,
    filetype = vim.bo.filetype,
    step = "explain"
  }
  
  vim.fn.jobstart('curl -s -X POST -H "Content-Type: application/json" -d ' .. 
    vim.fn.shellescape(vim.json.encode(explain_data)) .. ' http://localhost:9991/analyze', {
    on_stdout = function(_, data)
      if data and #data > 0 then
        local explanation = table.concat(data, '\n')
        vim.notify("ByteBot Explanation:\n" .. explanation, vim.log.levels.INFO)
        
        -- Step 2: Refactor based on explanation
        local refactor_data = {
          prompt = "Based on the explanation, refactor this code for better performance and readability",
          content = buf_content,
          filename = filename,
          filetype = vim.bo.filetype,
          context = explanation,
          step = "refactor"
        }
        
        vim.fn.jobstart('curl -s -X POST -H "Content-Type: application/json" -d ' .. 
          vim.fn.shellescape(vim.json.encode(refactor_data)) .. ' http://localhost:9991/refactor', {
          on_stdout = function(_, refactor_data_out)
            if refactor_data_out and #refactor_data_out > 0 then
              vim.notify("ByteBot Refactor:\n" .. table.concat(refactor_data_out, '\n'), vim.log.levels.INFO)
            end
          end
        })
      end
    end
  })
end

-- ByteBot specialized functions
M.bytebot_explain = function()
  _G.bytebot_send("Explain this code in detail, including its purpose, logic, and any potential issues")
end

M.bytebot_refactor = function()
  _G.bytebot_send("Refactor this code for better performance, readability, and maintainability")
end

M.bytebot_test = function()
  _G.bytebot_send("Generate comprehensive unit tests for this code")
end

M.bytebot_docs = function()
  _G.bytebot_send("Add detailed documentation and comments to this code")
end

M.bytebot_optimize = function()
  _G.bytebot_send("Optimize this code for better performance and memory usage")
end

-- Register ByteBot keymaps
vim.keymap.set('n', '<leader>be', M.bytebot_explain, { desc = 'ByteBot: Explain code' })
vim.keymap.set('n', '<leader>br', M.bytebot_refactor, { desc = 'ByteBot: Refactor code' })
vim.keymap.set('n', '<leader>bt', M.bytebot_test, { desc = 'ByteBot: Generate tests' })
vim.keymap.set('n', '<leader>bd', M.bytebot_docs, { desc = 'ByteBot: Add documentation' })
vim.keymap.set('n', '<leader>bo', M.bytebot_optimize, { desc = 'ByteBot: Optimize code' })
vim.keymap.set('n', '<leader>ca', M.ai_chain_refactor, { desc = 'ByteBot: AI Chain (explain + refactor)' })

return M