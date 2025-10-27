-- Plugins/performance.lua: Performance monitoring and optimization for 0.11+
-- Why amazing: Real-time performance metrics, startup optimization, resource monitoring

return {
  -- Advanced startup time analysis
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Real-time performance monitoring
  {
    "stevearc/profile.nvim",
    config = function()
      local should_profile = os.getenv("NVIM_PROFILE")
      if should_profile then
        require("profile").instrument_autocmds()
        if should_profile:lower():match("^start") then
          require("profile").start("*")
        else
          require("profile").instrument("*")
        end
      end

      local function toggle_profile()
        local prof = require("profile")
        if prof.is_recording() then
          prof.stop()
          vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
            if filename then
              prof.export(filename)
              vim.notify(string.format("Wrote %s", filename))
            end
          end)
        else
          prof.start("*")
        end
      end
      vim.keymap.set("", "<f1>", toggle_profile)
    end,
  },

  -- Memory usage monitoring
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
      
      -- Auto garbage collection
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          collectgarbage("collect")
        end,
      })
    end,
  },

  -- Advanced caching system
  {
    "lewis6991/impatient.nvim",
    config = function()
      require('impatient').enable_profile()
    end,
  },

  -- Startup optimization
  {
    "nathom/filetype.nvim",
    config = function()
      require("filetype").setup({
        overrides = {
          extensions = {
            h = "c",
            hpp = "cpp",
          },
          literal = {
            MyBackupFile = "lua",
          },
          complex = {
            [".*git/config"] = "gitconfig",
          },
          function_extensions = {
            ["cpp"] = function()
              vim.bo.filetype = "cpp"
              vim.bo.cinoptions = vim.bo.cinoptions .. "L0"
            end,
            ["pdf"] = function()
              vim.bo.readonly = true
            end,
          },
          function_literal = {
            Brewfile = function()
              vim.cmd("syntax off")
            end,
          },
          function_complex = {
            ["*.math_notes/%w+"] = function()
              vim.cmd("iabbrev $ $$")
            end,
          },
          shebang = {
            dash = "sh",
          },
        },
      })
    end,
  },

  -- Buffer management optimization
  {
    "j-morano/buffer_manager.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("buffer_manager").setup({
        select_menu_item_commands = {
          v = {
            key = "<C-v>",
            command = "vsplit"
          },
          h = {
            key = "<C-h>",
            command = "split"
          }
        },
        focus_alternate_buffer = false,
        short_file_names = true,
        short_term_names = true,
        loop_nav = true,
        highlight = '',
        win_extra_options = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        order_buffers = 'lastused',
        show_indicators = 'before',
      })
    end,
    keys = {
      { "<leader>bm", function() require("buffer_manager.ui").toggle_quick_menu() end, desc = "Buffer Manager" },
    },
  },

  -- Advanced session management with performance tracking
  {
    "Shatur/neovim-session-manager",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('session_manager').setup({
        sessions_dir = require('plenary.path'):new(vim.fn.stdpath('data'), 'sessions'),
        session_filename_to_dir = session_filename_to_dir,
        dir_to_session_filename = dir_to_session_filename,
        autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
        autosave_last_session = true,
        autosave_ignore_not_normal = true,
        autosave_ignore_dirs = {},
        autosave_ignore_filetypes = {
          'gitcommit',
          'gitrebase',
        },
        autosave_ignore_buftypes = {},
        autosave_only_in_session = false,
        max_path_length = 80,
      })
    end,
    keys = {
      { "<leader>sl", "<cmd>SessionManager load_session<cr>", desc = "Load Session" },
      { "<leader>ss", "<cmd>SessionManager save_current_session<cr>", desc = "Save Session" },
      { "<leader>sd", "<cmd>SessionManager delete_session<cr>", desc = "Delete Session" },
    },
  },

  -- Resource usage visualization
  {
    "folke/which-key.nvim",
    config = function()
      -- Add performance monitoring keymaps
      require("which-key").register({
        ["<leader>p"] = {
          name = "Performance",
          m = { "<cmd>lua vim.notify(string.format('Lua Memory: %.2f MB', vim.fn.luaeval('collectgarbage(\"count\")') / 1024))<cr>", "Memory Usage" },
          s = { "<cmd>StartupTime<cr>", "Startup Time" },
          l = { "<cmd>Lazy profile<cr>", "Lazy Profile" },
          c = { "<cmd>lua collectgarbage('collect')<cr>", "Collect Garbage" },
        },
      })
    end,
  },
}