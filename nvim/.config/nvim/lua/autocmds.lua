require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- Close Neovim when nvim-tree is the last window
autocmd("BufEnter", {
  nested = true,
  callback = function()
    local wins = vim.api.nvim_list_wins()

    if #wins == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd("quit")
    end
  end,
})
