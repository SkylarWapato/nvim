-- ~/.config/nvim/lua/plugins/lsp.lua
local keymaps = require("keymaps")
return {
  {
    -- Mason: manages external tools (LSPs, formatters, etc.)
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  {
    -- Optional: keep nvim-lspconfig as a "bag of configs"
    -- but we DO NOT call require('lspconfig') anymore.
    "neovim/nvim-lspconfig",
    config = function()
      -- Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 2,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.HINT] = "H",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      })

      -- LSP keymaps (run whenever a client attaches)
      local on_attach = function(_, bufnr)
        local function map(entry, rhs)
          vim.keymap.set("n", entry.keys, rhs, { buffer = bufnr, noremap = true, silent = true, desc = entry.desc })
        end
        map(keymaps.lsp_definition, vim.lsp.buf.definition)
        map(keymaps.lsp_hover, vim.lsp.buf.hover)
        map(keymaps.lsp_references, vim.lsp.buf.references)
        map(keymaps.lsp_rename, vim.lsp.buf.rename)
        map(keymaps.lsp_code_action, vim.lsp.buf.code_action)
        map(keymaps.lsp_prev_diagnostic, vim.diagnostic.goto_prev)
        map(keymaps.lsp_next_diagnostic, vim.diagnostic.goto_next)
        map(keymaps.lsp_toggle_inlay_hints, function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end)
      end

      -- Capabilities (for nvim-cmp)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- Define/extend rust_analyzer config using new API
      vim.lsp.config("rust_analyzer", {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            check = { command = "check" },
          },
        },
      })

      -- Enable it so it actually runs
      vim.lsp.enable("rust_analyzer")
    end,
  },
}

