return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false,

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      markdown = {
        horizontal_rules = {
          enable = true,
          parts = {
            {
              type = "repeating",
              direction = "right",

              repeat_amount = function (buffer) --[[@as function]]
                local utils = require("markview.utils");
                local window = utils.buf_getwin(buffer)

                local width = vim.api.nvim_win_get_width(window)
                local textoff = vim.fn.getwininfo(window)[1].textoff;

                return math.ceil(width - textoff - 3);
              end,

              text = "─",
              hl = {
                "MarkviewGradient1", "MarkviewGradient1",
                "MarkviewGradient2", "MarkviewGradient2",
                "MarkviewGradient3", "MarkviewGradient3",
                "MarkviewGradient4", "MarkviewGradient4",
                "MarkviewGradient5", "MarkviewGradient5",
                "MarkviewGradient6", "MarkviewGradient6",
                "MarkviewGradient7", "MarkviewGradient7",
                "MarkviewGradient8", "MarkviewGradient8",
                "MarkviewGradient9", "MarkviewGradient9"
              }
            }
          }
        }
      },
      latex = {
        enable = true,
      }
    },

    keys = {
      {
        "<leader>mp",
        ft = "markdown",
        "<cmd>Markview<cr>",
        desc = "Markdown Preview",
      },
      {
        "<leader>mP",
        ft = "markdown",
        "<cmd>Markview splitToggle<cr>",
        desc = "Markdown Split Preview",
      },
    }
  }
}
