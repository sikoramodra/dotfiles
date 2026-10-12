return {
  {
    "numToStr/Comment.nvim",
    --[[
    opts = {
      mappings = {
        basic = false,
        extra = false,
      },
    },
    keys = {
      {
        "<C-_>", -- Ctrl+/
        function()
          require("Comment.api").toggle.linewise.current()
        end,
        mode = "n",
        desc = "Toggle line comment",
      },
      {
        "<C-_>",
        function()
          local api = require("Comment.api")
          -- leave visual mode first, then toggle the selection
          local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
          vim.api.nvim_feedkeys(esc, "nx", false)
          api.toggle.linewise(vim.fn.visualmode())
        end,
        mode = "x",
        desc = "Toggle line comment (visual)",
      },

      -- Also map the literal <C-/> for terminals that send it correctly
      {
        "<C-/>",
        function()
          require("Comment.api").toggle.linewise.current()
        end,
        mode = "n",
        desc = "Toggle line comment",
      },
      {
        "<C-/>",
        function()
          local api = require("Comment.api")
          local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
          vim.api.nvim_feedkeys(esc, "nx", false)
          api.toggle.linewise(vim.fn.visualmode())
        end,
        mode = "x",
        desc = "Toggle line comment (visual)",
      },

      -------

      {
        "<C-S-/>",
        function()
          require("Comment.api").toggle.blockwise.current()
        end,
        mode = "n",
        desc = "Toggle block comment",
      },
      {
        "<C-S-/>",
        function()
          local api = require("Comment.api")
          local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
          vim.api.nvim_feedkeys(esc, "nx", false)
          api.toggle.blockwise(vim.fn.visualmode())
        end,
        mode = "x",
        desc = "Toggle block comment (visual)",
      },
    }
    ]]
  }
}

