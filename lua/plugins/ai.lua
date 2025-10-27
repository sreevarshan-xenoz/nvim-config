-- 🤖 AI Coding - Copilot & ChatGPT for supercharged development
-- Ctrl+J (Copilot accept), <leader>cc (ChatGPT), <leader>ce (AI edit)

return {
  -- 🚁 GitHub Copilot - AI pair programming
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Disable default Tab mapping (we use Ctrl+J)
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      
      -- Enable for specific filetypes
      vim.g.copilot_filetypes = {
        ["*"] = false,
        ["javascript"] = true,
        ["typescript"] = true,
        ["lua"] = true,
        ["rust"] = true,
        ["c"] = true,
        ["c#"] = true,
        ["c++"] = true,
        ["go"] = true,
        ["python"] = true,
      }
      
      -- Custom keymaps for Copilot
      vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion"
      })
      
      vim.keymap.set('i', '<C-;>', '<Plug>(copilot-next)', { desc = "Next Copilot suggestion" })
      vim.keymap.set('i', '<C-,>', '<Plug>(copilot-previous)', { desc = "Previous Copilot suggestion" })
      vim.keymap.set('i', '<C-\\>', '<Plug>(copilot-dismiss)', { desc = "Dismiss Copilot suggestion" })
      vim.keymap.set('n', '<leader>cp', '<cmd>Copilot panel<CR>', { desc = "Copilot panel" })
    end,
  },

  -- 💬 ChatGPT Integration - AI chat and code editing
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    enabled = true,  -- Enable by default, will gracefully fail without API key
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "echo $OPENAI_API_KEY",  -- Set this environment variable
        openai_params = {
          model = "gpt-4",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 1000,
          temperature = 0.2,
          top_p = 1,
          n = 1,
        },
        openai_edit_params = {
          model = "gpt-4",
          frequency_penalty = 0,
          presence_penalty = 0,
          temperature = 0,
          top_p = 1,
          n = 1,
        },
        chat = {
          welcome_message = "🤖 ChatGPT ready! Ask me anything about code.",
          loading_text = "Loading, please wait ...",
          question_sign = "",
          answer_sign = "ﮧ",
          max_line_length = 120,
          sessions_window = {
            border = {
              style = "rounded",
              text = {
                top = " Sessions ",
              },
            },
            win_config = {
              height = "50%",
              width = "50%",
            },
          },
        },
        popup_layout = {
          default = "center",
          center = {
            width = "80%",
            height = "80%",
          },
          right = {
            width = "30%",
            width_settings_open = "50%",
          },
        },
        popup_window = {
          border = {
            highlight = "FloatBorder",
            style = "rounded",
            text = {
              top = " ChatGPT ",
            },
          },
          win_config = {
            wrap = true,
            linebreak = true,
            foldcolumn = "1",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
          buf_config = {
            modifiable = true,
            readonly = false,
            filetype = "markdown",
          },
        },
        system_window = {
          border = {
            highlight = "FloatBorder",
            style = "rounded",
            text = {
              top = " SYSTEM ",
            },
          },
          win_config = {
            wrap = true,
            linebreak = true,
            foldcolumn = "2",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
        popup_input = {
          prompt = "  ",
          border = {
            highlight = "FloatBorder",
            style = "rounded",
            text = {
              top_align = "center",
              top = " Prompt ",
            },
          },
          win_config = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
          buf_config = {
            filetype = "markdown",
          },
          submit = "<C-Enter>",
          submit_n = "<Enter>",
          max_visible_lines = 20,
        },
        settings_window = {
          border = {
            style = "rounded",
            text = {
              top = " Settings ",
            },
          },
          win_config = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
        keymaps = {
          close = { "<C-c>" },
          submit = "<C-Enter>",
          submit_n = "<Enter>",
          yank_last = "<C-y>",
          yank_last_code = "<C-k>",
          scroll_up = "<C-u>",
          scroll_down = "<C-d>",
          new_session = "<C-n>",
          cycle_windows = "<Tab>",
          cycle_modes = "<C-f>",
          select_session = "<Space>",
          rename_session = "r",
          delete_session = "d",
          draft_message = "<C-d>",
          toggle_settings = "<C-o>",
          toggle_message_role = "<C-r>",
          toggle_system_role_open = "<C-s>",
          stop_generating = "<C-x>",
        },
      })
      
      -- Custom keymaps
      vim.keymap.set("n", "<leader>cc", ":ChatGPT<CR>", { desc = "ChatGPT" })
      vim.keymap.set("n", "<leader>ce", ":ChatGPTEditWithInstructions<CR>", { desc = "ChatGPT Edit" })
      vim.keymap.set("v", "<leader>ce", ":ChatGPTEditWithInstructions<CR>", { desc = "ChatGPT Edit Selection" })
      vim.keymap.set("n", "<leader>cr", ":ChatGPTRun<CR>", { desc = "ChatGPT Run" })
      vim.keymap.set("v", "<leader>cr", ":ChatGPTRun<CR>", { desc = "ChatGPT Run Selection" })
      vim.keymap.set("n", "<leader>ca", ":ChatGPTActAs<CR>", { desc = "ChatGPT Act As" })
      vim.keymap.set("n", "<leader>cs", ":ChatGPTCompleteCode<CR>", { desc = "ChatGPT Complete Code" })
      vim.keymap.set("v", "<leader>cs", ":ChatGPTCompleteCode<CR>", { desc = "ChatGPT Complete Code" })
    end,
  },

  -- 🧠 Alternative AI - Codeium (backup for Copilot)
  {
    "Exafunction/codeium.nvim",
    enabled = false,  -- Disabled by default, enable if needed
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
        enable_chat = true,
      })
    end,
  },
}