-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {
  base46 = {
    theme = "onedark",
    transparency = true,
  },
  ui = {
    cmp = {
      style = "atom",
    },
  },
  nvdash = {
    load_on_startup = true,
    header = {
      "                      ",
      "  ▄▄         ▄ ▄▄▄▄▄▄▄",
      "▄▀███▄     ▄██ █████▀ ",
      "██▄▀███▄   ███        ",
      "███  ▀███▄ ███        ",
      "███    ▀██ ███        ",
      "███      ▀ ███        ",
      "▀██ █████▄▀█▀▄██████▄ ",
      "  ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀",
      "                      ",
    },
    buttons = {
      { txt = "  Find File", keys = "f", cmd = "Telescope find_files" },
      { txt = "  Mappings", keys = "m", cmd = "NvCheatsheet" },
      { txt = "  Config", keys = "c", cmd = "e $MYVIMRC " },
      { txt = "  Quit", keys = "q", cmd = "qa" },
    },
  },
  mason = {
    pkgs = {
      -- Bash
      "bash-language-server",
      "shellcheck",
      "shfmt",

      -- Lua
      "lua-language-server",
      "stylua",

      -- Web
      "html-lsp",
      "css-lsp",
      "json-lsp",
      "typescript-language-server",
      "biome",
      "astro-language-server",
      "svelte-language-server",
      "tailwindcss-language-server",
      "unocss-language-server",

      -- Docker
      "docker-compose-language-service",
      "docker-language-server",
      "hadolint",

      -- YAML
      "yaml-language-server",
      "yamlfmt",

      -- Nginx
      "nginx-language-server",
      "nginx-config-formatter",

      -- Postgres
      "postgres-language-server",
      "pgformatter",

      -- Go
      "gopls",
      "golangci-lint-langserver",
      "gofumpt",
      "gci",

      -- Makefile
      -- "checkmake",
      "mbake",

      -- Python
      "ty",
      "ruff",

      -- Other
      "fish-lsp",
      -- "clangd",
      -- "clang-format",
      -- "cmake-language-server",
      -- "qmlls"
    },
    skip = {},
  },
}

return M
