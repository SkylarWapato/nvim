-- ~/.config/nvim/lua/plugins/diffview.lua
return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: Open" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: File history" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: Branch history" },
    { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview: Close" },
    -- { "<leader>we", "<C-w>l<C-w>l", desc = "Jump to editable diff panel" },
    -- { "<leader>qw", "<C-w>l", desc = "Jump to read-only diff panel" },
    -- { "<leader>ww", "<C-w>h<C-w>h", desc = "Jump to file picker" },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      merge_tool = {
        layout = "diff3_mixed",
      },
    },
  },
}
