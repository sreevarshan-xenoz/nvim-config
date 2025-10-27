-- 🎨 Theme Management - Cycle between 4 beautiful themes
-- tokyonight (default), catppuccin, gruvbox, onedarkpro

local M = {}

-- 🌈 Available themes in order
local themes = { 
  'tokyonight', 
  'catppuccin', 
  'gruvbox', 
  'onedarkpro' 
}

local current_theme = 1

-- 🔄 Cycle through themes
function M.cycle_theme()
  current_theme = (current_theme % #themes) + 1
  local theme = themes[current_theme]
  
  local ok, _ = pcall(vim.cmd.colorscheme, theme)
  if ok then
    print("🎨 Switched to " .. theme)
    -- Save preference for next session
    vim.g.current_theme = theme
  else
    print("❌ Theme " .. theme .. " not available - run :Lazy sync")
    -- Fallback to previous theme
    current_theme = current_theme == 1 and #themes or current_theme - 1
  end
end

-- 🎯 Set default theme with fallback
function M.setup()
  -- Try to restore saved theme
  local saved_theme = vim.g.current_theme
  if saved_theme then
    for i, theme in ipairs(themes) do
      if theme == saved_theme then
        current_theme = i
        break
      end
    end
  end
  
  -- Apply default theme (tokyonight)
  local ok, _ = pcall(vim.cmd.colorscheme, themes[current_theme])
  if not ok then
    -- Fallback to built-in theme
    vim.cmd.colorscheme('default')
    print("🎨 Using default colorscheme - install themes with :Lazy sync")
  else
    print("🎨 Loaded " .. themes[current_theme] .. " theme")
  end
end

-- 🌟 Expose functions globally for keymaps
_G.cycle_theme = M.cycle_theme

-- 🚀 Auto-setup when loaded
vim.defer_fn(M.setup, 200)  -- Delay to ensure themes are loaded

return M