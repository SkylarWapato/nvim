local keymaps = require("keymaps")
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { keymaps.file_tree.keys, "<cmd>NvimTreeToggle<cr>", desc = keymaps.file_tree.desc },
  },
  opts = {
    view = {
      width = 30,
    },
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")
      api.config.mappings.default_on_attach(bufnr)

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      vim.keymap.set("n", "<CR>", api.node.open.preview, opts("Preview"))
    end,
  },
}
