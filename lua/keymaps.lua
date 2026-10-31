-- ~/.config/nvim/lua/keymaps.lua
-- Single source of truth for key -> description: plugin specs pull `keys`
-- and `desc` from here when binding, and cheatsheet.lua reads the same
-- table to display them, so the two can't drift apart.

return {
  window = { keys = "<leader>w", desc = "Window (prefix for <C-w> commands)", group = "Window" },

  find_files = { keys = "<leader>ff", desc = "Find files", group = "Files" },
  find_files_vsplit = { keys = "<leader>fv", desc = "Find files (vsplit)", group = "Files" },
  find_files_split = { keys = "<leader>fs", desc = "Find files (split)", group = "Files" },
  live_grep = { keys = "<leader>fg", desc = "Live grep", group = "Files" },
  buffers = { keys = "<leader>fb", desc = "Buffers", group = "Files" },
  help_tags = { keys = "<leader>fh", desc = "Help tags", group = "Files" },
  file_tree = { keys = "<leader>e", desc = "Toggle file tree", group = "Files" },

  markdown_preview = { keys = "<leader>mp", desc = "Markdown preview toggle", group = "Markdown" },

  git_blame = { keys = "<leader>gb", desc = "Toggle git blame", group = "Git" },
  diff_open = { keys = "<leader>gd", desc = "Diffview: open", group = "Git" },
  diff_file_history = { keys = "<leader>gh", desc = "Diffview: file history", group = "Git" },
  diff_branch_history = { keys = "<leader>gH", desc = "Diffview: branch history", group = "Git" },
  diff_close = { keys = "<leader>cch", desc = "Diffview: close", group = "Git" },
  diff_since_push = { keys = "<leader>ch", desc = "Diffview: changes since last push", group = "Git" },
  diff_since_commit = { keys = "<leader>lch", desc = "Diffview: changes since last commit", group = "Git" },
  diff_vs_branch = { keys = "<leader>bch", desc = "Diffview: compare to branch", group = "Git" },
  diff_since_save = { keys = "<leader>df", desc = "Toggle diff against last saved version", group = "Git" },
  diff_focus_right = { keys = "<leader>rt", desc = "Diffview: focus right pane (else: rightmost window)", group = "Git" },
  diff_focus_left = { keys = "<leader>lt", desc = "Diffview: focus left pane", group = "Git" },
  diff_toggle_context = { keys = "<leader>dc", desc = "Toggle diff context (full file / collapsed)", group = "Git" },

  lsp_definition = { keys = "gd", desc = "Go to definition", group = "LSP" },
  lsp_hover = { keys = "K", desc = "Hover docs", group = "LSP" },
  lsp_references = { keys = "gr", desc = "References", group = "LSP" },
  lsp_rename = { keys = "<leader>rn", desc = "Rename", group = "LSP" },
  lsp_code_action = { keys = "<leader>ca", desc = "Code action", group = "LSP" },
  lsp_prev_diagnostic = { keys = "[d", desc = "Previous diagnostic", group = "LSP" },
  lsp_next_diagnostic = { keys = "]d", desc = "Next diagnostic", group = "LSP" },
  lsp_toggle_inlay_hints = { keys = "<leader>th", desc = "Toggle inlay hints", group = "LSP" },

  notes_new = { keys = ":Notes", desc = "New note (names itself from line 1 on save)", group = "Notes" },
}
