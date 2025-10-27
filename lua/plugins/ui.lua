-- 🎨 VS Code-like Beast Mode UI - Sidebar explorer, command palette, breadcrumbs
-- Neo-tree explorer, Trouble problems panel, Legendary command palette, smooth animations

return {
  -- 🌳 Neo-tree - VS Code-like sidebar file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", ":Neotree toggle<CR>", desc = "Toggle Neo-tree explorer" },
      { "<leader>E", ":Neotree reveal<CR>", desc = "Reveal current file in Neo-tree" },
    },
    config = function()
      -- VS Code-like configuration with git integration
      require("neo-tree").setup({
        close_if_last_window = false, -- Don't close if it's the last window
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        enable_normal_mode_for_inputs = false,
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
        sort_case_insensitive = false,
        
        -- VS Code-like default component configs
        default_component_configs = {
          container = {
            enable_character_fade = true
          },
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            with_expanders = nil,
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󰜌",
            default = "*",
            highlight = "NeoTreeFileIcon"
          },
          modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              -- VS Code-like git symbols
              added     = "✚", -- or "A", but this is used when you stage a new file
              modified  = "", -- or "M", but this is used when you stage a modified file
              deleted   = "✖", -- this can only be used in the git_status source
              renamed   = "󰁕", -- this can only be used in the git_status source
              untracked = "", -- this can only be used in the git_status source
              ignored   = "", -- this can only be used in the git_status source
              unstaged  = "󰄱", -- used when the file is not staged and tracked
              staged    = "", -- used when the file is staged
              conflict  = "", -- used when the file has merge conflicts
            }
          },
        },
        
        -- VS Code-like window configuration
        window = {
          position = "left",
          width = 35,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["<space>"] = { 
              "toggle_node", 
              nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use 
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["<esc>"] = "cancel", -- close preview or floating neo-tree window
            ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
            ["l"] = "focus_preview",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["a"] = { 
              "add",
              config = {
                show_path = "none" -- "none", "relative", "absolute"
              }
            },
            ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add".
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
            ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
            ["i"] = "show_file_details",
          }
        },
        
        nesting_rules = {},
        filesystem = {
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_hidden = true, -- only works on Windows for hidden files/directories
            hide_by_name = {
              "node_modules"
            },
            hide_by_pattern = { -- uses glob style patterns
              --"*.meta",
              --"*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
              --".gitignored",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
              --".DS_Store",
              --"thumbs.db"
            },
            never_show_by_pattern = { -- uses glob style patterns
              --".null-ls_*",
            },
          },
          follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every time
            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
          group_empty_dirs = false, -- when true, empty folders will be grouped together
          hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
          use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
        },
        
        buffers = {
          follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every time
            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
          group_empty_dirs = true, -- when true, empty folders will be grouped together
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" } },
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            }
          },
        },
        
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"]  = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
              ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" } },
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            }
          }
        },
        
        -- VS Code-like event handlers
        event_handlers = {
          {
            event = "file_open_requested",
            handler = function()
              -- auto close neo-tree when opening a file
              require("neo-tree.command").execute({ action = "close" })
            end
          },
        }
      })
    end,
  },

  -- ⚠️ Trouble - VS Code-like problems panel
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble", "TroubleToggle" },
    keys = {
      { "<leader>xx", ":Trouble diagnostics toggle<CR>", desc = "Toggle Trouble diagnostics" },
      { "<leader>xw", ":Trouble workspace_diagnostics<CR>", desc = "Workspace diagnostics" },
      { "<leader>xd", ":Trouble document_diagnostics<CR>", desc = "Document diagnostics" },
      { "<leader>xl", ":Trouble loclist<CR>", desc = "Location list" },
      { "<leader>xq", ":Trouble quickfix<CR>", desc = "Quickfix list" },
    },
    config = function()
      require("trouble").setup({
        -- VS Code-like configuration
        position = "bottom", -- position of the list can be: bottom, top, left, right
        height = 10, -- height of the trouble list when position is top or bottom
        width = 50, -- width of the list when position is left or right
        icons = true, -- use devicons for filenames
        mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
        severity = nil, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
        fold_open = "", -- icon used for open folds
        fold_closed = "", -- icon used for closed folds
        group = true, -- group results by file
        padding = true, -- add an extra new line on top of the list
        cycle_results = true, -- cycle item list when reaching beginning or end of list
        action_keys = { -- key mappings for actions in the trouble list
          close = "q", -- close the list
          cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
          refresh = "r", -- manually refresh
          jump = { "<cr>", "<tab>", "<2-leftmouse>" }, -- jump to the diagnostic or open / close folds
          open_split = { "<c-x>" }, -- open buffer in new split
          open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
          open_tab = { "<c-t>" }, -- open buffer in new tab
          jump_close = { "o" }, -- jump to the diagnostic and close the list
          toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
          switch_severity = "s", -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
          toggle_preview = "P", -- toggle auto_preview
          hover = "K", -- opens a small popup with the full multiline message
          preview = "p", -- preview the diagnostic location
          open_code_href = "c", -- if present, open a URI with more information about the diagnostic error
          close_folds = { "zM", "zm" }, -- close all folds
          open_folds = { "zR", "zr" }, -- open all folds
          toggle_fold = { "zA", "za" }, -- toggle fold of current file
          previous = "k", -- previous item
          next = "j", -- next item
          help = "?" -- help menu
        },
        multiline = true, -- render multi-line messages
        indent_lines = true, -- add an indent guide below the fold icons
        win_config = { border = "single" }, -- window configuration for floating windows. See |nvim_open_win()|.
        auto_open = false, -- automatically open the list when you have diagnostics
        auto_close = false, -- automatically close the list when you have no diagnostics
        auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
        auto_fold = false, -- automatically fold a file trouble list at creation
        auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
        include_declaration = { "lsp_references", "lsp_implementations", "lsp_definitions"  }, -- for the given modes, include the declaration of the current symbol in the results
        signs = {
          -- VS Code-like icons for different severity levels
          error = "",
          warning = "",
          hint = "",
          information = "",
          other = "﫠"
        },
        use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
      })
    end,
  },

  -- 🎯 Legendary - VS Code-like command palette
  {
    "mrjones2014/legendary.nvim",
    priority = 10000,
    lazy = false,
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
      { "<C-p>", ":Legendary<CR>", desc = "Open command palette" },
      { "<leader>p", ":Legendary<CR>", desc = "Open command palette" },
    },
    config = function()
      require("legendary").setup({
        -- VS Code-like command palette configuration
        keymaps = {
          -- File operations (VS Code-like)
          { "<C-n>", ":enew<CR>", description = "New file" },
          { "<C-o>", ":Telescope find_files<CR>", description = "Open file" },
          { "<C-s>", ":w<CR>", description = "Save file" },
          { "<C-S-s>", ":wa<CR>", description = "Save all files" },
          { "<C-w>", ":bd<CR>", description = "Close file" },
          
          -- Explorer and panels
          { "<leader>e", ":Neotree toggle<CR>", description = "Toggle file explorer" },
          { "<leader>E", ":Neotree reveal<CR>", description = "Reveal in explorer" },
          { "<C-`>", ":ToggleTerm<CR>", description = "Toggle terminal" },
          { "<leader>xx", ":Trouble diagnostics toggle<CR>", description = "Toggle problems panel" },
          
          -- Search and navigation
          { "<C-f>", ":Telescope live_grep<CR>", description = "Find in files" },
          { "<C-h>", ":Telescope oldfiles<CR>", description = "Recent files" },
          { "<C-shift-p>", ":Legendary<CR>", description = "Command palette" },
          
          -- Git operations
          { "<leader>gg", ":Neogit<CR>", description = "Git status" },
          { "<leader>gb", ":Gitsigns blame_line<CR>", description = "Git blame" },
          { "<leader>gd", ":DiffviewOpen<CR>", description = "Git diff" },
          
          -- LSP operations
          { "gd", ":lua vim.lsp.buf.definition()<CR>", description = "Go to definition" },
          { "gr", ":lua vim.lsp.buf.references()<CR>", description = "Find references" },
          { "<F2>", ":lua vim.lsp.buf.rename()<CR>", description = "Rename symbol" },
          { "<C-.>", ":lua vim.lsp.buf.code_action()<CR>", description = "Code actions" },
          
          -- Debug operations
          { "<F5>", ":DapContinue<CR>", description = "Start/Continue debugging" },
          { "<F9>", ":DapToggleBreakpoint<CR>", description = "Toggle breakpoint" },
          { "<F10>", ":DapStepOver<CR>", description = "Step over" },
          { "<F11>", ":DapStepInto<CR>", description = "Step into" },
        },
        commands = {
          -- VS Code-like commands
          { ":Files", ":Telescope find_files", description = "Open file" },
          { ":Recent", ":Telescope oldfiles", description = "Recent files" },
          { ":Search", ":Telescope live_grep", description = "Search in files" },
          { ":Explorer", ":Neotree toggle", description = "Toggle file explorer" },
          { ":Problems", ":Trouble diagnostics toggle", description = "Toggle problems panel" },
          { ":Terminal", ":ToggleTerm", description = "Toggle terminal" },
          { ":Git", ":Neogit", description = "Git status" },
          { ":Blame", ":Gitsigns blame_line", description = "Git blame" },
          { ":Format", ":lua vim.lsp.buf.format()", description = "Format document" },
          { ":Rename", ":lua vim.lsp.buf.rename()", description = "Rename symbol" },
          { ":References", ":lua vim.lsp.buf.references()", description = "Find references" },
          { ":Definition", ":lua vim.lsp.buf.definition()", description = "Go to definition" },
          { ":Actions", ":lua vim.lsp.buf.code_action()", description = "Code actions" },
        },
        funcs = {},
        autocmds = {},
        -- UI configuration
        which_key = {
          auto_register = true,
          do_binding = false,
        },
        scratchpad = {
          view = "float",
          results_view = "float",
          keep_contents = true,
        },
        sort = {
          most_recent_first = true,
          user_items_first = true,
          frecency = {
            db_root = string.format("%s/legendary/", vim.fn.stdpath("data")),
            max_timestamps = 10,
          },
        },
        cache_path = string.format("%s/legendary/", vim.fn.stdpath("cache")),
        log_level = "info",
      })
    end,
  },

  -- 🍞 Barbecue - VS Code-like breadcrumbs
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>o", ":lua require('barbecue.ui').toggle()<CR>", desc = "Toggle breadcrumbs" },
    },
    config = function()
      require("barbecue").setup({
        -- VS Code-like breadcrumb configuration
        attach_navic = true, -- prevent barbecue from automatically attaching nvim-navic
        create_autocmd = true, -- prevent barbecue from updating itself automatically
        include_buftypes = { "" }, -- buftypes to enable barbecue on
        exclude_filetypes = { "netrw", "toggleterm", "alpha", "neo-tree", "Trouble" },
        modifiers = {
          dirname = ":~:.", -- filename modifiers applied to dirname
          basename = "", -- filename modifiers applied to basename
        },
        show_dirname = true, -- whether to display path to file
        show_basename = true, -- whether to display file name
        show_modified = false, -- whether to replace file icon with the modified symbol when buffer is modified
        modified = function(bufnr) return vim.bo[bufnr].modified end, -- return boolean to set modified or function(bufnr) -> boolean
        show_navic = true, -- whether to display nvim-navic winbar
        lead_custom_section = function() return " " end, -- return string to be shown at the start of barbecue
        custom_section = function() return " " end, -- return string to be shown at the end of barbecue
        theme = "auto", -- theme to use for barbecue ("auto" | "tokyonight" | "catppuccin" | ...)
        context_follow_icon_color = false, -- whether to color the icon based on the context
        symbols = {
          modified = "●", -- modification indicator
          ellipsis = "…", -- truncation indicator
          separator = "", -- entry separator
        },
        kinds = {
          File = "",
          Module = "",
          Namespace = "",
          Package = "",
          Class = "",
          Method = "",
          Property = "",
          Field = "",
          Constructor = "",
          Enum = "",
          Interface = "",
          Function = "",
          Variable = "",
          Constant = "",
          String = "",
          Number = "",
          Boolean = "",
          Array = "",
          Object = "",
          Key = "",
          Null = "",
          EnumMember = "",
          Struct = "",
          Event = "",
          Operator = "",
          TypeParameter = "",
        },
      })
    end,
  },
  -- 🚀 Alpha Dashboard - Beast mode welcome screen
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      
      -- Custom header
      dashboard.section.header.val = {
        "⚡ ███████╗██╗     ██╗████████╗███████╗",
        "⚡ ██╔════╝██║     ██║╚══██╔══╝██╔════╝",
        "⚡ █████╗  ██║     ██║   ██║   █████╗  ",
        "⚡ ██╔══╝  ██║     ██║   ██║   ██╔══╝  ",
        "⚡ ███████╗███████╗██║   ██║   ███████╗",
        "⚡ ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝",
        "",
        "    🚀 NEOVIM BEAST MODE 0.11.4+ 🚀    ",
        "   Production-ready • <150ms startup   ",
      }
      
      -- Custom buttons with beast mode actions
      dashboard.section.buttons.val = {
        dashboard.button("f", "🔍 Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", "📝 New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "📚 Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("p", "📁 Find project", ":Telescope projects <CR>"),
        dashboard.button("s", "💾 Restore session", ":SessionRestore <CR>"),
        dashboard.button("b", "🤖 ByteBot task", ":lua _G.bytebot_send('Help me start a new project') <CR>"),
        dashboard.button("u", "🔄 Update plugins", ":Lazy sync <CR>"),
        dashboard.button("c", "⚙️ Configuration", ":e ~/.config/nvim/init.lua <CR>"),
        dashboard.button("h", "🏥 Health check", ":checkhealth <CR>"),
        dashboard.button("q", "👋 Quit", ":qa <CR>"),
      }
      
      -- Footer with stats
      local function footer()
        local total_plugins = #require("lazy").plugins()
        local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
        local version = vim.version()
        local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
        
        return {
          "⚡ " .. total_plugins .. " plugins loaded in beast mode",
          "🚀 Neovim" .. nvim_version_info .. "  " .. datetime,
          "",
          "💡 Press <leader>bb to send code to ByteBot",
          "🎨 Press <leader>th to cycle themes",
          "📊 Press <leader>Lp for performance profile",
        }
      end
      
      dashboard.section.footer.val = footer()
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"
      
      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)
      
      -- Auto-open dashboard on startup
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = {
            "⚡ " .. stats.count .. " plugins loaded in " .. ms .. "ms",
            "🎯 Beast mode target: <150ms startup",
            "",
            footer()[4], footer()[5], footer()[6]
          }
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  -- 🌊 Smooth Cursor - Enhanced cursor animations
  {
    "gen740/SmoothCursor.nvim",
    event = "VeryLazy",
    config = function()
      require("smoothcursor").setup({
        type = "default",
        cursor = "",
        texthl = "SmoothCursor",
        linehl = nil,
        fancy = {
          enable = true,
          head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil },
          body = {
            { cursor = "󰝥", texthl = "SmoothCursorRed" },
            { cursor = "󰝥", texthl = "SmoothCursorOrange" },
            { cursor = "●", texthl = "SmoothCursorYellow" },
            { cursor = "●", texthl = "SmoothCursorGreen" },
            { cursor = "•", texthl = "SmoothCursorAqua" },
            { cursor = ".", texthl = "SmoothCursorBlue" },
            { cursor = ".", texthl = "SmoothCursorPurple" },
          },
          tail = { cursor = nil, texthl = "SmoothCursor" },
        },
        matrix = {
          head = {
            cursor = require("smoothcursor.matrix_chars")[math.random(#require("smoothcursor.matrix_chars"))],
            texthl = "SmoothCursor",
            linehl = nil,
          },
          body = {
            length = 6,
            cursor = require("smoothcursor.matrix_chars")[math.random(#require("smoothcursor.matrix_chars"))],
            texthl = "SmoothCursorGreen",
          },
          tail = {
            cursor = nil,
            texthl = "SmoothCursor",
          },
          unstop = false,
        },
        autostart = true,
        always_redraw = true,
        flyin_effect = nil,
        speed = 25,
        intervals = 35,
        priority = 10,
        timeout = 3000,
        threshold = 3,
        disable_float_win = false,
        enabled_filetypes = nil,
        disabled_filetypes = { "alpha", "TelescopePrompt", "lazy" },
      })
    end,
  },
  -- 🌈 Four Beautiful Themes (cycle with <leader>th)
  {
    "folke/tokyonight.nvim",
    lazy = false,  -- Load immediately for default theme
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",  -- storm, moon, night, day
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
        },
        sidebars = { "qf", "help", "terminal" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
      })
    end,
  },
  
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",  -- latte, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = true,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = true,
          mini = true,
        },
      })
    end,
  },
  
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "",  -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
    end,
  },
  
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    config = function()
      require("onedarkpro").setup({
        colors = {},
        highlights = {},
        styles = {
          types = "NONE",
          methods = "NONE",
          numbers = "NONE",
          strings = "NONE",
          comments = "italic",
          keywords = "bold,italic",
          constants = "NONE",
          functions = "italic",
          operators = "NONE",
          variables = "NONE",
          parameters = "NONE",
          conditionals = "italic",
          virtual_text = "NONE",
        },
        filetypes = {
          c = true,
          cpp = true,
          cs = true,
          java = true,
          javascript = true,
          lua = true,
          python = true,
          rust = true,
          typescript = true,
        },
        plugins = {
          native_lsp = true,
          polygot = false,
          treesitter = true,
        },
        options = {
          cursorline = false,
          transparency = false,
          terminal_colors = true,
          highlight_inactive_windows = false,
        },
      })
    end,
  },

  -- 📊 Enhanced Lualine - VS Code-like status line with tabs
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",  -- Matches current colorscheme
          globalstatus = true,  -- Single statusline for all windows
          disabled_filetypes = { 
            statusline = { "dashboard", "alpha", "neo-tree", "Trouble" },
            winbar = { "dashboard", "alpha", "neo-tree", "Trouble" }
          },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = { 
            {
              "mode",
              fmt = function(str)
                -- VS Code-like mode indicators
                local mode_map = {
                  ["NORMAL"] = "🅝",
                  ["INSERT"] = "🅘",
                  ["VISUAL"] = "🅥",
                  ["V-LINE"] = "🅥",
                  ["V-BLOCK"] = "🅥",
                  ["COMMAND"] = "🅒",
                  ["TERMINAL"] = "🅣",
                }
                return mode_map[str] or str:sub(1,1)
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
              symbols = { added = " ", modified = " ", removed = " " },
              diff_color = {
                added = { fg = "#98be65" },
                modified = { fg = "#ECBE7B" },
                removed = { fg = "#ec5f67" }
              }
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
              diagnostics_color = {
                error = { fg = "#ec5f67" },
                warn = { fg = "#ECBE7B" },
                info = { fg = "#008080" },
                hint = { fg = "#10B981" },
              },
              update_in_insert = false,
            }
          },
          lualine_c = { 
            {
              "filename",
              file_status = true,  -- Shows if file is modified
              newfile_status = true, -- Shows if file is new
              path = 1,  -- 0: Just filename, 1: Relative path, 2: Absolute path
              shorting_target = 40, -- Shortens path to leave 40 spaces in the window
              symbols = {
                modified = " ●",      -- Text to show when the file is modified
                readonly = " ",      -- Text to show when the file is non-modifiable or readonly
                unnamed = "[No Name]", -- Text to show for unnamed buffers
                newfile = "[New]",     -- Text to show for new created file before first write
              },
              color = { gui = "bold" }
            },
            {
              -- Show LSP server name
              function()
                local clients = vim.lsp.get_active_clients({ bufnr = 0 })
                if #clients == 0 then return "" end
                local names = {}
                for _, client in ipairs(clients) do
                  table.insert(names, client.name)
                end
                return " " .. table.concat(names, ", ")
              end,
              color = { fg = "#7aa2f7" }
            }
          },
          lualine_x = { 
            {
              -- Show macro recording
              function()
                local recording_register = vim.fn.reg_recording()
                if recording_register == "" then
                  return ""
                else
                  return "Recording @" .. recording_register
                end
              end,
              color = { fg = "#ff9e64" }
            },
            {
              "encoding",
              fmt = string.upper,
              color = { fg = "#7dcfff" }
            },
            {
              "fileformat",
              symbols = {
                unix = "LF",
                dos = "CRLF",
                mac = "CR",
              },
              color = { fg = "#7dcfff" }
            },
            {
              "filetype",
              colored = true,
              icon_only = false,
              icon = { align = "right" }
            }
          },
          lualine_y = { 
            {
              "progress",
              color = { gui = "bold" }
            }
          },
          lualine_z = { 
            {
              "location",
              color = { gui = "bold" }
            },
            {
              -- Show total lines
              function()
                return vim.api.nvim_buf_line_count(0) .. "L"
              end,
              color = { fg = "#9ece6a" }
            }
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 
            {
              "filename",
              file_status = true,
              path = 1
            }
          },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        -- VS Code-like tabline for buffer management
        tabline = {
          lualine_a = {
            {
              "buffers",
              show_filename_only = true,
              hide_filename_extension = false,
              show_modified_status = true,
              mode = 2, -- 0: Shows buffer name, 1: Shows buffer index, 2: Shows buffer name + buffer index
              max_length = vim.o.columns * 2 / 3,
              filetype_names = {
                TelescopePrompt = "Telescope",
                dashboard = "Dashboard",
                packer = "Packer",
                fzf = "FZF",
                alpha = "Alpha",
                neo_tree = "Neo-tree",
                Trouble = "Trouble",
              },
              buffers_color = {
                active = { fg = "#7aa2f7", bg = "#1a1b26", gui = "bold" },
                inactive = { fg = "#565f89", bg = "#16161e" },
              },
              symbols = {
                modified = " ●",
                alternate_file = "#",
                directory = "",
              },
            }
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            {
              "tabs",
              tab_max_length = 40,
              max_length = vim.o.columns / 3,
              mode = 2,
              path = 0,
              use_mode_colors = false,
              tabs_color = {
                active = { fg = "#7aa2f7", bg = "#1a1b26", gui = "bold" },
                inactive = { fg = "#565f89", bg = "#16161e" },
              },
              fmt = function(name, context)
                local buflist = vim.fn.tabpagebuflist(context.tabnr)
                local winnr = vim.fn.tabpagewinnr(context.tabnr)
                local bufnr = buflist[winnr]
                local mod = vim.fn.getbufvar(bufnr, '&mod')
                return name .. (mod == 1 and ' ●' or '')
              end
            }
          }
        },
        extensions = { "neo-tree", "trouble", "lazy", "mason", "oil" },
      })
    end,
  },

  -- 🔔 Beautiful Notifications
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
        render = "default",  -- "default", "minimal", "simple"
        stages = "fade_in_slide_out",
        timeout = 3000,
        top_down = true
      })
      
      -- Replace default notify
      vim.notify = notify
    end,
  },

  -- 🌊 Enhanced Smooth Scrolling - VS Code-like smooth animations
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("neoscroll").setup({
        -- VS Code-like smooth scrolling configuration
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = "quadratic", -- VS Code-like easing: nil, "linear", "quadratic", "cubic", "quartic", "quintic", "circular", "sine"
        performance_mode = false,
        pre_hook = function(info)
          if info == "cursorline" then
            vim.wo.cursorline = false
          end
        end,
        post_hook = function(info)
          if info == "cursorline" then
            vim.wo.cursorline = true
          end
        end,
      })
      
      -- VS Code-like scroll mappings with custom durations
      local neoscroll = require("neoscroll")
      local keymap = {
        ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 250 }) end,
        ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 250 }) end,
        ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 450 }) end,
        ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 450 }) end,
        ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor=false, duration = 100 }) end,
        ["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor=false, duration = 100 }) end,
        ["zt"]    = function() neoscroll.zt({ half_win_duration = 250 }) end,
        ["zz"]    = function() neoscroll.zz({ half_win_duration = 250 }) end,
        ["zb"]    = function() neoscroll.zb({ half_win_duration = 250 }) end,
      }
      
      local modes = { "n", "v", "x" }
      for key, func in pairs(keymap) do
        vim.keymap.set(modes, key, func)
      end
    end,
  },

  -- ✨ Mini Smooth Cursor - Enhanced cursor animations
  {
    "echasnovski/mini.animate",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("mini.animate").setup({
        -- VS Code-like cursor and scroll animations
        cursor = {
          enable = true,
          timing = function(_, n) return 150 / n end, -- VS Code-like timing
          path = function(_, _) return require("mini.animate").gen_path.line() end,
        },
        scroll = {
          enable = true,
          timing = function(_, n) return 150 / n end,
          subscroll = function(_, _) return require("mini.animate").gen_subscroll.equal() end,
        },
        resize = {
          enable = true,
          timing = function(_, n) return 150 / n end,
          subresize = function(_, _) return require("mini.animate").gen_subresize.equal() end,
        },
        open = {
          enable = true,
          timing = function(_, n) return 150 / n end,
          winconfig = function(_, _) return require("mini.animate").gen_winconfig.wipe() end,
          winblend = function(_, _) return require("mini.animate").gen_winblend.linear() end,
        },
        close = {
          enable = true,
          timing = function(_, n) return 150 / n end,
          winconfig = function(_, _) return require("mini.animate").gen_winconfig.wipe() end,
          winblend = function(_, _) return require("mini.animate").gen_winblend.linear() end,
        },
      })
    end,
  },

  -- 📏 Indent Guides - Visual indentation
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
          enabled = false,  -- Disable scope highlighting for performance
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

  -- 🎯 Icons - Beautiful file and folder icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup({
        override = {},
        default = true,
      })
    end,
  },

  -- 🌟 UI Enhancements
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "Input:",
          prompt_align = "left",
          insert_only = true,
          start_in_insert = true,
          border = "rounded",
          relative = "cursor",
          prefer_width = 40,
          width = nil,
          max_width = { 140, 0.9 },
          min_width = { 20, 0.2 },
        },
        select = {
          enabled = true,
          backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
          trim_prompt = true,
          telescope = require("telescope.themes").get_dropdown(),
        },
      })
    end,
  },
}