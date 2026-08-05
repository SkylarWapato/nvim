-- ~/.config/nvim/lua/plugins/treesitter_and_theme.lua
return {
  ---------------------------------------------------------------------------
  -- Treesitter: modern syntax highlighting
  ---------------------------------------------------------------------------
  {
    -- "master" is unmaintained and breaks on current Neovim (its bundled
    -- injection queries crash the builtin highlighter); "main" is the
    -- actively maintained branch with a new, more minimal config API.
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "markdown",
        "markdown_inline",
        "json",
        "rust",
        "toml",
        "yaml",
      }
      require("nvim-treesitter").install(parsers):wait(300000)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "lua", "vim", "help", "sh", "markdown", "json", "rust", "toml", "yaml" },
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- Colorscheme: pick one that actually looks good
  ---------------------------------------------------------------------------
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- load before everything else
    opts = {
      style = "night", -- "storm", "night", "moon", etc.
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
      vim.o.cursorline = true
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1a2a1a" })
    end,
  },
}

