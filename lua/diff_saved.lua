-- ~/.config/nvim/lua/diff_saved.lua
-- <leader>df: toggle a diff of the current buffer against its last-saved
-- (on-disk) contents — unlike gitsigns/diffview, this has nothing to do
-- with git.

local keymaps = require("keymaps")

-- orig_win -> scratch_win, so <leader>df from either side closes the pair.
local open_diffs = {}

local function close_diff(orig_win, scratch_win)
  if vim.api.nvim_win_is_valid(scratch_win) then
    vim.api.nvim_win_close(scratch_win, true)
  end
  if vim.api.nvim_win_is_valid(orig_win) then
    vim.wo[orig_win].diff = false
  end
  open_diffs[orig_win] = nil
end

local function open_diff()
  local orig_win = vim.api.nvim_get_current_win()

  vim.cmd("leftabove vert new")
  vim.bo.buftype = "nofile"
  vim.cmd("read ++edit #")
  vim.cmd("0delete _")
  vim.cmd("diffthis")
  local scratch_buf = vim.api.nvim_get_current_buf()
  local scratch_win = vim.api.nvim_get_current_win()

  vim.wo[orig_win].diff = true
  open_diffs[orig_win] = scratch_win

  vim.keymap.set("n", "q", function()
    close_diff(orig_win, scratch_win)
  end, { buffer = scratch_buf, nowait = true })

  vim.cmd("wincmd p")
end

local function toggle_diff_since_save()
  local win = vim.api.nvim_get_current_win()

  -- Pressed from the original window: close its paired scratch diff.
  local scratch_win = open_diffs[win]
  if scratch_win and vim.api.nvim_win_is_valid(scratch_win) then
    close_diff(win, scratch_win)
    return
  end

  -- Pressed from inside a scratch diff window: find and close its pair.
  for orig_win, sw in pairs(open_diffs) do
    if sw == win then
      close_diff(orig_win, win)
      return
    end
  end

  if vim.bo.buftype ~= "" or vim.fn.expand("%") == "" then
    vim.notify("No file to diff", vim.log.levels.WARN)
    return
  end
  open_diff()
end

vim.keymap.set("n", keymaps.diff_since_save.keys, toggle_diff_since_save, { desc = keymaps.diff_since_save.desc })
