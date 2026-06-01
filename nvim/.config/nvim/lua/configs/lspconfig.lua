require("nvchad.configs.lspconfig").defaults()

local servers = {
  "bashls",
  "lua_ls",
  "html",
  "cssls",
  "jsonls",
  "ts_ls",
  "biome",
  "astro",
  "svelte",
  "tailwindcss",
  "unocss",
  "docker_compose_language_service",
  "docker_language_server",
  "yaml",
  "nginx_language_server",
  "postgres_lsp",
  "golangci_lint_ls",
  "ty",
  "fish_lsp",
}

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
