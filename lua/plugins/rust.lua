-- ~/.config/nvim/lua/plugins/rust.lua
local keymaps = require("keymaps")
return {
  "mrcjkb/rustaceanvim",
  version = "^5", -- keep it stable-ish
  ft = { "rust" },
  config = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(_, bufnr)
          local function map(entry, rhs)
            vim.keymap.set("n", entry.keys, rhs, { buffer = bufnr, noremap = true, silent = true, desc = entry.desc })
          end
          map(keymaps.lsp_definition, vim.lsp.buf.definition)
          map(keymaps.lsp_hover, vim.lsp.buf.hover)
          map(keymaps.lsp_rename, vim.lsp.buf.rename)
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = true,
            check = { command = "clippy" },
          },
        },
      },
    }
  end,
}

