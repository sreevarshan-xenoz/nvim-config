-- 🌙 LunarVim-inspired Modular Architecture
-- Hyper-modular IDE setup with <100ms startup and ByteBot integration
-- Inspired by LunarVim's extras/ system but with Lazy.nvim specs

local M = {}

-- 🎯 LunarVim-style module configuration
M.config = {
  -- Core modules (always enabled)
  core = { enabled = true },
  
  -- Optional modules (can be toggled)
  modules = {
    editing = { enabled = true, desc = "Enhanced editing (comment, surround, autopairs)" },
    lsp = { enabled = true, desc = "LSP with Mason auto-setup and lunar configs" },
    ui = { enabled = true, desc = "Beautiful UI with alpha dashboard and lualine" },
    debug = { enabled = true, desc = "DAP debugging and testing with neotest" },
    git = { enabled = true, desc = "Git integration with neogit and gitsigns" },
    navigation = { enabled = true, desc = "Telescope, flash, oil, harpoon navigation" },
    ai = { enabled = true, desc = "ByteBot AI chains and Copilot integration" },
    collab = { enabled = false, desc = "Live collaboration and sharing" },
    languages = {
      rust = { enabled = true, desc = "Rust development tools" },
      python = { enabled = true, desc = "Python development tools" },
      web = { enabled = true, desc = "Web development (TS, JS, HTML, CSS)" },
      markdown = { enabled = true, desc = "Markdown editing and preview" },
      data = { enabled = true, desc = "JSON, YAML, CSV support" },
      tex = { enabled = false, desc = "LaTeX support with vimtex" },
    }
  }
}

-- 🔧 LunarVim-style module loader
function M.load_module(module_name)
  local ok, module = pcall(require, "lvim.modules." .. module_name)
  if not ok then
    vim.notify("Failed to load LunarVim module: " .. module_name, vim.log.levels.ERROR)
    return {}
  end
  return module
end

-- 🎯 Load enabled modules and return plugin specs
function M.setup()
  local plugins = {}
  
  -- Always load core
  local core_plugins = M.load_module("core")
  plugins = vim.list_extend(plugins, core_plugins)
  
  -- Load enabled modules
  for module_name, module_config in pairs(M.config.modules) do
    if module_config.enabled then
      local module_plugins = M.load_module(module_name)
      plugins = vim.list_extend(plugins, module_plugins)
    end
  end
  
  -- Load enabled language modules
  for lang_name, lang_config in pairs(M.config.modules.languages) do
    if lang_config.enabled then
      local lang_plugins = M.load_module("languages." .. lang_name)
      plugins = vim.list_extend(plugins, lang_plugins)
    end
  end
  
  return plugins
end

-- 🌙 LunarVim-style commands
function M.setup_commands()
  -- Module management commands
  vim.api.nvim_create_user_command("LvimModules", function()
    local lines = { "🌙 LunarVim Modules Status:" }
    for name, config in pairs(M.config.modules) do
      local status = config.enabled and "✅" or "❌"
      table.insert(lines, string.format("  %s %s - %s", status, name, config.desc))
    end
    
    for name, config in pairs(M.config.modules.languages) do
      local status = config.enabled and "✅" or "❌"
      table.insert(lines, string.format("  %s languages.%s - %s", status, name, config.desc))
    end
    
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
  end, { desc = "Show LunarVim modules status" })
  
  vim.api.nvim_create_user_command("LvimToggleModule", function(opts)
    local module_name = opts.args
    if M.config.modules[module_name] then
      M.config.modules[module_name].enabled = not M.config.modules[module_name].enabled
      vim.notify(string.format("Module '%s' %s", module_name, 
        M.config.modules[module_name].enabled and "enabled" or "disabled"))
    else
      vim.notify("Module not found: " .. module_name, vim.log.levels.ERROR)
    end
  end, { 
    nargs = 1, 
    complete = function()
      return vim.tbl_keys(M.config.modules)
    end,
    desc = "Toggle LunarVim module on/off" 
  })
  
  vim.api.nvim_create_user_command("LvimUpdate", function()
    vim.cmd("Lazy sync")
    vim.notify("🌙 LunarVim modules updated!", vim.log.levels.INFO)
  end, { desc = "Update all LunarVim modules" })
  
  vim.api.nvim_create_user_command("LvimProfile", function()
    vim.cmd("Lazy profile")
  end, { desc = "Profile LunarVim startup performance" })
  
  vim.api.nvim_create_user_command("LvimKeymaps", function()
    vim.cmd("Legendary")
  end, { desc = "Show LunarVim keymaps guide" })
  
  vim.api.nvim_create_user_command("LvimByteBot", function(opts)
    local prompt = opts.args or "Analyze and optimize this code"
    if _G.bytebot_send then
      _G.bytebot_send(prompt)
    else
      vim.notify("ByteBot not available", vim.log.levels.WARN)
    end
  end, { 
    nargs = "?", 
    desc = "Send code to ByteBot for analysis" 
  })
  
  vim.api.nvim_create_user_command("LvimHealth", function()
    vim.cmd("checkhealth")
  end, { desc = "Run LunarVim health check" })
end

-- 🎯 LunarVim-style which-key integration
function M.setup_which_key()
  local wk = require("which-key")
  wk.register({
    ["<leader>l"] = {
      name = "🌙 LunarVim",
      v = {
        name = "🤖 AI & ByteBot",
        e = { ":LvimByteBot explain this code in detail<CR>", "Explain code" },
        r = { ":LvimByteBot refactor this code for better performance<CR>", "Refactor code" },
        t = { ":LvimByteBot generate comprehensive tests<CR>", "Generate tests" },
        d = { ":LvimByteBot add detailed documentation<CR>", "Add documentation" },
        o = { ":LvimByteBot optimize for performance<CR>", "Optimize code" },
        c = { function() require("lvim.ai").ai_chain_refactor() end, "AI Chain (explain + refactor)" },
      },
      m = { ":LvimModules<CR>", "Show modules" },
      u = { ":LvimUpdate<CR>", "Update modules" },
      p = { ":LvimProfile<CR>", "Profile startup" },
      k = { ":LvimKeymaps<CR>", "Show keymaps" },
      h = { ":LvimHealth<CR>", "Health check" },
      t = { ":LvimToggleModule ", "Toggle module" },
    }
  })
end

return M