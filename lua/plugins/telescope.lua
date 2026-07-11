-- ~/.config/nvim/lua/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  cmd = { "Telescope" },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fv", "<cmd>vsplit | Telescope find_files<cr>", desc = "Find files (vsplit)" },
    { "<leader>fs", "<cmd>split | Telescope find_files<cr>", desc = "Find files (split)" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
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

