-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
  transparency = true,
  theme = "onedark",

  cmp = {
    style = "atom",
  },

  nvdash = {
    load_on_startup = true,
    buttons = {
      { "  Find File", "f", "Telescope find_files" },
      { "  Mappings", "m", "NvCheatsheet" },
      { "  Config", "c", "e $MYVIMRC " },
      { "  Quit", "q", "qa" },
    },
  },

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

return M
