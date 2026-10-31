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

-- Jumps by diffview's own layout symbols ("a" = left pane, "b" = right/
-- current pane) rather than counting <C-w>l/<C-w>h hops, so it lands
-- correctly regardless of which window (file panel, left, or right) you're
-- currently in.
local function focus_layout_win(symbol)
  local view = require("diffview.lib").get_current_view()
  if not view or not view.cur_layout then
    vim.notify("Not in a Diffview", vim.log.levels.WARN)
    return
  end
  local win = view.cur_layout[symbol]
  if win and win:is_valid() then
    vim.api.nvim_set_current_win(win.id)
  end
end

-- Outside a Diffview, <leader>rt has no layout to target, so just hop to
-- the rightmost window instead.
local function goto_rightmost_win()
  local cur = vim.api.nvim_get_current_win()
  while true do
    vim.cmd("wincmd l")
    local new = vim.api.nvim_get_current_win()
    if new == cur then
      break
    end
    cur = new
  end
end

local function focus_right()
  local view = require("diffview.lib").get_current_view()
  if view and view.cur_layout then
    focus_layout_win("b")
  else
    goto_rightmost_win()
  end
end

-- Starts at vim's default (context:6, folding unchanged lines away); toggles
-- to a huge context so diffs show the full file with no folding, and back.
local function toggle_diff_context()
  if vim.tbl_contains(vim.opt.diffopt:get(), "context:999999") then
    vim.opt.diffopt:remove("context:999999")
    vim.notify("Diff context: collapsed", vim.log.levels.INFO)
  else
    vim.opt.diffopt:append("context:999999")
    vim.notify("Diff context: full file", vim.log.levels.INFO)
  end
end

local keymaps = require("keymaps")
return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    { keymaps.diff_open.keys, "<cmd>DiffviewOpen<cr>", desc = keymaps.diff_open.desc },
    { keymaps.diff_file_history.keys, "<cmd>DiffviewFileHistory %<cr>", desc = keymaps.diff_file_history.desc },
    { keymaps.diff_branch_history.keys, "<cmd>DiffviewFileHistory<cr>", desc = keymaps.diff_branch_history.desc },
    { keymaps.diff_close.keys, "<cmd>DiffviewClose<cr>", desc = keymaps.diff_close.desc },
    { keymaps.diff_since_push.keys, diff_since_push, desc = keymaps.diff_since_push.desc },
    { keymaps.diff_since_commit.keys, "<cmd>DiffviewOpen<cr>", desc = keymaps.diff_since_commit.desc },
    { keymaps.diff_vs_branch.keys, diff_branch, desc = keymaps.diff_vs_branch.desc },
    { keymaps.diff_focus_right.keys, focus_right, desc = keymaps.diff_focus_right.desc },
    { keymaps.diff_focus_left.keys, function() focus_layout_win("a") end, desc = keymaps.diff_focus_left.desc },
    { keymaps.diff_toggle_context.keys, toggle_diff_context, desc = keymaps.diff_toggle_context.desc },
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
