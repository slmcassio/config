---@type LazySpec
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSend",
    "ClaudeCodeAdd",
    "ClaudeCodeSelectModel",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
  },
  keys = {
    { "<Leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    { "<Leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus on Claude Code" },
    { "<Leader>as", "<cmd>ClaudeCodeSend<cr>", desc = "Send to Claude", mode = "v" },
    { "<Leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<Leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
    { "<Leader>ad", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<Leader>aD", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
  opts = {
    terminal = {
      split_side = "right",
      split_width_percentage = 0.50,
    },
    diff_opts = {
      auto_close_on_accept = true,
    },
  },
  config = function(_, opts)
    require("claudecode").setup(opts)

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      callback = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname:match "claude" then
          vim.keymap.set("t", "<S-Esc>", "<cmd>ClaudeCode<cr>", { buffer = true, desc = "Hide Claude Code" })
        end
      end,
    })
  end,
}
