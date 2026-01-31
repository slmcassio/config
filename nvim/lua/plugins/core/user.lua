---@type LazySpec
return {
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      options = {
        opt = {
          spell = true,
          wrap = true,
          guifont = "JetBrainsMono Nerd Font Mono:h13",
        },
        g = {
          loaded_perl_provider = 0,
          loaded_ruby_provider = 0,
          VM_leader = "gm",
          ["conjure#eval#comment_prefix"] = ";; ",
          ["conjure#highlight#enabled"] = true,
          ["conjure#log#hud#enabled"] = false,
          ["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false,
          ["conjure#client#clojure#nrepl#connection#auto_repl#hidden"] = true,
          ["conjure#client#clojure#nrepl#connection#auto_repl#cmd"] = nil,
          ["conjure#client#clojure#nrepl#eval#auto_require"] = false,
          ["conjure#client#clojure#nrepl#test#runner"] = "kaocha",
        },
      },
      mappings = {
        n = {
          ["gm"] = { name = "Multiple Cursors" },
          ["<Leader>a"] = { name = "AI Assistant" },
          ["<Leader><tab>"] = { "<cmd>b#<cr>", desc = "Previous tab" },
          ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
          ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
          ["<Leader>E"] = { "<cmd>lua Snacks.picker.explorer()<cr>", desc = "Snacks Explorer" },
          ["<Leader>W"] = { ":write ", desc = "Save as file" },
          ["<Leader>gj"] = { ":GistCreateFromFile ", desc = "Create Gist (file)" },
          ["<Leader>gJ"] = { "<cmd>GistsList<cr>", desc = "List Gist" },
          ["<localLeader>ts"] = { "<cmd>Other<cr>", desc = "Switch src & test" },
          ["<localLeader>tS"] = { "<cmd>OtherVSplit<cr>", desc = "Switch src & test (Split)" },
          ["<Leader>uk"] = { "<cmd>ShowkeysToggle<cr>", desc = "Toggle Showkeys" },
        },
        t = {},
        v = {
          ["<Leader>gj"] = { ":GistCreate ", desc = "Create Gist (region)" },
        },
      },
    },
  },
}