-- Themery Theme Picker Configuration
-- Place this file at: lua/plugins/themery.lua
return {
  "zaldih/themery.nvim",
  cmd = "Themery",
  keys = {
    { "<leader>Ttt", "<cmd>Themery<CR>", desc = "Theme Picker (Themery)" },
  },
  config = function()
    require("themery").setup({
      themes = {
        -- Built-in
        "default",
        
        -- Nord
        "nord",
        
        -- Catppuccin variants
        "catppuccin",
        "catppuccin-latte",
        "catppuccin-frappe",
        "catppuccin-macchiato", 
        "catppuccin-mocha",
        
        -- OneDark
        "onedark",
        
        -- Gruvbox
        "gruvbox",
        
        -- Tokyo Night variants
        "tokyonight",
        "tokyonight-night",
        "tokyonight-storm",
        "tokyonight-day",
        "tokyonight-moon",
        
        -- Kanagawa variants
        "kanagawa",
        "kanagawa-wave",
        "kanagawa-dragon",
        "kanagawa-lotus",
        
        -- Rose Pine variants
        "rose-pine",
        "rose-pine-main",
        "rose-pine-moon",
        "rose-pine-dawn",
        
        -- Nightfox variants
        "nightfox",
        "duskfox",
        "nordfox",
        "terafox",
        "carbonfox",
        "dayfox",
        "dawnfox",
        
        -- GitHub variants
        "github_dark",
        "github_dark_default",
        "github_dark_dimmed",
        "github_light",
        "github_light_default",
        
        -- Material variants
        "material",
        "material-oceanic",
        "material-palenight",
        "material-lighter",
        "material-darker",
        "material-deep-ocean",
        
        -- Dracula
        "dracula",
        
        -- Palenight
        "palenight",
        
        -- Ayu variants
        "ayu",
        "ayu-light",
        "ayu-mirage",
        "ayu-dark",
        
        -- Everforest
        "everforest",
        
        -- Sonokai
        "sonokai",
        
        -- Edge
        "edge",
        
        -- Moonfly
        "moonfly",
        
        -- Night Owl
        "night-owl",
      },
      
      -- Enable live preview (theme changes as you navigate)
      livePreview = true,
      
      -- Callback function when theme changes
      onChange = function(theme)
        -- Re-apply bufferline highlights after theme change
        -- Note: Make sure you have the bufferline theme file at themes/bufferline.lua
        local ok, bufferline_highlights = pcall(require, "plugins.bufferline")
        if ok then
          require("bufferline").setup({
            highlights = bufferline_highlights,
          })
        end
        
        -- Optional: Callback after theme is applied
        vim.notify("Applied theme: " .. theme, vim.log.levels.INFO)
      end,
    })
    
    -- Auto-command to ensure theme is applied on startup
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- Load saved theme if it exists
        local theme_file = vim.fn.stdpath("config") .. "/lua/theme.lua"
        if vim.fn.filereadable(theme_file) == 1 then
          dofile(theme_file)
        end
      end,
    })
  end,
}
