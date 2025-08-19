return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  init = function()
    -- Disable netrw completely to prevent conflicts
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    -- Disable any default keymaps that Neo-tree might set
    vim.g.neo_tree_remove_legacy_commands = 1
  end,
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      sources = { "filesystem", "buffers", "git_status" },
      default_source = "filesystem",
      popup_border_style = "rounded",
      enable_normal_mode_for_inputs = false,
      filesystem = {
        bind_to_cwd = true,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "disabled", -- Prevent netrw hijacking
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      buffers = {
        follow_current_file = true,
        group_empty_dirs = true,
        show_unloaded = true,
      },
      git_status = {
        window = {
          position = "float",
        },
      },
      window = {
        position = "left",
        width = 32,
        mappings = {
          ["<space>"] = "toggle_node",
          ["<cr>"] = "open",
          ["<2-LeftMouse>"] = "open", -- Add mouse support
          ["o"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["C"] = "close_node",
          ["z"] = "close_all_nodes",
          ["a"] = {
            "add",
            config = {
              show_path = "relative",
            },
          },
          ["d"] = "delete",
          ["r"] = "rename",
          ["x"] = "cut_to_clipboard",
          ["c"] = "copy_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["q"] = "close_window",
          ["R"] = "refresh",
        },
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
    })
    -- Manually remove any leader keymaps that might have been set
    local function clear_neotree_leader_maps()
      local leader_keys = { 'e', 'E', 'ge', 'be', 'o', 'n', 'nt', 'ne', 'nf', 'ng', 'nb', 'nr' }
      for _, key in ipairs(leader_keys) do -- Fixed syntax error: was *, should be _
        pcall(vim.keymap.del, 'n', '<leader>' .. key)
      end
    end
    -- Clear immediately and after a delay
    clear_neotree_leader_maps()
    vim.defer_fn(clear_neotree_leader_maps, 100)
  end,
}
