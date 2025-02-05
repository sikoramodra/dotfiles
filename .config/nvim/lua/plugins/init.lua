return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- cmp sources
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",

      -- snippets
      --list of default snippets
      "rafamadriz/friendly-snippets",

      -- snippets engine
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        build = "make install_jsregexp",
        -- cd ~/.local/share/nvim/lazy/LuaSnip
        -- make install_jsregexp
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
        end,
      },

      -- autopairs , autocompletes ()[] etc
      {
        "windwp/nvim-autopairs",
        config = function()
          require("nvim-autopairs").setup()

          --  cmp integration
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          local cmp = require "cmp"
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
    },
    config = function()
      require "configs.cmp"
    end,
  },
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- "clangd",
        -- "clang-format",
        -- "cmake-language-server",
        "css-lsp",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "json-lsp",
        -- "jsonlint",
        "prettier",
        "eslint-lsp",
        "html-lsp",
        -- "htmlbeautifier",
        -- "htmlhint",
        "beautysh",
        "bash-language-server",
        "shfmt",
        -- "standardjs",
        -- "ts-standard",
        "svelte-language-server",
        "tailwindcss-language-server",
        "hyprls",
        "typescript-language-server",
        "gopls",
        "gofumpt",
        -- "goimports",
        "goimports-reviser",
        "golangci-lint",
        "golangci-lint-langserver",
        "golines",
        -- "gomodifytags",
        -- "gotests",
        -- "iferr",
      },
    },
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
    opts = {
      commands = {
        go = "go",
        gomodifytags = "gomodifytags",
        gotests = "gotests",
        impl = "impl",
        iferr = "iferr",
        dlv = "dlv",
      },
      gotests = {
        -- gotests doesn't have template named "default" so this plugin uses "default" to set the default template
        template = "default",
        -- path to a directory containing custom test code templates
        template_dir = nil,
        -- switch table tests from using slice to map (with test name for the key)
        -- works only with gotests installed from develop branch
        named = false,
      },
      gotag = {
        transform = "snakecase",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- "c",
        -- "cmake",
        "comment",
        -- "cpp",
        "gitignore",
        -- "qmljs",
        "css",
        "dockerfile",
        "typescript",
        "tsx",
        "html",
        "json",
        "javascript",
        "svelte",
        "hyprlang",
        "fish",
        "bash",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup {
        enable = true,
      }
    end,
    lazy = true,
    event = "VeryLazy",
  },
}
