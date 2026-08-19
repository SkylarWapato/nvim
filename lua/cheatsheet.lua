-- ~/.config/nvim/lua/cheatsheet.lua
-- Floating window listing lua/keymaps.lua, grouped. Shown on plain `nvim`
-- (no file, no startup command) and available any time via :Cheatsheet.

local GROUP_ORDER = { "Files", "Markdown", "Git", "Notes", "LSP", "Window" }

local function build_lines()
  local keymaps = require("keymaps")

  local by_group = {}
  local key_width = 0
  for _, entry in pairs(keymaps) do
    by_group[entry.group] = by_group[entry.group] or {}
    table.insert(by_group[entry.group], entry)
    key_width = math.max(key_width, #entry.keys)
  end
  for _, entries in pairs(by_group) do
    table.sort(entries, function(a, b)
      return a.keys < b.keys
    end)
  end

  local lines = {}
  for _, group in ipairs(GROUP_ORDER) do
    local entries = by_group[group]
    if entries then
      table.insert(lines, group .. ":")
      for _, entry in ipairs(entries) do
        table.insert(lines, string.format("  %-" .. key_width .. "s  %s", entry.keys, entry.desc))
      end
      table.insert(lines, "")
    end
  end
  if lines[#lines] == "" then
    table.remove(lines)
  end
  return lines
end

local function show()
  local lines = build_lines()

  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, #line)
  end
  width = width + 2

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = #lines,
    row = math.floor((vim.o.lines - #lines) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Keymaps ",
    title_pos = "center",
  })

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.keymap.set("n", "q", close, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true })
  vim.api.nvim_create_autocmd("BufLeave", { buffer = buf, once = true, callback = close })
end

vim.api.nvim_create_user_command("Cheatsheet", show, {})

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    if vim.fn.argc() == 0 and vim.bo.buftype == "" then
      show()
    end
  end,
})
