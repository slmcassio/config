---@type LazySpec
return {
  "nvzone/showkeys",
  event = "VeryLazy",
  opts = {
    excluded_modes = { "i", "t" },
    position = "bottom-center",
    show_count = true,
    maxkeys = 4,
    timeout = 4,
  },
  config = function(_, opts)
    require("showkeys").setup(opts)
    require("showkeys").toggle()
  end,
}