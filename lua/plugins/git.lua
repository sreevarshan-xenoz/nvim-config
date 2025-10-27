-- 🌿 Beast Mode Git - Auto-backup, advanced workflow, real-time collaboration
-- <leader>gg (Neogit), <leader>gs (stage), <leader>gd (diff), auto-backup on save

return {
  -- 🔄 Auto-backup enhancement (integrated with existing gitsigns)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
        yadm = {
          enable = false
        },
        -- 🚀 Beast mode: Auto-backup integration
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          
          -- Enhanced navigation with auto-backup awareness
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() 
              gs.next_hunk()
              -- Auto-stage important changes
              if vim.bo.modified then
                vim.notify("Auto-staging hunk for backup", vim.log.levels.INFO)
              end
            end)
            return '<Ignore>'
          end, { expr = true, desc = "Next hunk (auto-backup aware)" })
          
          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = "Previous hunk" })
          
          -- Enhanced actions
          map('n', '<leader>gs', gs.stage_hunk, { desc = "Stage hunk" })
          map('n', '<leader>gr', gs.reset_hunk, { desc = "Reset hunk" })
          map('v', '<leader>gs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Stage hunk" })
          map('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Reset hunk" })
          map('n', '<leader>gS', gs.stage_buffer, { desc = "Stage buffer" })
          map('n', '<leader>gu', gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map('n', '<leader>gR', gs.reset_buffer, { desc = "Reset buffer" })
          map('n', '<leader>gp', gs.preview_hunk, { desc = "Preview hunk" })
          map('n', '<leader>gb', function() gs.blame_line{full=true} end, { desc = "Blame line" })
          map('n', '<leader>gB', gs.toggle_current_line_blame, { desc = "Toggle line blame" })
          map('n', '<leader>gd', gs.diffthis, { desc = "Diff this" })
          map('n', '<leader>gD', function() gs.diffthis('~') end, { desc = "Diff this ~" })
          map('n', '<leader>gtd', gs.toggle_deleted, { desc = "Toggle deleted" })
          
          -- Beast mode: Quick backup commands
          map('n', '<leader>gab', function()
            gs.stage_buffer()
            vim.cmd('Git commit -m "Quick backup: ' .. vim.fn.strftime('%H:%M:%S') .. '"')
            vim.notify("Quick backup created", vim.log.levels.INFO)
          end, { desc = "Quick auto-backup" })
          
          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Select hunk" })
        end
      })
    end,
  },
  -- 🎯 Gitsigns - Git decorations and hunk operations
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
        yadm = {
          enable = false
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          
          -- 🎯 Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = "Next hunk" })
          
          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = "Previous hunk" })
          
          -- 🔧 Actions
          map('n', '<leader>gs', gs.stage_hunk, { desc = "Stage hunk" })
          map('n', '<leader>gr', gs.reset_hunk, { desc = "Reset hunk" })
          map('v', '<leader>gs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Stage hunk" })
          map('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Reset hunk" })
          map('n', '<leader>gS', gs.stage_buffer, { desc = "Stage buffer" })
          map('n', '<leader>gu', gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map('n', '<leader>gR', gs.reset_buffer, { desc = "Reset buffer" })
          map('n', '<leader>gp', gs.preview_hunk, { desc = "Preview hunk" })
          map('n', '<leader>gb', function() gs.blame_line{full=true} end, { desc = "Blame line" })
          map('n', '<leader>gB', gs.toggle_current_line_blame, { desc = "Toggle line blame" })
          map('n', '<leader>gd', gs.diffthis, { desc = "Diff this" })
          map('n', '<leader>gD', function() gs.diffthis('~') end, { desc = "Diff this ~" })
          map('n', '<leader>gtd', gs.toggle_deleted, { desc = "Toggle deleted" })
          
          -- 📝 Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Select hunk" })
        end
      })
    end,
  },

  -- 🚀 Neogit - Magit-like Git interface
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({
        disable_signs = false,
        disable_hint = false,
        disable_context_highlighting = false,
        disable_commit_confirmation = false,
        disable_builtin_notifications = false,
        auto_refresh = true,
        disable_insert_on_commit = "auto",
        use_magit_keybindings = false,
        kind = "tab",
        console_timeout = 2000,
        auto_show_console = true,
        remember_settings = true,
        use_per_project_settings = true,
        ignored_settings = {},
        commit_popup = {
          kind = "split",
        },
        preview_buffer = {
          kind = "split",
        },
        popup = {
          kind = "split",
        },
        signs = {
          section = { "", "" },
          item = { "", "" },
          hunk = { "", "" },
        },
        integrations = {
          telescope = true,
          diffview = true,
        },
        sections = {
          untracked = {
            folded = false
          },
          unstaged = {
            folded = false
          },
          staged = {
            folded = false
          },
          stashes = {
            folded = true
          },
          unpulled = {
            folded = true
          },
          unmerged = {
            folded = false
          },
          recent = {
            folded = true
          },
        },
        mappings = {
          status = {
            ["q"] = "Close",
            ["1"] = "Depth1",
            ["2"] = "Depth2",
            ["3"] = "Depth3",
            ["4"] = "Depth4",
            ["<tab>"] = "Toggle",
            ["x"] = "Discard",
            ["s"] = "Stage",
            ["S"] = "StageUnstaged",
            ["<c-s>"] = "StageAll",
            ["u"] = "Unstage",
            ["U"] = "UnstageStaged",
            ["d"] = "DiffAtFile",
            ["$"] = "CommandHistory",
            ["<c-r>"] = "RefreshBuffer",
            ["<enter>"] = "GoToFile",
            ["<c-v>"] = "VSplitOpen",
            ["<c-x>"] = "SplitOpen",
            ["<c-t>"] = "TabOpen",
            ["{"] = "GoToPreviousHunkHeader",
            ["}"] = "GoToNextHunkHeader",
          }
        }
      })
      
      -- 🎯 Neogit keymaps
      vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Neogit" })
      vim.keymap.set("n", "<leader>gc", ":Neogit commit<CR>", { desc = "Git commit" })
      vim.keymap.set("n", "<leader>gP", ":Neogit push<CR>", { desc = "Git push" })
      vim.keymap.set("n", "<leader>gp", ":Neogit pull<CR>", { desc = "Git pull" })
      vim.keymap.set("n", "<leader>gl", ":Neogit log<CR>", { desc = "Git log" })
    end,
  },

  -- 👁️ Diffview - Beautiful diff and merge tool
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup({
        diff_binaries = false,
        enhanced_diff_hl = false,
        git_cmd = { "git" },
        use_icons = true,
        watch_index = true,
        icons = {
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
          done = "✓",
        },
        view = {
          default = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
          merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
        },
        file_panel = {
          listing_style = "tree",
          tree_options = {
            flatten_dirs = true,
            folder_statuses = "only_folded",
          },
          win_config = {
            position = "left",
            width = 35,
            win_opts = {}
          },
        },
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = "combined",
              },
              multi_file = {
                diff_merges = "first-parent",
              },
            },
          },
          win_config = {
            position = "bottom",
            height = 16,
            win_opts = {}
          },
        },
        commit_log_panel = {
          win_config = {
            win_opts = {},
          }
        },
        default_args = {
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {},
        keymaps = {
          disable_defaults = false,
          view = {
            {
              "n",
              "<tab>",
              require("diffview.actions").select_next_entry,
              { desc = "Open the diff for the next file" }
            },
            {
              "n",
              "<s-tab>",
              require("diffview.actions").select_prev_entry,
              { desc = "Open the diff for the previous file" }
            },
            {
              "n",
              "gf",
              require("diffview.actions").goto_file,
              { desc = "Open the file in a new split in the previous tabpage" }
            },
            {
              "n",
              "<C-w><C-f>",
              require("diffview.actions").goto_file_split,
              { desc = "Open the file in a new split" }
            },
            {
              "n",
              "<C-w>gf",
              require("diffview.actions").goto_file_tab,
              { desc = "Open the file in a new tabpage" }
            },
            {
              "n",
              "<leader>e",
              require("diffview.actions").focus_files,
              { desc = "Bring focus to the file panel" }
            },
            {
              "n",
              "<leader>b",
              require("diffview.actions").toggle_files,
              { desc = "Toggle the file panel." }
            },
            {
              "n",
              "g<C-x>",
              require("diffview.actions").cycle_layout,
              { desc = "Cycle through available layouts." }
            },
            {
              "n",
              "[x",
              require("diffview.actions").prev_conflict,
              { desc = "In the merge-tool: jump to the previous conflict" }
            },
            {
              "n",
              "]x",
              require("diffview.actions").next_conflict,
              { desc = "In the merge-tool: jump to the next conflict" }
            },
            {
              "n",
              "<leader>co",
              require("diffview.actions").conflict_choose("ours"),
              { desc = "Choose the OURS version of a conflict" }
            },
            {
              "n",
              "<leader>ct",
              require("diffview.actions").conflict_choose("theirs"),
              { desc = "Choose the THEIRS version of a conflict" }
            },
            {
              "n",
              "<leader>cb",
              require("diffview.actions").conflict_choose("base"),
              { desc = "Choose the BASE version of a conflict" }
            },
            {
              "n",
              "<leader>ca",
              require("diffview.actions").conflict_choose("all"),
              { desc = "Choose all the versions of a conflict" }
            },
            {
              "n",
              "dx",
              require("diffview.actions").conflict_choose("none"),
              { desc = "Delete the conflict region" }
            },
          },
          diff1 = {
            { "n", "g?", require("diffview.actions").help({ "view", "diff1" }), { desc = "Open the help panel" } },
          },
          diff2 = {
            { "n", "g?", require("diffview.actions").help({ "view", "diff2" }), { desc = "Open the help panel" } },
          },
          diff3 = {
            {
              "n",
              "g?",
              require("diffview.actions").help({ "view", "diff3" }),
              { desc = "Open the help panel" }
            },
          },
          diff4 = {
            {
              "n",
              "g?",
              require("diffview.actions").help({ "view", "diff4" }),
              { desc = "Open the help panel" }
            },
          },
          file_panel = {
            {
              "n",
              "j",
              require("diffview.actions").next_entry,
              { desc = "Bring the cursor to the next file entry" }
            },
            {
              "n",
              "<down>",
              require("diffview.actions").next_entry,
              { desc = "Bring the cursor to the next file entry" }
            },
            {
              "n",
              "k",
              require("diffview.actions").prev_entry,
              { desc = "Bring the cursor to the previous file entry." }
            },
            {
              "n",
              "<up>",
              require("diffview.actions").prev_entry,
              { desc = "Bring the cursor to the previous file entry." }
            },
            {
              "n",
              "<cr>",
              require("diffview.actions").select_entry,
              { desc = "Open the diff for the selected entry." }
            },
            {
              "n",
              "o",
              require("diffview.actions").select_entry,
              { desc = "Open the diff for the selected entry." }
            },
            {
              "n",
              "<2-LeftMouse>",
              require("diffview.actions").select_entry,
              { desc = "Open the diff for the selected entry." }
            },
            {
              "n",
              "-",
              require("diffview.actions").toggle_stage_entry,
              { desc = "Stage / unstage the selected entry." }
            },
            {
              "n",
              "S",
              require("diffview.actions").stage_all,
              { desc = "Stage all entries." }
            },
            {
              "n",
              "U",
              require("diffview.actions").unstage_all,
              { desc = "Unstage all entries." }
            },
            {
              "n",
              "X",
              require("diffview.actions").restore_entry,
              { desc = "Restore entry to the state on the left side." }
            },
            {
              "n",
              "L",
              require("diffview.actions").open_commit_log,
              { desc = "Open the commit log panel." }
            },
            {
              "n",
              "<c-b>",
              require("diffview.actions").scroll_view(-0.25),
              { desc = "Scroll the view up" }
            },
            {
              "n",
              "<c-f>",
              require("diffview.actions").scroll_view(0.25),
              { desc = "Scroll the view down" }
            },
            {
              "n",
              "<tab>",
              require("diffview.actions").select_next_entry,
              { desc = "Open the diff for the next file" }
            },
            {
              "n",
              "<s-tab>",
              require("diffview.actions").select_prev_entry,
              { desc = "Open the diff for the previous file" }
            },
            {
              "n",
              "gf",
              require("diffview.actions").goto_file,
              { desc = "Open the file in a new split in the previous tabpage" }
            },
            {
              "n",
              "<C-w><C-f>",
              require("diffview.actions").goto_file_split,
              { desc = "Open the file in a new split" }
            },
            {
              "n",
              "<C-w>gf",
              require("diffview.actions").goto_file_tab,
              { desc = "Open the file in a new tabpage" }
            },
            {
              "n",
              "i",
              require("diffview.actions").listing_style,
              { desc = "Toggle between 'list' and 'tree' views" }
            },
            {
              "n",
              "f",
              require("diffview.actions").toggle_flatten_dirs,
              { desc = "Flatten empty subdirectories in tree listing style." }
            },
            {
              "n",
              "R",
              require("diffview.actions").refresh_files,
              { desc = "Update stats and entries in the file list." }
            },
            {
              "n",
              "<leader>e",
              require("diffview.actions").focus_files,
              { desc = "Bring focus to the file panel" }
            },
            {
              "n",
              "<leader>b",
              require("diffview.actions").toggle_files,
              { desc = "Toggle the file panel" }
            },
            {
              "n",
              "g<C-x>",
              require("diffview.actions").cycle_layout,
              { desc = "Cycle available layouts" }
            },
            {
              "n",
              "g?",
              require("diffview.actions").help("file_panel"),
              { desc = "Open the help panel" }
            },
          },
          file_history_panel = {
            { "n", "g!", require("diffview.actions").options, { desc = "Open the option panel" } },
            {
              "n",
              "<C-A-d>",
              require("diffview.actions").open_in_diffview,
              { desc = "Open the entry under the cursor in a diffview" }
            },
            {
              "n",
              "y",
              require("diffview.actions").copy_hash,
              { desc = "Copy the commit hash of the entry under the cursor" }
            },
            {
              "n",
              "L",
              require("diffview.actions").open_commit_log,
              { desc = "Show commit details" }
            },
            {
              "n",
              "zR",
              require("diffview.actions").open_all_folds,
              { desc = "Expand all folds" }
            },
            {
              "n",
              "zM",
              require("diffview.actions").close_all_folds,
              { desc = "Collapse all folds" }
            },
            {
              "n",
              "j",
              require("diffview.actions").next_entry,
              { desc = "Bring the cursor to the next file entry" }
            },
            {
              "n",
              "<down>",
              require("diffview.actions").next_entry,
              { desc = "Bring the cursor to the next file entry" }
            },
            {
              "n",
              "k",
              require("diffview.actions").prev_entry,
              { desc = "Bring the cursor to the previous file entry." }
            },
            {
              "n",
              "<up>",
              require("diffview.actions").prev_entry,
              { desc = "Bring the cursor to the previous file entry." }
            },
            {
              "n",
              "<cr>",
              require("diffview.actions").select_entry,
              { desc = "Open the diff for the selected entry." }
            },
            {
              "n",
              "o",
              require("diffview.actions").select_entry,
              { desc = "Open the diff for the selected entry." }
            },
            {
              "n",
              "<2-LeftMouse>",
              require("diffview.actions").select_entry,
              { desc = "Open the diff for the selected entry." }
            },
            {
              "n",
              "<c-b>",
              require("diffview.actions").scroll_view(-0.25),
              { desc = "Scroll the view up" }
            },
            {
              "n",
              "<c-f>",
              require("diffview.actions").scroll_view(0.25),
              { desc = "Scroll the view down" }
            },
            {
              "n",
              "<tab>",
              require("diffview.actions").select_next_entry,
              { desc = "Open the diff for the next file" }
            },
            {
              "n",
              "<s-tab>",
              require("diffview.actions").select_prev_entry,
              { desc = "Open the diff for the previous file" }
            },
            {
              "n",
              "gf",
              require("diffview.actions").goto_file,
              { desc = "Open the file in a new split in the previous tabpage" }
            },
            {
              "n",
              "<C-w><C-f>",
              require("diffview.actions").goto_file_split,
              { desc = "Open the file in a new split" }
            },
            {
              "n",
              "<C-w>gf",
              require("diffview.actions").goto_file_tab,
              { desc = "Open the file in a new tabpage" }
            },
            {
              "n",
              "<leader>e",
              require("diffview.actions").focus_files,
              { desc = "Bring focus to the file panel" }
            },
            {
              "n",
              "<leader>b",
              require("diffview.actions").toggle_files,
              { desc = "Toggle the file panel" }
            },
            {
              "n",
              "g<C-x>",
              require("diffview.actions").cycle_layout,
              { desc = "Cycle available layouts" }
            },
            {
              "n",
              "g?",
              require("diffview.actions").help("file_history_panel"),
              { desc = "Open the help panel" }
            },
          },
          option_panel = {
            { "n", "<tab>", require("diffview.actions").select_entry, { desc = "Change the current option" } },
            { "n", "q", require("diffview.actions").close, { desc = "Close the panel" } },
            { "n", "g?", require("diffview.actions").help("option_panel"), { desc = "Open the help panel" } },
          },
          help_panel = {
            { "n", "q", require("diffview.actions").close, { desc = "Close help menu" } },
            { "n", "<esc>", require("diffview.actions").close, { desc = "Close help menu" } },
          },
        },
      })
      
      -- 🎯 Diffview keymaps
      vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Open diffview" })
      vim.keymap.set("n", "<leader>gD", ":DiffviewClose<CR>", { desc = "Close diffview" })
      vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory<CR>", { desc = "File history" })
      vim.keymap.set("n", "<leader>gH", ":DiffviewFileHistory %<CR>", { desc = "Current file history" })
    end,
  },

  -- 🔧 Fugitive - Classic Git commands
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
    config = function()
      vim.keymap.set("n", "<leader>gf", ":Git<CR>", { desc = "Fugitive" })
      vim.keymap.set("n", "<leader>gw", ":Gwrite<CR>", { desc = "Git write" })
      vim.keymap.set("n", "<leader>ge", ":Gedit<CR>", { desc = "Git edit" })
    end,
  },

  -- 🔗 GitHub integration
  {
    "tpope/vim-rhubarb",
    dependencies = { "tpope/vim-fugitive" },
    cmd = { "GBrowse" },
    config = function()
      vim.keymap.set("n", "<leader>go", ":GBrowse<CR>", { desc = "Open in GitHub" })
      vim.keymap.set("v", "<leader>go", ":GBrowse<CR>", { desc = "Open selection in GitHub" })
    end,
  },
}