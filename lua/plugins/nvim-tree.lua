local keymaps = require("keymaps")
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Load right after startup instead of on first <leader>e press, so the
  -- ~2s cold-load cost (requiring the plugin + devicons, running setup)
  -- happens in the background rather than as a delay the first time you
  -- try to open the tree. Since the plugin is always loaded by then, the
  -- toggle keymap is set directly in `config` below rather than through
  -- lazy.nvim's `keys` (lazy-key dispatch on top of an already-loaded
  -- plugin was itself adding a ~1s delay to every press).
  event = "VimEnter",
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
  config = function(_, opts)
    require("nvim-tree").setup(opts)
    vim.keymap.set("n", keymaps.file_tree.keys, "<cmd>NvimTreeToggle<cr>", { desc = keymaps.file_tree.desc })
  end,
}
