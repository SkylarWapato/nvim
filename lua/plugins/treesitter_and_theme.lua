-- ~/.config/nvim/lua/plugins/treesitter_and_theme.lua
return {
  ---------------------------------------------------------------------------
  -- Treesitter: modern syntax highlighting
  ---------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
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
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
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

