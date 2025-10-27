-- 🌙 LunarVim AI Module - ByteBot chains and AI assistance
-- Enhanced AI workflows for LunarVim-style development

local M = {}

-- 🤖 Multi-step AI chain: explain then refactor (LunarVim-style)
function M.ai_chain_refactor()
  local buf_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  local filename = vim.api.nvim_buf_get_name(0)
  
  vim.notify("🌙 LunarVim AI Chain: Starting analysis...", vim.log.levels.INFO)
  
  -- Step 1: Explain
  local explain_data = {
    prompt = "As a LunarVim expert, explain this code in detail, including potential improvements",
    content = buf_content,
    filename = filename,
    filetype = vim.bo.filetype,
    step = "explain",
    context = "lunarvim"
  }
  
  vim.fn.jobstart('curl -s -X POST -H "Content-Type: application/json" -d ' .. 
    vim.fn.shellescape(vim.json.encode(explain_data)) .. ' http://localhost:9991/analyze', {
    on_stdout = function(_, data)
      if data and #data > 0 then
        local explanation = table.concat(data, '\n')
        vim.notify("🌙 LunarVim AI Explanation:\n" .. explanation, vim.log.levels.INFO)
        
        -- Step 2: Refactor based on explanation
        local refactor_data = {
          prompt = "Based on the explanation, refactor this code following LunarVim best practices for better performance and readability",
          content = buf_content,
          filename = filename,
          filetype = vim.bo.filetype,
          context = explanation,
          step = "refactor",
          framework = "lunarvim"
        }
        
        vim.fn.jobstart('curl -s -X POST -H "Content-Type: application/json" -d ' .. 
          vim.fn.shellescape(vim.json.encode(refactor_data)) .. ' http://localhost:9991/refactor', {
          on_stdout = function(_, refactor_data_out)
            if refactor_data_out and #refactor_data_out > 0 then
              vim.notify("🌙 LunarVim AI Refactor:\n" .. table.concat(refactor_data_out, '\n'), vim.log.levels.INFO)
            end
          end,
          on_stderr = function(_, err)
            if err and #err > 0 then
              vim.notify("🌙 LunarVim AI Error: " .. table.concat(err, '\n'), vim.log.levels.ERROR)
            end
          end
        })
      end
    end,
    on_stderr = function(_, err)
      if err and #err > 0 then
        vim.notify("🌙 LunarVim AI Error: " .. table.concat(err, '\n'), vim.log.levels.ERROR)
      end
    end
  })
end

-- 🌙 LunarVim-specific ByteBot functions
function M.bytebot_lunarvim_explain()
  if _G.bytebot_send then
    _G.bytebot_send("As a LunarVim expert, explain this code in detail, including its purpose, logic, and how it fits into the LunarVim ecosystem")
  else
    vim.notify("ByteBot not available", vim.log.levels.WARN)
  end
end

function M.bytebot_lunarvim_refactor()
  if _G.bytebot_send then
    _G.bytebot_send("Refactor this code following LunarVim best practices for better performance, readability, and maintainability")
  else
    vim.notify("ByteBot not available", vim.log.levels.WARN)
  end
end

function M.bytebot_lunarvim_test()
  if _G.bytebot_send then
    _G.bytebot_send("Generate comprehensive unit tests for this code using LunarVim testing conventions")
  else
    vim.notify("ByteBot not available", vim.log.levels.WARN)
  end
end

function M.bytebot_lunarvim_docs()
  if _G.bytebot_send then
    _G.bytebot_send("Add detailed documentation and comments to this code following LunarVim documentation standards")
  else
    vim.notify("ByteBot not available", vim.log.levels.WARN)
  end
end

function M.bytebot_lunarvim_optimize()
  if _G.bytebot_send then
    _G.bytebot_send("Optimize this code for better performance and memory usage while maintaining LunarVim compatibility")
  else
    vim.notify("ByteBot not available", vim.log.levels.WARN)
  end
end

function M.bytebot_lunarvim_config()
  if _G.bytebot_send then
    _G.bytebot_send("Help me configure this LunarVim setup for optimal performance and functionality")
  else
    vim.notify("ByteBot not available", vim.log.levels.WARN)
  end
end

-- 🎯 Setup LunarVim AI keymaps
function M.setup_keymaps()
  -- LunarVim AI keymaps (integrated with which-key in lvim/init.lua)
  vim.keymap.set('n', '<leader>lve', M.bytebot_lunarvim_explain, { desc = 'LunarVim AI: Explain code' })
  vim.keymap.set('n', '<leader>lvr', M.bytebot_lunarvim_refactor, { desc = 'LunarVim AI: Refactor code' })
  vim.keymap.set('n', '<leader>lvt', M.bytebot_lunarvim_test, { desc = 'LunarVim AI: Generate tests' })
  vim.keymap.set('n', '<leader>lvd', M.bytebot_lunarvim_docs, { desc = 'LunarVim AI: Add documentation' })
  vim.keymap.set('n', '<leader>lvo', M.bytebot_lunarvim_optimize, { desc = 'LunarVim AI: Optimize code' })
  vim.keymap.set('n', '<leader>lvc', M.bytebot_lunarvim_config, { desc = 'LunarVim AI: Config help' })
  vim.keymap.set('n', '<leader>lva', M.ai_chain_refactor, { desc = 'LunarVim AI: Chain (explain + refactor)' })
end

-- 🌙 LunarVim AI status check
function M.check_ai_status()
  local status = {
    bytebot = false,
    copilot = false,
    chatgpt = false
  }
  
  -- Check ByteBot
  vim.fn.jobstart('curl -s --connect-timeout 2 http://localhost:9991/health', {
    on_exit = function(_, code)
      status.bytebot = code == 0
      vim.notify("🌙 LunarVim AI Status: ByteBot " .. (status.bytebot and "✅" or "❌"), vim.log.levels.INFO)
    end
  })
  
  -- Check Copilot
  if vim.fn.exists(':Copilot') > 0 then
    status.copilot = true
  end
  
  -- Check ChatGPT
  if vim.fn.exists(':ChatGPT') > 0 then
    status.chatgpt = true
  end
  
  vim.defer_fn(function()
    local ai_status = string.format(
      "🌙 LunarVim AI Status:\n• ByteBot: %s\n• Copilot: %s\n• ChatGPT: %s",
      status.bytebot and "✅ Available" or "❌ Not running",
      status.copilot and "✅ Available" or "❌ Not installed",
      status.chatgpt and "✅ Available" or "❌ Not configured"
    )
    vim.notify(ai_status, vim.log.levels.INFO)
  end, 1000)
  
  return status
end

return M