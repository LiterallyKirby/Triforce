-- Set leader key first
vim.g.mapleader = " "

-- Bootstrap lazy.nvim if not installed
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

-- Now require lazy and load plugins from lua/plugins/ folder
require("lazy").setup("plugins")

-- Load your keymaps after plugins
require("keymaps")

-- Load which keys
require("which-key").setup {}

--notify

vim.notify = require("notify")

require("themery")

require("mason").setup()
