return {
  'akinsho/bufferline.nvim', 
  version = "*", 
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("bufferline").setup({
      options = {
        -- BEHAVIOR OPTIONS
        always_show_bufferline = false,  -- Hide when only one buffer
        close_command = "bdelete! %d",   -- Command to close buffer
        right_mouse_command = "bdelete! %d", -- Right click to close
        left_mouse_command = "buffer %d", -- Left click to switch
        middle_mouse_command = nil,      -- Middle click action
        
        -- APPEARANCE OPTIONS
        mode = "buffers",                -- "buffers" | "tabs"
        numbers = "none",                -- "none" | "ordinal" | "buffer_id" | "both"
        indicator = {
          icon = '▎',                    -- Indicator icon
          style = 'icon',                -- 'icon' | 'underline' | 'none'
        },
        buffer_close_icon = '󰅖',         -- Close button icon
        modified_icon = '●',             -- Modified file icon
        close_icon = '',                -- Tab close icon
        left_trunc_marker = '',         -- Truncation marker
        right_trunc_marker = '',        -- Truncation marker
        
        -- TABS STYLING
        separator_style = "slant",       -- "slant" | "slope" | "thick" | "thin" | {"any", "any"}
        tab_size = 18,                   -- Tab width
        max_name_length = 18,            -- Max filename length
        max_prefix_length = 15,          -- Max path prefix length
        truncate_names = true,           -- Truncate long names
        
        -- FILTERING & SORTING
        show_buffer_icons = true,        -- Show file type icons
        show_buffer_close_icons = true,  -- Show close buttons
        show_close_icon = true,          -- Show global close button
        show_tab_indicators = true,      -- Show modified indicators
        show_duplicate_prefix = true,    -- Show path when names duplicate
        
        -- ADVANCED OPTIONS
        persist_buffer_sort = true,      -- Remember buffer order
        move_wraps_at_ends = false,      -- Wrap when moving past ends
        diagnostics = "nvim_lsp",        -- "nvim_lsp" | "coc" | false
        diagnostics_update_in_insert = false, -- Update diagnostics in insert mode
        
        -- CUSTOM FILTER (hide certain buffers)
        custom_filter = function(buf_number, buf_numbers)
          -- Hide buffers with these filetypes
          local excluded_ft = { "qf", "fugitive", "git" }
          local filetype = vim.bo[buf_number].filetype
          
          for _, ft in ipairs(excluded_ft) do
            if filetype == ft then
              return false
            end
          end
          return true
        end,
        
        -- SORTING FUNCTION
        sort_by = 'insert_after_current', -- 'insert_after_current' | 'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs'
        
        -- HIGHLIGHTING GROUPS (customize colors here)
        highlights = {
          -- You can override any highlight group here
          -- Example: Make active buffer stand out more
          buffer_selected = {
            bold = true,
            italic = false,
          },
          -- Make close button more visible
          close_button_selected = {
            fg = '#ff6b6b',
          },
        },
      }
    })
    
    -- DASHBOARD INTEGRATION (your existing code)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dashboard",
      callback = function()
        vim.opt_local.showtabline = 0
      end,
    })
    
    vim.api.nvim_create_autocmd("WinLeave", {
      pattern = "*",
      callback = function()
        if vim.bo.filetype == "dashboard" then
          vim.opt.showtabline = 2
        end
      end,
    })
    
    -- KEYMAPS (uncomment to enable)
    -- vim.keymap.set('n', '<S-h>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
    -- vim.keymap.set('n', '<S-l>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
    -- vim.keymap.set('n', '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', { desc = 'Pin buffer' })
    -- vim.keymap.set('n', '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', { desc = 'Close unpinned buffers' })
    -- vim.keymap.set('n', '<leader>br', '<Cmd>BufferLineCloseRight<CR>', { desc = 'Close buffers to right' })
    -- vim.keymap.set('n', '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', { desc = 'Close buffers to left' })
    -- vim.keymap.set('n', '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', { desc = 'Close other buffers' })
  end
}
