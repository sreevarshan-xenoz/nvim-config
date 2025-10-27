-- 📊 Data & Config - schemastore, yaml-companion for structured data

return {
  -- 📋 JSON/YAML schemas
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- 🔧 YAML companion
  {
    "someone-stole-my-name/yaml-companion.nvim",
    ft = { "yaml", "yml" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("yaml-companion").setup({
        builtin_matchers = {
          kubernetes = { enabled = true },
          cloud_init = { enabled = true }
        },
        schemas = {
          {
            name = "Kubernetes",
            uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json",
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
                enable = false,
                url = "",
              },
              schemaDownload = { enable = true },
              schemas = {},
              trace = { server = "debug" },
            },
          },
        },
      })
      
      require("telescope").load_extension("yaml_schema")
      
      vim.keymap.set("n", "<leader>ys", ":Telescope yaml_schema<CR>", { desc = "YAML schema" })
    end,
  },

  -- 🗃️ CSV support
  {
    "chrisbra/csv.vim",
    ft = "csv",
    config = function()
      vim.g.csv_delim = ","
      vim.g.csv_arrange_align = "l*"
      vim.g.csv_autocmd_arrange = 1
      vim.g.csv_autocmd_arrange_size = 1024*1024
    end,
  },
}