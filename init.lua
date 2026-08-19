-- ~/.config/nvim/init.lua

-- 1. Bootstrap lazy.nvim ----------------------------------------------------
vim.g.which_key_disable_health_check = true
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Set some sane basics ---------------------------------------------------
vim.g.mapleader = " "
local keymaps = require("keymaps")
vim.keymap.set("n", keymaps.window.keys, "<C-w>", { desc = keymaps.window.desc })
vim.o.number = true
vim.o.relativenumber = true
vim.o.smoothscroll = true
vim.o.wrap = false
require("notes")
require("diff_saved")
require("cheatsheet")

-- 3. Load plugins -----------------------------------------------------------
require("lazy").setup("plugins")

