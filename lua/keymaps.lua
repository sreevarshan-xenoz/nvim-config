-- Neovim keymaps.lua: Leader mappings, which-key integration, theme cycling
-- 0.11+: Use vim.keymap.set for consistency

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

-- Basic mappings
keymap('n', '<leader>w', '<cmd>w!<CR>', opts)  -- Save
keymap('n', '<leader>q', '<cmd>q!<CR>', opts)  -- Quit
keymap('n', '<leader>x', '<cmd>x<CR>', opts)   -- Save and quit

-- Plugin mappings (loaded via Lazy)
keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)  -- Find files
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)   -- Grep
keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)     -- Buffers
keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)   -- Help

keymap('n', '<leader>gg', '<cmd>Neogit<CR>', opts)  -- Git UI
keymap('n', '<leader>gs', '<cmd>Gitsigns stage_hunk<CR>', opts)  -- Stage hunk

keymap('n', '<leader>th', '<cmd>lua _G.cycle_theme()<CR>', opts)  -- Cycle theme

-- Enhanced navigation and features
keymap('n', '<leader>fp', '<cmd>Telescope projects<CR>', opts)     -- Find projects
keymap('n', '<leader>fw', '<cmd>Telescope workspaces<CR>', opts)   -- Find workspaces
keymap('n', '<leader>qs', '<cmd>lua require("persistence").load()<CR>', opts)  -- Restore session

-- Debug mappings
keymap('n', '<F5>', '<cmd>lua require("dap").continue()<CR>', opts)
keymap('n', '<F10>', '<cmd>lua require("dap").step_over()<CR>', opts)
keymap('n', '<leader>db', '<cmd>lua require("dap").toggle_breakpoint()<CR>', opts)

-- Test mappings  
keymap('n', '<leader>tt', '<cmd>lua require("neotest").run.run()<CR>', opts)
keymap('n', '<leader>tf', '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', opts)
keymap('n', '<leader>ts', '<cmd>lua require("neotest").summary.toggle()<CR>', opts)

-- Oil file manager
keymap('n', '-', '<cmd>Oil<CR>', opts)  -- Open parent directory

-- Which-key setup for hints (loaded after plugins)
vim.defer_fn(function()
  local ok, wk = pcall(require, "which-key")
  if not ok then
    return
  end
  
  wk.setup({
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
      },
    },
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    popup_mappings = {
      scroll_down = '<c-d>',
      scroll_up = '<c-u>',
    },
    window = {
      border = "rounded",
      position = "bottom",
      margin = { 1, 0, 1, 0 },
      padding = { 2, 2, 2, 2 },
      winblend = 0
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },
    ignore_missing = true,
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
    show_help = true,
    show_keys = true,
    triggers = "auto",
    triggers_blacklist = {
      i = { "j", "k" },
      v = { "j", "k" },
    },
  })

  -- Register leader groups
  wk.register({
    f = { name = "Find", _ = 'which_key_ignore' },
    g = { name = "Git", _ = 'which_key_ignore' },
    t = { name = "Test/Theme", _ = 'which_key_ignore' },
    d = { name = "Debug", _ = 'which_key_ignore' },
    q = { name = "Session", _ = 'which_key_ignore' },
    c = { name = "AI/Code", _ = 'which_key_ignore' },
    v = { name = "Venv", _ = 'which_key_ignore' },
    m = { name = "Markdown", _ = 'which_key_ignore' },
  }, { prefix = "<leader>" })
end, 100)  -- Delay to ensure plugins are loaded

-- Test tips: In normal mode, press <leader> to see hints