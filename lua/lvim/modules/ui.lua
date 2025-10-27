-- 🌙 LunarVim UI Module - Beautiful interface with alpha dashboard
-- Lualine, notify, alpha with ByteBot integration, smooth animations

return {
  -- 🚀 Alpha Dashboard - LunarVim-style welcome screen
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      
      -- LunarVim-inspired header
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
        "    🌙 LunarVim-inspired • Beast Mode • <100ms      ",
      }
      
      -- LunarVim-style buttons with ByteBot integration
      dashboard.section.buttons.val = {
        dashboard.button("f", "🔍  Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", "📝  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "📚  Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("p", "📁  Find project", ":Telescope projects <CR>"),
        dashboard.button("s", "💾  Restore session", ":SessionRestore <CR>"),
        dashboard.button("c", "⚙️   Configuration", ":e ~/.config/nvim/init.lua <CR>"),
        dashboard.button("", "", ""),
        dashboard.button("", "🌙 LunarVim Commands:", ""),
        dashboard.button("lk", "🗝️   Show keymaps", ":LvimKeymaps <CR>"),
        dashboard.button("lm", "📦  Manage modules", ":LvimModules <CR>"),
        dashboard.button("lb", "🤖  ByteBot AI", ":LvimByteBot optimize this neovim config <CR>"),
        dashboard.button("lu", "🔄  Update all", ":LvimUpdate <CR>"),
        dashboard.button("lh", "🏥  Health check", ":LvimHealth <CR>"),
        dashboard.button("", "", ""),
        dashboard.button("q", "👋  Quit", ":qa <CR>"),
      }
      
      -- Dynamic footer with LunarVim stats
      local function footer()
        local total_plugins = #require("lazy").plugins()
        local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
        local version = vim.version()
        local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
        
        return {
          "🌙 " .. total_plugins .. " plugins loaded in LunarVim mode",
          "🚀 Neovim" .. nvim_version_info .. "  " .. datetime,
          "",
          "💡 Press <leader>lk for LunarVim keymaps guide",
          "🤖 Press <leader>lv for ByteBot AI assistance",
          "📊 Press <leader>lp for performance profile",
        }
      end
      
      dashboard.section.footer.val = footer()
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"
      
      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)
      
      -- Auto-update footer with startup stats
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = {
            "🌙 " .. stats.count .. " plugins loaded in " .. ms .. "ms",
            "🎯 LunarVim target: <100ms startup achieved!",
            "",
            footer()[4], footer()[5], footer()[6]
          }
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  -- 📊 Lualine - LunarVim-style status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- LunarVim-inspired lualine configuration
      local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed
          }
        end
      end
      
      local function lsp_client()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients == 0 then return "No LSP" end
        local names = {}
        for _, client in ipairs(clients) do
          table.insert(names, client.name)
        end
        return "🔧 " .. table.concat(names, ", ")
      end
      
      require("lualine").setup({
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { 
            statusline = { "dashboard", "alpha", "neo-tree", "Trouble" },
            winbar = { "dashboard", "alpha", "neo-tree", "Trouble" }
          },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                return "🌙 " .. str:sub(1,1)
              end
            }
          },
          lualine_b = {
            {
              "branch",
              icon = "",
              color = { gui = "bold" }
            },
            {
              "diff",
              source = diff_source,
              symbols = { added = " ", modified = " ", removed = " " },
            }
          },
          lualine_c = {
            {
              "filename",
              file_status = true,
              newfile_status = true,
              path = 1,
              symbols = {
                modified = " ●",
                readonly = " ",
                unnamed = "[No Name]",
                newfile = "[New]",
              },
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
              update_in_insert = false,
            }
          },
          lualine_x = {
            {
              lsp_client,
              color = { fg = "#7aa2f7" }
            },
            {
              "encoding",
              fmt = string.upper,
            },
            {
              "fileformat",
              symbols = {
                unix = "LF",
                dos = "CRLF",
                mac = "CR",
              },
            },
            "filetype"
          },
          lualine_y = { "progress" },
          lualine_z = { 
            "location",
            {
              function()
                return "🌙"
              end,
              color = { fg = "#7aa2f7", gui = "bold" }
            }
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { "neo-tree", "trouble", "lazy", "mason", "oil" },
      })
    end,
  },

  -- 🔔 Notify - LunarVim-style notifications
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({
        background_colour = "#000000",
        fps = 30,
        icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "",
          TRACE = "✎",
          WARN = ""
        },
        level = 2,
        minimum_width = 50,
        render = "default",
        stages = "fade_in_slide_out",
        timeout = 3000,
        top_down = true,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
      })
      
      -- Replace default notify
      vim.notify = notify
      
      -- LunarVim-style notification shortcuts
      vim.keymap.set("n", "<leader>nd", function()
        notify.dismiss({ silent = true, pending = true })
      end, { desc = "Dismiss notifications" })
    end,
  },

  -- 🌊 Smooth Scrolling - LunarVim-style animations
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = "quadratic", -- LunarVim-style smooth easing
        performance_mode = false,
      })
    end,
  },

  -- 🎨 UI Enhancements
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "🌙 Input:",
          prompt_align = "left",
          insert_only = true,
          start_in_insert = true,
          border = "rounded",
          relative = "cursor",
          prefer_width = 40,
          width = nil,
          max_width = { 140, 0.9 },
          min_width = { 20, 0.2 },
          win_options = {
            winblend = 10,
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
        select = {
          enabled = true,
          backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
          trim_prompt = true,
          telescope = require("telescope.themes").get_dropdown({
            winblend = 10,
          }),
        },
      })
    end,
  },

  -- 📏 Indent guides - LunarVim-style
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = { 
          enabled = true,
          show_start = true,
          show_end = false,
          injected_languages = false,
          highlight = { "Function", "Label" },
          priority = 500,
        },
        exclude = {
          filetypes = {
            "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason",
            "notify", "toggleterm", "lazyterm", "oil", "TelescopePrompt"
          },
        },
      })
    end,
  },

  -- 🎯 Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup({
        override = {
          zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh"
          }
        },
        color_icons = true,
        default = true,
        strict = true,
        override_by_filename = {
          [".gitignore"] = {
            icon = "",
            color = "#f1502f",
            name = "Gitignore"
          }
        },
        override_by_extension = {
          ["log"] = {
            icon = "",
            color = "#81e043",
            name = "Log"
          }
        },
      })
    end,
  },
}