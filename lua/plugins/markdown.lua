-- ~/.config/nvim/lua/plugins/markdown.lua
local keymaps = require("keymaps")
return {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install",
  ft = { "markdown" },
  keys = {
    { keymaps.markdown_preview.keys, "<cmd>MarkdownPreviewToggle<cr>", desc = keymaps.markdown_preview.desc },
  },
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_theme = "light"
  end,
}
