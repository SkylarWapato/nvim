-- ~/.config/nvim/lua/plugins/telescope.lua
local keymaps = require("keymaps")
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  cmd = { "Telescope" },
  keys = {
    { keymaps.find_files.keys, "<cmd>Telescope find_files<cr>", desc = keymaps.find_files.desc },
    { keymaps.find_files_vsplit.keys, "<cmd>vsplit | Telescope find_files<cr>", desc = keymaps.find_files_vsplit.desc },
    { keymaps.find_files_split.keys, "<cmd>split | Telescope find_files<cr>", desc = keymaps.find_files_split.desc },
    { keymaps.live_grep.keys, "<cmd>Telescope live_grep<cr>", desc = keymaps.live_grep.desc },
    { keymaps.buffers.keys, "<cmd>Telescope buffers<cr>", desc = keymaps.buffers.desc },
    { keymaps.help_tags.keys, "<cmd>Telescope help_tags<cr>", desc = keymaps.help_tags.desc },
  },
  opts = {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
      },
      sorting_strategy = "ascending",
      layout_config = { prompt_position = "top" },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    opts.extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown(),
      },
    }
    telescope.setup(opts)
    telescope.load_extension("ui-select")
  end,
}

