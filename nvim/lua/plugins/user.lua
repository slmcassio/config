-- ------------------------------------------
-- Preferences
-- ------------------------------------------
-- which-key menu vertical orientation
-- catppuccin colorscheme
-- Show key presses in popup (SPC u k)
-- Snacks customisation
-- -- Startup dashboard banner
-- -- indent guides disabled
-- -- notifier log level INFO
-- `fd` as alternate `ESC` key mapping (better-escape.nvim)
-- Trim blank space automatically
-- Custom snippets
-- Gist public
-- Neovim global options & key mappings
-- ------------------------------------------

-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

---@type LazySpec
return {

  -- ------------------------------------------
  -- UI Customisation
  -- ------------------------------------------
  -- Vertical which-key menu
  {
    "folke/which-key.nvim",
    opts = {
      ---@type false | "classic" | "modern" | "helix"
      preset = "helix",
    },
  },
  -- Colorscheme (Theme) with auto-switching based on system preference
  ---@type LazySpec
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "catppuccin",
    },
  },
  -- show key presses in normal mode
  {
    "nvzone/showkeys",
    event = "VeryLazy",
    opts = {
      excluded_modes = { "i", "t" }, -- skip insert and terminal
      position = "bottom-center",
      show_count = true,
      maxkeys = 4,
      timeout = 4,
    },
    config = function(_, opts)
      require("showkeys").setup(opts)
      -- Auto-enable on startup
      require("showkeys").toggle()
    end,
  },
  -- Snacks Customisation
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          -- customize the dashboard header
          header = table.concat({
            "          ⠀⠀⢀⣤⣤⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀          ",
            "          ⠀⠀⢸⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀          ",
            "          ⠀⠀⠘⠉⠉⠙⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀          ",
            "          ⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀          ",
            "          ⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀          ",
            "          ⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀          ",
            "          ⠀⠀⠀⠀⣴⣿⣿⣿⠟⣿⣿⣿⣷⠀⠀⠀⠀          ",
            "          ⠀⠀⠀⣰⣿⣿⣿⡏⠀⠸⣿⣿⣿⣇⠀⠀⠀          ",
            "          ⠀⠀⢠⣿⣿⣿⡟⠀⠀⠀⢻⣿⣿⣿⡆⠀⠀          ",
            "          ⠀⢠⣿⣿⣿⡿⠀⠀⠀⠀⠀⢿⣿⣿⣷⣤⡄          ",
            "          ⢀⣾⣿⣿⣿⠁⠀⠀⠀⠀⠀⠈⠿⣿⣿⣿⡇          ",
          }, "\n"),
        },
      },
      -- indent guides - disable by default
      indent = { enabled = true },
      notifier = {
        -- log level: TRACE DEBUG ERROR WARN INFO  OFF
        level = vim.log.levels.WARN,
        -- wrap words in picker right panel
        win = { preview = { wo = { wrap = true } } },
      },
    },
  },
  -- ------------------------------------------
  -- Editor tools
  -- ------------------------------------------
  -- Alternative to Esc key using `fd` key mapping
  {
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
    opts = {
      timeout = vim.o.timeoutlen,
      default_mappings = false,
      mappings = {
        i = { f = { d = "<Esc>" } },
        c = { f = { d = "<Esc>" } },
        t = { f = { d = "<Esc>" } },
        v = { f = { d = "<Esc>" } },
        s = { f = { d = "<Esc>" } },
      },
    },
  },
  -- Trim trailing blank space and blank lines
  {
    "cappyzawa/trim.nvim",
    event = "User AstroFile",
    opts = {},
  },
  -- Custom snippets (vscode format)
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      -- include default astronvim config that calls the setup call
      require "astronvim.plugins.configs.luasnip"(plugin, opts)
      -- load snippets paths
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = { vim.fn.stdpath "config" .. "/snippets" },
      }
    end,
  },
  -- Switch between src and test file
  -- TODO: PR #67 raised on rgroli/other.nvim
  {
    "rgroli/other.nvim",
    ft = { "clojure" },
    main = "other-nvim",
    opts = {
      mappings = { "clojure" },
    },
  },
  -- ------------------------------------------
  -- Neovim Options and Key Mappings
  -- ------------------------------------------
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      options = {
        -- configure general options: vim.opt.<key>
        opt = {
          spell = true, -- sets vim.opt.spell
          wrap = true, -- sets vim.opt.wrap
          guifont = "JetBrainsMono Nerd Font Mono:h13",
        },
        -- configure global vim variables: vim.g
        g = {
          -- Neovim language provides - disable language integration not required
          loaded_perl_provider = 0,
          loaded_ruby_provider = 0,
          -- Leader key for Visual-Multi Cursors (Multiple Cursors)
          VM_leader = "gm", -- Visual Multi Leader (multiple cursors - user plugin)
          -- Conjure plugin overrides
          ["conjure#eval#comment_prefix"] = ";; ", -- comment pattern for eval to comment command
          ["conjure#highlight#enabled"] = true, -- Hightlight evaluated forms
          ["conjure#log#hud#enabled"] = false, -- show HUD REPL log at startup
          ["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false, -- auto repl (babashka)
          ["conjure#client#clojure#nrepl#connection#auto_repl#hidden"] = true,
          ["conjure#client#clojure#nrepl#connection#auto_repl#cmd"] = nil,
          ["conjure#client#clojure#nrepl#eval#auto_require"] = false,
          ["conjure#client#clojure#nrepl#test#runner"] = "kaocha", -- Test runner: "clojure", "clojuresCRipt", "kaocha"

          -- Troubleshoot: Minimise very long lines slow down:
          -- ["conjure#log#treesitter"] = false
          -- ["conjure#log##treesitter"] = false,
          -- ["conjure#log#disable_diagnostics"] = true
        },
      },
      mappings = {
        n = {
          -- normal mode key bindings
          -- setting a mapping to false will disable it
          -- ["<esc>"] = false,
          ["gm"] = { name = "Multiple Cursors" }, -- whick-key sub-menu for Visual-Multi Cursors (Multiple Cursors)
          ["<Leader><tab>"] = { "<cmd>b#<cr>", desc = "Previous tab" }, -- Toggle last open buffer
          -- navigate buffer tabs
          ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
          ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
          -- snacks file explorer
          ["<Leader>E"] = { "<cmd>lua Snacks.picker.explorer()<cr>", desc = "Snacks Explorer" },
          -- Save prompting for file name
          ["<Leader>W"] = { ":write ", desc = "Save as file" },
          -- Gist Creation
          ["<Leader>gj"] = { ":GistCreateFromFile ", desc = "Create Gist (file)" },
          ["<Leader>gJ"] = { "<cmd>GistsList<cr>", desc = "List Gist" },
          -- Neogit Status float
          ["<Leader>gf"] = { "<cmd>Neogit kind=floating<cr>", desc = "Git Status (floating)" },
          -- Toggle between src and test (Clojure pack | other-nvim)
          ["<localLeader>ts"] = { "<cmd>Other<cr>", desc = "Switch src & test" },
          ["<localLeader>tS"] = { "<cmd>OtherVSplit<cr>", desc = "Switch src & test (Split)" },
          -- Showkeys plugin (visualise key presses in Neovim window)
          ["<Leader>uk"] = { "<cmd>ShowkeysToggle<cr>", desc = "Toggle Showkeys" },
        },
        t = {
          -- terminal mode key bindings
        },
        v = {
          -- visual mode key bindings
          -- Gist Creation
          ["<Leader>gj"] = { ":GistCreate ", desc = "Create Gist (region)" },
        },
      },
    },
  },
}
