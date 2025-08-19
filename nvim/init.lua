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

-- Always use system clipboard for yanks and pastes
vim.opt.clipboard = "unnamedplus"

-- Don't overwrite your yank when deleting text
vim.keymap.set("n", "d", '"_d', { noremap = true })
vim.keymap.set("n", "x", '"_x', { noremap = true })
vim.keymap.set("v", "d", '"_d', { noremap = true })
vim.keymap.set("v", "x", '"_x', { noremap = true })

-- Optional: allow easy clipboard copy/paste even without system clipboard set
vim.keymap.set({"n", "v"}, "<leader>y", '"+y')
vim.keymap.set({"n", "v"}, "<leader>p", '"+p')

