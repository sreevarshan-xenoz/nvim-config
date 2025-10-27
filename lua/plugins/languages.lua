-- Plugins/languages.lua: Language-specific enhancements for 0.11+
-- Why amazing: Rust tools, Python venv, Markdown preview, JSON schemas, and more

return {
  -- Rust tools and enhancements
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      local rt = require("rust-tools")
      rt.setup({
        server = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
        tools = {
          hover_actions = {
            auto_focus = false,
          },
          inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
          },
        },
        dap = {
          adapter = {
            type = "executable",
            command = "lldb-vscode",
            name = "rt_lldb",
          },
        },
      })
    end,
  },
  
  -- Crates.io integration for Rust
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    config = function()
      require("crates").setup({
        src = {
          cmp = { enabled = true },
        },
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
        popup = {
          autofocus = false,
          hide_on_select = false,
          copy_register = '"',
          style = "minimal",
          border = "none",
          show_version_date = false,
          show_dependency_version = true,
          max_height = 30,
          min_width = 20,
          padding = 1,
        },
        completion = {
          cmp = {
            enabled = true,
          },
        },
      })
    end,
  },
  
  -- Python virtual environment selector
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    config = function()
      require("venv-selector").setup({
        auto_refresh = false,
        search_venv_managers = true,
        search_workspace = true,
        search = true,
        dap_enabled = true,
        parents = 2,
        name = {
          "venv",
          ".venv",
          "env",
          ".env",
        },
        fd_binary_name = "fd",
        notify_user_on_activate = true,
      })
    end,
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" },
    },
  },
  
  -- Python DAP configuration
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end,
  },
  
  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    config = function()
      vim.cmd([[do FileType]])
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
  },
  
  -- Enhanced markdown editing
  {
    "plasticboy/vim-markdown",
    ft = "markdown",
    dependencies = { "godlygeek/tabular" },
    config = function()
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_conceal = 0
      vim.g.vim_markdown_conceal_code_blocks = 0
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_toml_frontmatter = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_strikethrough = 1
      vim.g.vim_markdown_autowrite = 1
      vim.g.vim_markdown_edit_url_in = 'tab'
      vim.g.vim_markdown_follow_anchor = 1
    end,
  },
  
  -- JSON schema support
  {
    "b0o/schemastore.nvim",
    ft = { "json", "jsonc" },
    config = function()
      require("lspconfig").jsonls.setup({
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
    end,
  },
  
  -- YAML schema support
  {
    "someone-stole-my-name/yaml-companion.nvim",
    ft = { "yaml" },
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
      local cfg = require("yaml-companion").setup({
        builtin_matchers = {
          kubernetes = { enabled = true },
          cloud_init = { enabled = true }
        },
        schemas = {
          {
            name = "Kustomization",
            uri = "https://json.schemastore.org/kustomization.json",
          },
          {
            name = "GitHub Workflow",
            uri = "https://json.schemastore.org/github-workflow.json",
          },
        },
        lspconfig = {
          flags = {
            debounce_text_changes = 150,
          },
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              validate = true,
              format = { enable = true },
              hover = true,
              schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
              schemaDownload = { enable = true },
              schemas = {},
              trace = { server = "debug" },
            },
          },
        },
      })
      require("lspconfig")["yamlls"].setup(cfg)
    end,
  },
  
  -- TypeScript/JavaScript enhancements
  {
    "jose-elias-alvarez/typescript.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      require("typescript").setup({
        disable_commands = false,
        debug = false,
        go_to_source_definition = {
          fallback = true,
        },
        server = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        },
      })
    end,
  },
  
  -- Package.json helper
  {
    "vuki656/package-info.nvim",
    ft = "json",
    config = function()
      require("package-info").setup({
        colors = {
          up_to_date = "#3C4048",
          outdated = "#d19a66",
        },
        icons = {
          enable = true,
          style = {
            up_to_date = "|  ",
            outdated = "|  ",
          },
        },
        autostart = true,
        hide_up_to_date = false,
        hide_unstable_versions = false,
        package_manager = "npm"
      })
    end,
  },
  
  -- LaTeX support
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        build_dir = '',
        callback = 1,
        continuous = 1,
        executable = 'latexmk',
        hooks = {},
        options = {
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-interaction=nonstopmode',
        },
      }
    end,
  },
  -- Test: Rust hover with Ctrl+Space, Python venv with <leader>vs, Markdown preview with <leader>mp
}