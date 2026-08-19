local keymaps = require("keymaps")
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 300,
    },
  },
  keys = {
    { keymaps.git_blame.keys, "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = keymaps.git_blame.desc },
  },
}
