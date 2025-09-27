-- Clojure specific configuration
-- Loads after clojure filetype set

local whichkey = require "which-key"

return {
  {
    "folke/which-key.nvim",
    -- Define Conjure Groups only for Clojure filetypes
    whichkey.add {
      -- Conjure sub-menus
      { "<LocalLeader>c", group = "Connect" },
      { "<LocalLeader>e", group = "Evaluate" },
      { "<LocalLeader>ec", group = "Comment" },
      { "<LocalLeader>g", group = "Go" },
      { "<LocalLeader>l", group = "REPl Log" },
      { "<LocalLeader>r", group = "Refresh" },
      { "<LocalLeader>s", group = "Session" },
      { "<LocalLeader>t", group = "Test" },
      { "<LocalLeader>v", group = "Values" },
      { "<LocalLeader>x", group = "macroXpand" },
      -- Structural Editing
      { "<localleader>p", "<cmd>ParinferToggle<cr>", desc = "Toggle Parinfer", mode = "n" },
    },
  },
}
