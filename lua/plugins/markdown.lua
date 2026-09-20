-- ~/.config/nvim/lua/plugins/markdown.lua
local keymaps = require("keymaps")

-- Plain :MarkdownPreview opens a new browser tab every time it's called,
-- even if a preview is already running (it doesn't check server status
-- before opening) — so <leader>mp only starts it once per buffer. The
-- websocket connection keeps pushing live updates to that same tab as you
-- edit; there's no need to call anything again.
local function ensure_preview()
  if vim.b.mkdp_started then
    return
  end
  vim.b.mkdp_started = true
  vim.cmd("MarkdownPreview")
end

return {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install",
  ft = { "markdown" },
  keys = {
    { keymaps.markdown_preview.keys, ensure_preview, desc = keymaps.markdown_preview.desc },
  },
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_theme = "light"
  end,
}
