-- Plugins/collaborative.lua: Essential collaboration tools only
-- Removed heavy/niche plugins, keeping only REST client

return {
  -- REST API client (useful for web development)
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    enabled = false, -- Disabled due to build issues, enable if needed
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
}