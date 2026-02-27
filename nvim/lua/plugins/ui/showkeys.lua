---@type LazySpec
return {
  "nvzone/showkeys",
  cmd = "ShowkeysToggle",
  keys = {
    { "<leader>uk", "<cmd>ShowkeysToggle<cr>", desc = "Toggle Showkeys" },
  },
  opts = {
    excluded_modes = { "i", "t" },
    position = "bottom-center",
    show_count = true,
    maxkeys = 4,
    timeout = 4,
  },
}