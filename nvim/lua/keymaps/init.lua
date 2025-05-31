-- lua/keymaps/init.lua
local path = vim.fn.stdpath("config") .. "/lua/keymaps/"
local scan = vim.loop.fs_scandir or vim.loop.fs_scandir -- use luv API to scan directory

local function load_keymap_files()
  local handle = vim.loop.fs_scandir(path)
  while true do
    local name, t = vim.loop.fs_scandir_next(handle)
    if not name then break end
    if name ~= "init.lua" and name:sub(-4) == ".lua" then
      local mod_name = "keymaps." .. name:sub(1, -5)
      pcall(require, mod_name)
    end
  end
end

load_keymap_files()
