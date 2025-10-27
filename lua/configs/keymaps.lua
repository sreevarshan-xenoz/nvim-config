-- ⌨️ Elite Keymaps - Leader-based with Which-key Integration
-- All mappings organized by category for easy learning

local keymap = vim.keymap.set

-- 🎯 Better defaults
keymap("n", "<C-d>", "<C-d>zz", { desc = "Half page down + center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Half page up + center" })
keymap("n", "n", "nzzzv", { desc = "Next search + center" })
keymap("n", "N", "Nzzzv", { desc = "Previous search + center" })

-- 🪟 Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- 📏 Resize windows
keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- 📋 Better copy/paste
keymap("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })
keymap({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
keymap("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
keymap({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- 🔄 Buffer management
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- 📁 Quick file operations
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", ":qa!<CR>", { desc = "Quit all without saving" })

-- 🔍 Clear search highlight
keymap("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- 📝 Better indenting
keymap("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap("v", ">", ">gv", { desc = "Indent right and reselect" })

-- 🔄 Move lines up/down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- 🎨 Theme cycling (defined in theme.lua)
keymap("n", "<leader>th", function() 
  if _G.cycle_theme then 
    _G.cycle_theme() 
  else 
    print("Theme cycling not available yet") 
  end 
end, { desc = "Cycle themes" })

-- 🏥 Health and diagnostics
keymap("n", "<leader>ch", ":checkhealth<CR>", { desc = "Health check" })

-- ===============================================
-- 🔌 PLUGIN-SPECIFIC KEYMAPS (loaded when plugins are available)
-- ===============================================

-- 🔍 TELESCOPE (Find everything)
local telescope_keys = {
  ["<leader>ff"] = { ":Telescope find_files<CR>", "Find files" },
  ["<leader>fg"] = { ":Telescope live_grep<CR>", "Live grep" },
  ["<leader>fb"] = { ":Telescope buffers<CR>", "Find buffers" },
  ["<leader>fh"] = { ":Telescope help_tags<CR>", "Help tags" },
  ["<leader>fr"] = { ":Telescope oldfiles<CR>", "Recent files" },
  ["<leader>fc"] = { ":Telescope commands<CR>", "Commands" },
  ["<leader>fk"] = { ":Telescope keymaps<CR>", "Keymaps" },
  ["<leader>fs"] = { ":Telescope grep_string<CR>", "Grep string under cursor" },
}

-- 🤖 AI CODING
local ai_keys = {
  ["<C-j>"] = { "copilot#Accept('<CR>')", "Accept Copilot suggestion", expr = true, replace_keycodes = false },
  ["<leader>cc"] = { ":ChatGPT<CR>", "ChatGPT" },
  ["<leader>ce"] = { ":ChatGPTEditWithInstructions<CR>", "ChatGPT Edit" },
  ["<leader>cr"] = { ":ChatGPTRun<CR>", "ChatGPT Run" },
}

-- 🐛 DEBUGGING
local debug_keys = {
  ["<F5>"] = { ":DapContinue<CR>", "Debug: Start/Continue" },
  ["<F10>"] = { ":DapStepOver<CR>", "Debug: Step Over" },
  ["<F11>"] = { ":DapStepInto<CR>", "Debug: Step Into" },
  ["<F12>"] = { ":DapStepOut<CR>", "Debug: Step Out" },
  ["<leader>db"] = { ":DapToggleBreakpoint<CR>", "Debug: Toggle Breakpoint" },
  ["<leader>dr"] = { ":DapToggleRepl<CR>", "Debug: Toggle REPL" },
  ["<leader>du"] = { ":lua require('dapui').toggle()<CR>", "Debug: Toggle UI" },
}

-- 🧪 TESTING
local test_keys = {
  ["<leader>tt"] = { ":lua require('neotest').run.run()<CR>", "Test: Run nearest" },
  ["<leader>tf"] = { ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>", "Test: Run file" },
  ["<leader>ts"] = { ":lua require('neotest').summary.toggle()<CR>", "Test: Toggle summary" },
  ["<leader>to"] = { ":lua require('neotest').output.open({ enter = true })<CR>", "Test: Show output" },
}

-- 📁 PROJECT MANAGEMENT
local project_keys = {
  ["<leader>fp"] = { ":Telescope projects<CR>", "Find projects" },
  ["<leader>qs"] = { ":lua require('persistence').save()<CR>", "Save session" },
  ["<leader>ql"] = { ":lua require('persistence').load()<CR>", "Load session" },
  ["-"] = { ":Oil<CR>", "Open Oil file explorer" },
}

-- 🌿 GIT
local git_keys = {
  ["<leader>gg"] = { ":Neogit<CR>", "Neogit" },
  ["<leader>gs"] = { ":Gitsigns stage_hunk<CR>", "Stage hunk" },
  ["<leader>gr"] = { ":Gitsigns reset_hunk<CR>", "Reset hunk" },
  ["<leader>gp"] = { ":Gitsigns preview_hunk<CR>", "Preview hunk" },
  ["<leader>gb"] = { ":Gitsigns blame_line<CR>", "Blame line" },
  ["<leader>gd"] = { ":DiffviewOpen<CR>", "Diff view" },
}

-- 💻 LSP
local lsp_keys = {
  ["gd"] = { ":lua vim.lsp.buf.definition()<CR>", "Go to definition" },
  ["gD"] = { ":lua vim.lsp.buf.declaration()<CR>", "Go to declaration" },
  ["gr"] = { ":lua vim.lsp.buf.references()<CR>", "Go to references" },
  ["gi"] = { ":lua vim.lsp.buf.implementation()<CR>", "Go to implementation" },
  ["<leader>ca"] = { ":lua vim.lsp.buf.code_action()<CR>", "Code actions" },
  ["<leader>rn"] = { ":lua vim.lsp.buf.rename()<CR>", "Rename symbol" },
  ["K"] = { ":lua vim.lsp.buf.hover()<CR>", "Hover documentation" },
  ["<C-k>"] = { ":lua vim.lsp.buf.signature_help()<CR>", "Signature help" },
}

-- 🔧 UTILITY
local util_keys = {
  ["<leader>xx"] = { ":Trouble<CR>", "Toggle Trouble" },
  ["<leader>xw"] = { ":Trouble workspace_diagnostics<CR>", "Workspace diagnostics" },
  ["<leader>xd"] = { ":Trouble document_diagnostics<CR>", "Document diagnostics" },
  ["<leader>xl"] = { ":Trouble loclist<CR>", "Location list" },
  ["<leader>xq"] = { ":Trouble quickfix<CR>", "Quickfix list" },
}

-- 🎯 Register all plugin keymaps
local function register_plugin_keys()
  local all_keys = {
    telescope_keys,
    ai_keys,
    debug_keys,
    test_keys,
    project_keys,
    git_keys,
    lsp_keys,
    util_keys,
  }
  
  for _, key_group in ipairs(all_keys) do
    for key, config in pairs(key_group) do
      local cmd, desc = config[1], config[2]
      local opts = { desc = desc, noremap = true, silent = true }
      
      -- Handle special options
      if config.expr then opts.expr = true end
      if config.replace_keycodes == false then opts.replace_keycodes = false end
      
      keymap("n", key, cmd, opts)
    end
  end
end

-- 📅 Defer plugin keymap registration until plugins are loaded
vim.defer_fn(register_plugin_keys, 100)

-- 🎪 Which-key integration (will be configured in plugins/ui.lua)
-- This provides the visual guide for all these keymaps