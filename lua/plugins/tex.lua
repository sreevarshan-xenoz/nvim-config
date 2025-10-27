-- 📄 LaTeX - vimtex for academic writing

return {
  -- 📝 LaTeX support
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        hooks = {},
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_syntax_conceal_disable = 0
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_mappings_enabled = 1
      vim.g.vimtex_indent_enabled = 1
      vim.g.vimtex_format_enabled = 1
      vim.g.vimtex_imaps_enabled = 1
      vim.g.vimtex_complete_enabled = 1
      vim.g.vimtex_complete_close_braces = 1
      vim.g.vimtex_complete_ignore_case = 1
      vim.g.vimtex_complete_smart_case = 1
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_fold_manual = 0
      vim.g.vimtex_fold_types = {
        cmd_addplot = {
          cmds = { "addplot" }
        },
        cmd_multi = {
          cmds = {
            "%(re)?new%(command|environment%)",
            "providecommand",
            "presetkeys",
            "Declare%(Multi|Auto%)?CiteCommand",
            "Declare%(Index%)?%(Field|List|Name%)?Format",
            "DeclareDelimFormat",
            "DeclareFieldInputHandler",
            "DeclareBibliographyDriver",
            "DeclareNameAlias",
            "DeclareIndexNameFormat",
            "DeclareMixedCaseProtection",
            "DeclareCapitalisation",
            "DeclareBiblatexOption",
            "DeclareEntryOption",
            "DeclareFieldOption",
            "DeclareNameOption",
            "DeclareBoolOption",
            "DeclareStringOption"
          }
        },
        comments = { enabled = 0 },
        env_options = { enabled = 0 },
        envs = {
          blacklist = {},
          whitelist = { "figure", "frame", "table", "example", "answer" }
        },
        items = { enabled = 0 },
        markers = { enabled = 1 },
        preamble = { enabled = 1 },
        sections = {
          parse_levels = 0,
          sections = {
            "%(add%)?part",
            "%(chapter|addchap%)",
            "%(section|addsec%)",
            "%(subsection|addsubsec%)",
            "%(subsubsection|addsubsubsec%)",
            "paragraph",
            "subparagraph"
          }
        }
      }
      
      -- Keymaps
      vim.keymap.set("n", "<leader>ll", ":VimtexCompile<CR>", { desc = "LaTeX compile" })
      vim.keymap.set("n", "<leader>lv", ":VimtexView<CR>", { desc = "LaTeX view" })
      vim.keymap.set("n", "<leader>lc", ":VimtexClean<CR>", { desc = "LaTeX clean" })
      vim.keymap.set("n", "<leader>ls", ":VimtexStop<CR>", { desc = "LaTeX stop" })
      vim.keymap.set("n", "<leader>lt", ":VimtexTocToggle<CR>", { desc = "LaTeX TOC toggle" })
    end,
  },
}