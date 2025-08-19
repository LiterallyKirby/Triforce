-- lua/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      -- your telescope config here (optional)
      extensions = {
        file_browser = {
          theme = "ivy",
          hijack_netrw = true,
          -- any other opts you want
        },
      },
    })

    -- Load the file_browser extension
    telescope.load_extension("file_browser")
  end,
}
