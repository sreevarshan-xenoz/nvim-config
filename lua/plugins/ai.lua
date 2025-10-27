-- Plugins/ai.lua: AI-powered coding assistance for 0.11+
-- Why amazing: GitHub Copilot for code suggestions, ChatGPT for explanations and refactoring

return {
  -- GitHub Copilot - AI pair programming
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      
      -- Custom accept mapping
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        silent = true,
      })
      
      -- Additional mappings
      vim.keymap.set('i', '<C-H>', '<Plug>(copilot-dismiss)', { silent = true })
      vim.keymap.set('i', '<C-N>', '<Plug>(copilot-next)', { silent = true })
      vim.keymap.set('i', '<C-P>', '<Plug>(copilot-previous)', { silent = true })
      
      -- Copilot panel
      vim.keymap.set('n', '<leader>cp', '<cmd>Copilot panel<CR>', { desc = "Copilot: Open Panel" })
    end,
  },
  
  -- ChatGPT integration (optional - requires OpenAI API key)
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    enabled = false, -- Enable this if you have OpenAI API key
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "echo $OPENAI_API_KEY", -- Set your API key as environment variable
        openai_params = {
          model = "gpt-3.5-turbo",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 300,
          temperature = 0,
          top_p = 1,
          n = 1,
        },
        openai_edit_params = {
          model = "code-davinci-edit-001",
          temperature = 0,
          top_p = 1,
          n = 1,
        },
        use_openai_functions_for_edits = false,
        actions_paths = {"~/.config/nvim/gpt/actions.json"},
        show_quickfixes_cmd = "Trouble quickfix",
        predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
        highlights = {
          help_key = "@symbol",
          help_description = "@comment",
        }
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    },
    keys = {
      { "<leader>cc", "<cmd>ChatGPT<CR>", desc = "ChatGPT: Open Chat" },
      { "<leader>ce", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "ChatGPT: Edit with instruction", mode = { "n", "v" } },
      { "<leader>cg", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "ChatGPT: Grammar Correction", mode = { "n", "v" } },
      { "<leader>ct", "<cmd>ChatGPTRun translate<CR>", desc = "ChatGPT: Translate", mode = { "n", "v" } },
      { "<leader>ck", "<cmd>ChatGPTRun keywords<CR>", desc = "ChatGPT: Keywords", mode = { "n", "v" } },
      { "<leader>cd", "<cmd>ChatGPTRun docstring<CR>", desc = "ChatGPT: Docstring", mode = { "n", "v" } },
      { "<leader>ca", "<cmd>ChatGPTRun add_tests<CR>", desc = "ChatGPT: Add Tests", mode = { "n", "v" } },
      { "<leader>co", "<cmd>ChatGPTRun optimize_code<CR>", desc = "ChatGPT: Optimize Code", mode = { "n", "v" } },
      { "<leader>cs", "<cmd>ChatGPTRun summarize<CR>", desc = "ChatGPT: Summarize", mode = { "n", "v" } },
      { "<leader>cf", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "ChatGPT: Fix Bugs", mode = { "n", "v" } },
      { "<leader>cx", "<cmd>ChatGPTRun explain_code<CR>", desc = "ChatGPT: Explain Code", mode = { "n", "v" } },
      { "<leader>cr", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "ChatGPT: Roxygen Edit", mode = { "n", "v" } },
      { "<leader>cl", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "ChatGPT: Code Readability Analysis", mode = { "n", "v" } },
    },
  },
  
  -- Codeium (Free alternative to Copilot)
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    enabled = false, -- Enable this as alternative to Copilot
    config = function()
      vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    end
  },
  -- Test: In insert mode, Ctrl+J to accept Copilot suggestions, <leader>cp for panel
  -- Note: ChatGPT requires OPENAI_API_KEY environment variable
}