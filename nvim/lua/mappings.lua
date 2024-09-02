require "nvchad.mappings"

-- add yours here
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- close when nvim-tree is last window
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if
      #vim.api.nvim_list_wins() == 1
      and require("nvim-tree.utils").is_nvim_tree_buf()
    then
      vim.cmd "quit"
    end
  end,
})

vim.api.nvim_create_autocmd("Filetype", {
  pattern = "qml",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
