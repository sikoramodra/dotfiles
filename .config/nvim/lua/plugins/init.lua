return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "lua",
        "html",
        "html_tags",
        "css",
        "javascript",
        "jsdoc",
        "typescript",
        "json",
        "astro",
        "svelte",
        "dockerfile",
        "yaml",
        "nginx",
        "sql",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "proto",
        "make",
        "python",

        "fish",
        "csv",
        "toml",
        "diff",
        "xml",
        -- "cmake",
        -- "cpp",
        -- "qmldir",
        -- "qmljs",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local cmp = require "cmp"
      local conf = require "nvchad.configs.cmp"

      local intellji_autocomplete = {
        ["<Tab>"] = cmp.mapping(function(fallback)
          -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
          if cmp.visible() then
            local entry = cmp.get_selected_entry()
            if not entry then
              cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
            end
            cmp.confirm()
          else
            fallback()
          end
        end, { "i", "s" }),
      }

      conf.mapping =
        vim.tbl_deep_extend("force", conf.mapping, intellji_autocomplete)
      return conf
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-ts-autotag").setup {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      }
    end,
  },
}
