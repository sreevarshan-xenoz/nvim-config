-- Plugins/collaborative.lua: Collaborative coding and cloud integration for 0.11+
-- Why amazing: Real-time collaboration, cloud sync, remote development

return {
  -- Real-time collaborative editing
  {
    "jbyuki/instant.nvim",
    config = function()
      vim.g.instant_username = "your_username"
    end,
    keys = {
      { "<leader>is", "<cmd>InstantStartServer<cr>", desc = "Start Collaboration Server" },
      { "<leader>ij", "<cmd>InstantJoinSession<cr>", desc = "Join Collaboration" },
      { "<leader>il", "<cmd>InstantStartSingle<cr>", desc = "Start Single Session" },
      { "<leader>if", "<cmd>InstantFollow<cr>", desc = "Follow Collaborator" },
      { "<leader>it", "<cmd>InstantStopFollow<cr>", desc = "Stop Following" },
    },
  },

  -- Advanced note-taking and knowledge management
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/notes",
                work = "~/work/notes",
              },
              default_workspace = "notes",
            },
          },
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          ["core.integrations.nvim-cmp"] = {},
          ["core.journal"] = {
            config = {
              strategy = "flat",
            },
          },
          ["core.keybinds"] = {
            config = {
              default_keybinds = true,
            },
          },
        },
      }
    end,
    keys = {
      { "<leader>nw", "<cmd>Neorg workspace<cr>", desc = "Neorg Workspace" },
      { "<leader>nj", "<cmd>Neorg journal<cr>", desc = "Neorg Journal" },
    },
  },

  -- Advanced database integration
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    config = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_winwidth = 30
      vim.g.db_ui_notification_width = 50
    end,
    keys = {
      { "<leader>du", "<cmd>DBUIToggle<cr>", desc = "Database UI" },
      { "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "DB Find Buffer" },
      { "<leader>dr", "<cmd>DBUIRenameBuffer<cr>", desc = "DB Rename Buffer" },
      { "<leader>dl", "<cmd>DBUILastQueryInfo<cr>", desc = "DB Last Query" },
    },
  },

  -- REST API client
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup({
        result_split_horizontal = false,
        result_split_in_place = false,
        skip_ssl_verification = false,
        encode_url = true,
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          show_url = true,
          show_curl_command = false,
          show_http_info = true,
          show_headers = true,
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
            end
          },
        },
        jump_to_request = false,
        env_file = '.env',
        custom_dynamic_variables = {},
        yank_dry_run = true,
      })
    end,
    keys = {
      { "<leader>rn", "<Plug>RestNvim", desc = "Run REST Request" },
      { "<leader>rp", "<Plug>RestNvimPreview", desc = "Preview REST Request" },
      { "<leader>rl", "<Plug>RestNvimLast", desc = "Run Last REST Request" },
    },
  },

  -- Advanced file synchronization
  {
    "elihunter173/dirbuf.nvim",
    config = function()
      require("dirbuf").setup({
        hash_padding = 2,
        show_hidden = true,
        sort_order = "default",
        write_cmd = "DirbufSync",
      })
    end,
    keys = {
      { "<leader>db", "<cmd>Dirbuf<cr>", desc = "Directory Buffer" },
    },
  },

  -- Cloud storage integration
  {
    "rktjmp/paperplanes.nvim",
    config = function()
      require("paperplanes").setup({
        register = "+",
        provider = "0x0.st",
        provider_options = {},
        notifier = vim.notify or print,
      })
    end,
    keys = {
      { "<leader>pp", function() require("paperplanes").share_selection() end, mode = "v", desc = "Share Selection" },
      { "<leader>pf", function() require("paperplanes").share_file() end, desc = "Share File" },
    },
  },

  -- Advanced terminal and tmux integration
  {
    "aserowy/tmux.nvim",
    config = function()
      return require("tmux").setup({
        copy_sync = {
          enable = true,
          ignore_buffers = { empty = false },
          redirect_to_clipboard = false,
        },
        navigation = {
          cycle_navigation = true,
          enable_default_keybindings = true,
        },
        resize = {
          enable_default_keybindings = true,
          resize_step_x = 1,
          resize_step_y = 1,
        }
      })
    end,
  },

  -- Remote development support
  {
    "chipsenkbeil/distant.nvim",
    branch = 'v0.3',
    config = function()
      require('distant'):setup()
    end,
    keys = {
      { "<leader>dc", "<cmd>DistantConnect<cr>", desc = "Distant Connect" },
      { "<leader>dl", "<cmd>DistantLaunch<cr>", desc = "Distant Launch" },
    },
  },
}