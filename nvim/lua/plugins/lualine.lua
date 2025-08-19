return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- CUSTOM COMPONENTS
    local function lsp_status()
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      if #clients == 0 then return "" end
      local client_names = {}
      for _, client in ipairs(clients) do
        table.insert(client_names, client.name)
      end
      return " " .. table.concat(client_names, ", ")
    end

    local function navic_location()
      local navic = require("nvim-navic")
      if navic.is_available() then
        return navic.get_location()
      end
      return ""
    end

    local function session_status()
      if vim.g.persisted_loaded_session then return " Session" end
      return ""
    end

    local function project_name()
      local ok, projects = pcall(require, "project_nvim")
      if ok then
        local project_root = projects.get_project_root()
        if project_root then
          return " " .. vim.fn.fnamemodify(project_root, ":t")
        end
      end
      return ""
    end

    local function macro_recording()
      local recording_register = vim.fn.reg_recording()
      if recording_register == "" then
        return ""
      else
        return "Recording @" .. recording_register
      end
    end

    local function search_count()
      if vim.v.hlsearch == 0 then return "" end
      local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })
      if not ok or result.incomplete == 1 then return "" end
      if result.total > 0 then
        return string.format("[%d/%d]", result.current, result.total)
      end
      return ""
    end

    local function spell_status()
      if vim.wo.spell then return "SPELL" end
      return ""
    end

    -- THEMES
    local themes = {
      minimal = {
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      rounded = {
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      angular = {
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      } 
    }

    -- Select theme
    local selected_theme = 'rounded'
    local theme_config = themes[selected_theme]

    require('lualine').setup({
      options = {
        theme = theme_config.theme,
        component_separators = theme_config.component_separators,
        section_separators = theme_config.section_separators,
        icons_enabled = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
        disabled_filetypes = {
          statusline = { 'dashboard', 'alpha', 'starter', 'neo-tree', 'Outline', 'toggleterm' },
          winbar = { 'dashboard', 'alpha', 'starter', 'neo-tree', 'Outline', 'toggleterm' },
        },
        ignore_focus = {},
        always_divide_middle = true,
      },

      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(str)
              local mode_map = {
                ['NORMAL'] = 'N',
                ['INSERT'] = 'I',
                ['VISUAL'] = 'V',
                ['V-LINE'] = 'VL',
                ['V-BLOCK'] = 'VB',
                ['COMMAND'] = 'C',
                ['REPLACE'] = 'R',
                ['TERMINAL'] = 'T',
              }
              return mode_map[str] or str:sub(1, 1)
            end,
          }
        },

        lualine_b = {
          { 'branch', icon = '', color = { gui = 'bold' } },
          {
            'diff',
            symbols = { added = ' ', modified = ' ', removed = ' ' },
            diff_color = {
              added = { fg = '#98be65' },
              modified = { fg = '#ECBE7B' },
              removed = { fg = '#ec5f67' },
            },
          },
          { project_name, color = { fg = '#bb9af7', gui = 'italic' } },
        },

        lualine_c = {
          {
            'filename',
            file_status = true,
            newfile_status = true,
            path = 1,
            shorting_target = 40,
            symbols = {
              modified = '[+]',
              readonly = '[-]',
              unnamed = '[No Name]',
              newfile = '[New]',
            },
          },
          {
            navic_location,
            color = { fg = '#7aa2f7' },
            cond = function()
              local navic = require("nvim-navic")
              return navic.is_available()
            end,
          },
          {
            'diagnostics',
            sources = { 'nvim_diagnostic', 'nvim_lsp' },
            sections = { 'error', 'warn', 'info', 'hint' },
            diagnostics_color = {
              error = { fg = '#ec5f67' },
              warn = { fg = '#ECBE7B' },
              info = { fg = '#008080' },
              hint = { fg = '#10B981' },
            },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰝶 ' },
            colored = true,
            update_in_insert = false,
            always_visible = false,
          },
        },

        lualine_x = {
          { macro_recording, color = { fg = '#ff9e64', gui = 'bold' } },
          { search_count, color = { fg = '#7aa2f7' } },
          { spell_status, color = { fg = '#bb9af7' } },
          { session_status, color = { fg = '#9ece6a', gui = 'bold' } },
          { lsp_status, icon = '', color = { fg = '#7dcfff' } },
          'encoding',
          {
            'fileformat',
            symbols = { unix = 'LF', dos = 'CRLF', mac = 'CR' },
          },
        },

        lualine_y = {
          {
            'filetype',
            colored = true,
            icon_only = false,
            icon = { align = 'right' },
          },
          'progress',
        },

        lualine_z = {
          {
            'location',
            padding = { left = 1, right = 1 },
          },
          {
            function() return vim.fn.line('$') end,
            icon = '☰',
          },
        },
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
    })
  end,
}
