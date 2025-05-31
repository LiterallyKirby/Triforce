-- Theme Pack Installer
-- Place this file at: lua/plugins/theme-pack.lua
-- This will automatically install all popular themes for use with Themery

return {
  -- Catppuccin (provides catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
        },
      })
    end,
  },

  -- Nord Theme
  {
    "shaunsingh/nord.nvim",
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_italic = false
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = false
    end,
  },

  -- OneDark
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "dark", -- dark, darker, cool, deep, warm, warmer, light
        transparent = false,
        term_colors = true,
        ending_tildes = false,
        cmp_itemkind_reverse = false,
      })
    end,
  },

  -- Gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
    end,
  },

  -- Tokyo Night (provides tokyonight, tokyonight-night, tokyonight-storm, tokyonight-day, tokyonight-moon)
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- storm, moon, night, day
        light_style = "day",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
      })
    end,
  },

  -- Kanagawa
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors)
          return {}
        end,
        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = {
          dark = "wave",
          light = "lotus"
        },
      })
    end,
  },

  -- Rose Pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "auto", -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,
        enable = {
          terminal = true,
          legacy_highlights = true,
          migrations = true,
        },
        styles = {
          bold = true,
          italic = true,
          transparency = false,
        },
        groups = {
          border = "muted",
          link = "iris",
          panel = "surface",
          error = "love",
          hint = "iris",
          info = "foam",
          note = "pine",
          todo = "rose",
          warn = "gold",
          git_add = "foam",
          git_change = "rose",
          git_delete = "love",
          git_dirty = "rose",
          git_ignore = "muted",
          git_merge = "iris",
          git_rename = "pine",
          git_stage = "iris",
          git_text = "rose",
          git_untracked = "subtle",
        },
        highlight_groups = {},
      })
    end,
  },

  -- Nightfox (provides nightfox, duskfox, nordfox, terafox, carbonfox)
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_suffix = "_compiled",
          transparent = false,
          terminal_colors = true,
          dim_inactive = false,
          module_default = true,
          colorblind = {
            enable = false,
            simulate_only = false,
            severity = {
              protan = 0,
              deutan = 0,
              tritan = 0,
            },
          },
          styles = {
            comments = "italic",
            conditionals = "NONE",
            constants = "NONE",
            functions = "NONE",
            keywords = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
            variables = "NONE",
          },
          inverse = {
            match_paren = false,
            visual = false,
            search = false,
          },
        },
        palettes = {},
        specs = {},
        groups = {},
      })
    end,
  },

  -- GitHub Theme (provides github_dark, github_light)
  {
    "projekt0n/github-nvim-theme",
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          compile_path = vim.fn.stdpath("cache") .. "/github-theme",
          compile_file_suffix = "_compiled",
          hide_end_of_buffer = true,
          hide_nc_statusline = true,
          transparent = false,
          terminal_colors = true,
          dim_inactive = false,
          module_default = true,
          styles = {
            comments = "italic",
            functions = "NONE",
            keywords = "NONE",
            variables = "NONE",
            conditionals = "NONE",
            constants = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
          },
          inverse = {
            match_paren = false,
            visual = false,
            search = false,
          },
          darken = {
            floats = false,
            sidebars = {
              enable = true,
              list = {},
            },
          },
        },
        palettes = {},
        specs = {},
        groups = {},
      })
    end,
  },

  -- Material Theme
  {
    "marko-cerovac/material.nvim",
    priority = 1000,
    config = function()
      require("material").setup({
        contrast = {
          terminal = false,
          sidebars = false,
          floating_windows = false,
          cursor_line = false,
          non_current_windows = false,
          filetypes = {},
        },
        styles = {
          comments = { italic = true },
          strings = { italic = false },
          keywords = { italic = false },
          functions = { bold = false, italic = false },
          variables = {},
          operators = {},
          types = {},
        },
        plugins = {
          "dap",
          "dashboard",
          "gitsigns",
          "hop",
          "indent-blankline",
          "lspsaga",
          "mini",
          "neogit",
          "nvim-cmp",
          "nvim-navic",
          "nvim-tree",
          "nvim-web-devicons",
          "sneak",
          "telescope",
          "trouble",
          "which-key",
        },
        disable = {
          colored_cursor = false,
          borders = false,
          background = false,
          term_colors = false,
          eob_lines = false,
        },
        high_visibility = {
          lighter = false,
          darker = false,
        },
        lualine_style = "default",
        async_loading = true,
        custom_colors = nil,
        custom_highlights = {},
      })
    end,
  },

  -- Dracula
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    config = function()
      local dracula = require("dracula")
      dracula.setup({
        colors = {},
        show_end_of_buffer = true,
        transparent_bg = false,
        lualine_bg_color = "#44475a",
        italic_comment = true,
        overrides = {},
      })
    end,
  },

  -- Palenight
  {
    "drewtempelmeyer/palenight.vim",
    priority = 1000,
  },

  -- Ayu
  {
    "Shatur/neovim-ayu",
    priority = 1000,
    config = function()
      require("ayu").setup({
        mirage = false,
        overrides = {},
      })
    end,
  },

  -- Everforest
  {
    "sainnhe/everforest",
    priority = 1000,
    config = function()
      vim.g.everforest_background = "medium"
      vim.g.everforest_better_performance = 1
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_disable_italic_comment = 0
      vim.g.everforest_transparent_background = 0
    end,
  },

  -- Sonokai
  {
    "sainnhe/sonokai",
    priority = 1000,
    config = function()
      vim.g.sonokai_style = "default"
      vim.g.sonokai_better_performance = 1
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_disable_italic_comment = 0
      vim.g.sonokai_transparent_background = 0
    end,
  },

  -- Edge
  {
    "sainnhe/edge",
    priority = 1000,
    config = function()
      vim.g.edge_style = "default"
      vim.g.edge_better_performance = 1
      vim.g.edge_enable_italic = 1
      vim.g.edge_disable_italic_comment = 0
      vim.g.edge_transparent_background = 0
    end,
  },

  -- Moonfly
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    priority = 1000,
    config = function()
      vim.g.moonflyCursorColor = true
      vim.g.moonflyItalics = true
      vim.g.moonflyNormalFloat = true
      vim.g.moonflyTerminalColors = true
      vim.g.moonflyTransparent = false
      vim.g.moonflyUndercurls = true
      vim.g.moonflyUnderlineMatchParen = true
      vim.g.moonflyVirtualTextColor = true
    end,
  },

  -- Night Owl
  {
    "haishanh/night-owl.vim",
    priority = 1000,
    config = function()
      vim.g.night_owl_gui_italic_comments = true
    end,
  },
}
