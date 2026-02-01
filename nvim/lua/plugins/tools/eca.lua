---@type LazySpec
return {
  "editor-code-assistant/eca-nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
  },
  keys = {
    -- Top-level commands
    { "<leader>ao", "<cmd>EcaChat<cr>", desc = "Open ECA chat" },
    { "<leader>ac", "<cmd>EcaClose<cr>", desc = "Close ECA sidebar" },

    -- Context management sub-menu
    { "<leader>aa", group = "ECA Context" },
    { "<leader>aaa", ":EcaChatAddFile ", desc = "Add file context" },
    { "<leader>aar", ":EcaChatRemoveFile ", desc = "Remove file context" },
    { "<leader>aau", "<cmd>EcaChatAddUrl<cr>", desc = "Add URL context" },
    { "<leader>aac", "<cmd>EcaChatClearContexts<cr>", desc = "Clear all contexts" },

    -- Visual operations sub-menu
    { "<leader>av", group = "[Visual] ECA Context", mode = "v" },
    { "<leader>avs", "<cmd>EcaChatAddSelection<cr>", desc = "Add selection context", mode = "v" },

    -- Model settings sub-menu
    { "<leader>am", group = "ECA Model" },
    { "<leader>amm", "<cmd>EcaChatSelectModel<cr>", desc = "Select model" },
    { "<leader>amb", "<cmd>EcaChatSelectBehavior<cr>", desc = "Select behavior" },

    -- Server operations sub-menu
    { "<leader>as", group = "ECA Server" },
    { "<leader>ass", "<cmd>EcaServerStart<cr>", desc = "Start server" },
    { "<leader>asx", "<cmd>EcaServerStop<cr>", desc = "Stop server" },
    { "<leader>asr", "<cmd>EcaServerRestart<cr>", desc = "Restart server" },
    { "<leader>asm", "<cmd>EcaServerMessages<cr>", desc = "Server messages" },
    { "<leader>ast", "<cmd>EcaServerTools<cr>", desc = "Server tools" },
  },
  opts = {
    behavior = {
      -- Set default keymaps automatically
      auto_set_keymaps = false,
      -- Focus the ECA sidebar when opening it
      auto_focus_sidebar = true,
      -- Automatically start the server on plugin setup
      auto_start_server = true,
    },
  },
}
