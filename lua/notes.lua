-- ~/.config/nvim/lua/notes.lua
-- :Notes opens a blank markdown buffer; saving it names the file after line 1.

local notes_dir = vim.fn.expand("~/notes")

local function slugify(line)
  line = line:gsub("^#+%s*", "")
  line = line:lower()
  line = line:gsub("[^%w%s-]", "")
  line = line:gsub("%s+", "-")
  line = line:gsub("-+", "-")
  line = line:gsub("^-+", ""):gsub("-+$", "")
  return line
end

local function unique_path(slug)
  vim.fn.mkdir(notes_dir, "p")
  local path = notes_dir .. "/" .. slug .. ".md"
  if vim.fn.filereadable(path) == 1 then
    local stamp = os.date("%Y-%m-%d-%H%M%S")
    path = notes_dir .. "/" .. stamp .. "-" .. slug .. ".md"
  end
  return path
end

-- Unnamed buffers hit E32 before BufWritePre/pattern-matched BufWriteCmd ever
-- fire, so :Notes attaches a buffer-local BufWriteCmd directly: it names the
-- file after line 1 on first write, then drops back to a normal file buffer.
vim.api.nvim_create_user_command("Notes", function()
  vim.cmd("enew")
  vim.bo.filetype = "markdown"
  vim.bo.buftype = "acwrite"
  local buf = vim.api.nvim_get_current_buf()
  -- acwrite still requires a non-empty name for :w to hand off to BufWriteCmd
  -- at all; this placeholder is never actually created on disk.
  vim.api.nvim_buf_set_name(buf, string.format("notes://new/%d", buf))

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    callback = function(args)
      local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
      local slug = slugify(lines[1] or "")
      if slug == "" then
        slug = "untitled"
      end
      local path = unique_path(slug)
      vim.fn.writefile(lines, path)
      vim.api.nvim_buf_set_name(args.buf, path)
      vim.bo[args.buf].buftype = ""
      vim.bo[args.buf].modified = false
      return true
    end,
  })
end, {})

vim.api.nvim_create_user_command("NotesInstallAlias", function()
  local zshrc = vim.fn.expand("~/.zshrc")
  local alias_line = "alias notes='nvim -c Notes'"
  local lines = vim.fn.filereadable(zshrc) == 1 and vim.fn.readfile(zshrc) or {}
  for _, line in ipairs(lines) do
    if line == alias_line then
      vim.notify("notes alias already present in ~/.zshrc", vim.log.levels.INFO)
      return
    end
  end
  vim.fn.writefile({ alias_line }, zshrc, "a")
  vim.notify("Added to ~/.zshrc: " .. alias_line, vim.log.levels.INFO)
end, {})
