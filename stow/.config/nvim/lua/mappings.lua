require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<C-h>", "<cmd> TmuxNavigateLeft<cr>", { desc = "window left" })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<cr>", { desc = "window right" })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<cr>", { desc = "window down" })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<cr>", { desc = "window up" })

map(
  { "n", "i" },
  "<leader>gsj",
  "<cmd> GoTagAdd json <cr>",
  { desc = "Add json struct tags" }
)

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

-- temp hack to make react project use 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascriptreact", "typescriptreact", "jsx", "tsx" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
