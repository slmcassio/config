require("lazy").setup({
  {
    "AstroNvim/AstroNvim",
    version = "^5",
    import = "astronvim.plugins",
    opts = {
      mapleader = " ",
      maplocalleader = ",",
      icons_enabled = true,
      pin_plugins = nil,
      update_notifications = true,
    },
  },
  { import = "community" },
  { import = "plugins.core" },
  { import = "plugins.ui" },
  { import = "plugins.editing" },
  { import = "plugins.language" },
  { import = "plugins.tools" },
} --[[@as LazySpec]], {
  install = { colorscheme = { "catppuccin" } },
  ui = { backdrop = 100 },
  performance = {
    rtp = {

      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        -- "zipPlugin",  -- enabled to access jar files
      },
    },
  },
} --[[@as LazyConfig]])
