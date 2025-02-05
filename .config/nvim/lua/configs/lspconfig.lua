-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

-- EXAMPLE
local servers = {
  "html",
  "cssls",
  -- "clangd",
  -- "cmake",
  -- "qmlls6",
  "bashls",
  "dockerls",
  "docker_compose_language_service",
  "eslint",
  "jsonls",
  "svelte",
  "tailwindcss",
  "ts_ls",
  "hyprls",
}
local nvlsp = require "nvchad.configs.lspconfig"

-- local configs = require "lspconfig.configs"
-- if not configs.qmlls6 then
--   configs.qmlls6 = {
--     default_config = {
--       cmd = { "qmlls6" },
--       filetypes = { "qml" },
--       root_dir = lspconfig.util.root_pattern ".git",
--     },
--   }
-- end

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

lspconfig.gopls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}

-- lspconfig.golangci_lint_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
--   cmd = { "golangci-lint-langserver" },
--   filetypes = { "go", "gomod" },
--   root_dir = util.root_pattern("go.work", "go.mod", ".git"),
--   init_options = {
--     command = {
--       "golangci-lint",
--       "run",
--       "--enable-all",
--       "--disable",
--       "lll",
--       "--out-format",
--       "json",
--       "--issues-exit-code=1",
--     },
--   },
-- }

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
