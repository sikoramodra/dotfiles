return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
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
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        }
      })
    end,
  },
}
