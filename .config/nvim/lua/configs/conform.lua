local options = {
  formatters_by_ft = {
    bash = { "shfmt" },

    lua = { "stylua" },

    html = { "biome" },
    css = { "biome" },
    javascript = { "biome" },
    typescript = { "biome" },
    json = { "biome" },
    astro = { "biome" },
    svelte = { "biome" },

    dockerfile = { "hadolint" }, -- FIXME

    yaml = { "yamlfmt" },

    nginx = { "nginxfmt" },

    postgresql = { "pg_format" },
    sql = { "pg_format" },

    go = { "gofumpt", "gci" },

    makefile = { "mbake" }, -- FIXME

    python = { "ruff" },
  },

  formatters = {
    biome = {
      args = { "check", "--write", "--stdin-file-path=$FILENAME" },
    },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
