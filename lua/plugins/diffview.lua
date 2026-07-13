-- ~/.config/nvim/lua/plugins/diffview.lua
-- NOTE: Diffview only ever shows untracked files when comparing STAGE against
-- LOCAL (i.e. a bare `:DiffviewOpen`); any explicit rev disables untracked
-- files entirely (see GitAdapter:show_untracked in the plugin source). To see
-- a new file in these views, `git add` it first.
local function diff_since_push()
  vim.fn.system("git rev-parse --abbrev-ref --symbolic-full-name @{u}")
  if vim.v.shell_error ~= 0 then
    vim.notify("No upstream branch configured", vim.log.levels.WARN)
    return
  end
  vim.cmd("DiffviewOpen @{u}")
end

local function diff_branch()
  require("telescope") -- ensure telescope (and its ui-select override) is loaded
  -- Remote-tracking refs, not local branches: a local branch pointer is just
  -- HEAD when it's the one you're on, and may be stale/unfetched otherwise.
  local branches = vim.fn.systemlist("git branch -r --format='%(refname:short)' | grep '/' | grep -v '/HEAD$'")
  vim.ui.select(branches, { prompt = "Compare to branch:" }, function(choice)
    if choice then
      vim.cmd("DiffviewOpen " .. choice)
    end
  end)
end

return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: Open" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: File history" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: Branch history" },
    { "<leader>cch", "<cmd>DiffviewClose<cr>", desc = "Diffview: Close" },
    { "<leader>ch", diff_since_push, desc = "Diffview: Changes since last push" },
    { "<leader>lch", "<cmd>DiffviewOpen<cr>", desc = "Diffview: Changes since last commit" },
    { "<leader>bch", diff_branch, desc = "Diffview: Compare to branch" },
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
