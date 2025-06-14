return {
  -- Main LSP configuration
  {
    "dundalek/lazy-lsp.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
      
      -- Enhanced nvim-cmp setup with more sources
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "saadparwaiz1/cmp_luasnip",
      
      -- Snippet engine (required for cmp)
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
      },

      -- Enhanced syntax highlighting
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",

      -- Additional language support
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Syntax-aware features
      "windwp/nvim-autopairs",
      "windwp/nvim-ts-autotag",
      "JoosepAlviste/nvim-ts-context-commentstring",

      -- Enhanced diagnostics
      "folke/trouble.nvim",
      
      -- Better UI for completion
      "onsails/lspkind.nvim",
    },
    config = function()
      local lsp_zero = require("lsp-zero")

      -- NixOS compatibility: Check if we're on NixOS
      local function is_nixos()
        local f = io.open("/etc/os-release", "r")
        if f then
          local content = f:read("*all")
          f:close()
          return content:match("ID=nixos") ~= nil
        end
        return false
      end

      -- NixOS compatibility: Helper to find system binaries
      local function find_system_binary(name)
        local paths = {
          "/run/current-system/sw/bin/" .. name,
          "/etc/profiles/per-user/" .. os.getenv("USER") .. "/bin/" .. name,
          "/home/" .. os.getenv("USER") .. "/.nix-profile/bin/" .. name,
        }

        for _, path in ipairs(paths) do
          if vim.fn.executable(path) == 1 then
            return path
          end
        end

        -- Fallback to system PATH
        if vim.fn.executable(name) == 1 then
          return name
        end

        return nil
      end

      -- Setup LuaSnip first
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Custom snippet configuration
      luasnip.config.setup({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
      })

      -- Enhanced nvim-cmp setup
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpDoc",
          }),
        },
        
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              -- Source indicator
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snip]",
                buffer = "[Buf]",
                path = "[Path]",
                nvim_lua = "[Lua]",
                nvim_lsp_signature_help = "[Sig]",
                nvim_lsp_document_symbol = "[Sym]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        
        mapping = cmp.mapping.preset.insert({
          -- Enhanced navigation
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          
          -- Accept completion
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
          
          -- Tab for snippet navigation and completion
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "nvim_lsp_signature_help", priority = 900 },
          { name = "luasnip", priority = 800 },
          { name = "nvim_lua", priority = 700 },
        }, {
          { name = "buffer", priority = 500, keyword_length = 3 },
          { name = "path", priority = 400 },
          { name = "nvim_lsp_document_symbol", priority = 300 },
        }),
        
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        
        performance = {
          debounce = 60,
          throttle = 30,
          fetching_timeout = 500,
          confirm_resolve_timeout = 80,
          async_budget = 1,
          max_view_entries = 200,
        },
      })

      -- Setup completion for command line
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "nvim_lsp_document_symbol" }
        }
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          { name = "cmdline" }
        })
      })

      -- Enhanced LSP attach function with better keymaps
      lsp_zero.on_attach(function(client, bufnr)
        -- Enable semantic highlighting if supported
        if client.server_capabilities.semanticTokensProvider then
          vim.lsp.semantic_tokens.start(bufnr, client.id)
        end
        
        -- Enhanced LSP keymaps
        local opts = { buffer = bufnr, silent = true }
        
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
        vim.keymap.set({"n", "x"}, "<F3>", function() vim.lsp.buf.format({async = true}) end, opts)
        vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      end)

      -- Setup lazy-lsp with enhanced configuration
      require("lazy-lsp").setup({
        -- Exclude servers that need special configuration
        excluded_servers = {
          "ccls", -- Use clangd instead
          "denols", -- Conflicts with ts_ls
        },

        -- Prefer certain servers
        preferred_servers = {
          markdown = {},  -- No LSP for markdown, treesitter handles it
          python = { "pyright", "pylsp" },
          javascript = { "ts_ls" },
          typescript = { "ts_ls" },
          lua = { "lua_ls" },
          rust = { "rust_analyzer" },
          go = { "gopls" },
          c = { "clangd" },
          cpp = { "clangd" },
        },

        -- Default configuration for all servers with enhanced capabilities
        default_config = {
          capabilities = vim.tbl_deep_extend(
            "force",
            lsp_zero.get_capabilities(),
            require("cmp_nvim_lsp").default_capabilities()
          ),
        },

        -- Server-specific configurations
        configs = {
          lua_ls = {
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
                telemetry = { enable = false },
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          },

          ts_ls = {
            settings = {
              typescript = {
                preferences = {
                  includePackageJsonAutoImports = "auto",
                },
                suggest = {
                  includeCompletionsForModuleExports = true,
                },
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
              javascript = {
                preferences = {
                  includePackageJsonAutoImports = "auto",
                },
                suggest = {
                  includeCompletionsForModuleExports = true,
                },
              },
            },
          },

          pyright = {
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "basic",
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  completeFunctionParens = true,
                },
              },
            },
          },

          rust_analyzer = {
            settings = {
              ["rust-analyzer"] = {
                cargo = {
                  allFeatures = true,
                },
                checkOnSave = {
                  command = "clippy",
                },
                completion = {
                  addCallParentheses = true,
                  addCallArgumentSnippets = true,
                },
                inlayHints = {
                  bindingModeHints = {
                    enable = false,
                  },
                  chainingHints = {
                    enable = true,
                  },
                  closingBraceHints = {
                    enable = true,
                    minLines = 25,
                  },
                  closureReturnTypeHints = {
                    enable = "never",
                  },
                  lifetimeElisionHints = {
                    enable = "never",
                    useParameterNames = false,
                  },
                  maxLength = 25,
                  parameterHints = {
                    enable = true,
                  },
                  reborrowHints = {
                    enable = "never",
                  },
                  renderColons = true,
                  typeHints = {
                    enable = true,
                    hideClosureInitialization = false,
                    hideNamedConstructor = false,
                  },
                },
              },
            },
          },

          gopls = {
            settings = {
              gopls = {
                completeUnimported = true,
                usePlaceholders = true,
                analyses = {
                  unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
              },
            },
          },

          clangd = {
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--header-insertion=iwyu",
              "--completion-style=detailed",
              "--function-arg-placeholders",
              "--fallback-style=llvm",
            },
            init_options = {
              usePlaceholders = true,
              completeUnimported = true,
              clangdFileStatus = true,
            },
          },

          -- NixOS-specific: Configure nixd LSP if available
          nixd = {
            cmd = { find_system_binary("nixd") or "nixd" },
            settings = {
              nixd = {
                nixpkgs = {
                  expr = "import <nixpkgs> { }",
                },
                formatting = {
                  command = { find_system_binary("nixfmt") or "nixfmt" },
                },
                options = {
                  nixos = {
                    expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
                  },
                  home_manager = {
                    expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
                  },
                },
              },
            },
          },

          -- Alternative: nil LSP for Nix
          nil_ls = {
            cmd = { find_system_binary("nil") or "nil" },
            settings = {
              ['nil'] = {
                formatting = {
                  command = { find_system_binary("nixfmt") or "nixfmt" },
                },
              },
            },
          },
        },
      })

      -- Setup Mason with NixOS considerations
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        },
        -- NixOS: Mason might have issues with paths, but we'll try to make it work
        install_root_dir = vim.fn.stdpath("data") .. "/mason",
      })

      -- NixOS-aware LSP server list
      local ensure_installed = {
        "lua_ls",
        "ts_ls", -- Changed from tsserver to ts_ls
        "pyright",
        "rust_analyzer",
        "gopls",
        "clangd",
        "bashls",
        "jsonls",
        "yamlls",
        "marksman", -- Markdown
        "cssls",
        "html",
        "tailwindcss",
      }

      -- Add Nix LSP if on NixOS or if Nix is available
      if is_nixos() or vim.fn.executable("nix") == 1 then
        -- Prefer nixd if available, otherwise nil_ls
        if find_system_binary("nixd") then
          table.insert(ensure_installed, "nixd")
        elseif find_system_binary("nil") then
          table.insert(ensure_installed, "nil_ls")
        end
      end

      require("mason-lspconfig").setup({
        automatic_installation = not is_nixos(), -- Disable on NixOS, prefer system packages
        ensure_installed = ensure_installed,
      })
    end
  },

  -- Modern formatting with conform.nvim
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      -- NixOS compatibility: Helper to find system binaries
      local function find_system_binary(name)
        local paths = {
          "/run/current-system/sw/bin/" .. name,
          "/etc/profiles/per-user/" .. os.getenv("USER") .. "/bin/" .. name,
          "/home/" .. os.getenv("USER") .. "/.nix-profile/bin/" .. name,
        }

        for _, path in ipairs(paths) do
          if vim.fn.executable(path) == 1 then
            return path
          end
        end

        -- Fallback to system PATH
        if vim.fn.executable(name) == 1 then
          return name
        end

        return nil
      end

      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          rust = { "rustfmt" },
          go = { "gofmt" },
          nix = { "nixfmt" },
        },

        -- NixOS: Override formatter commands to use system binaries
        formatters = {
          stylua = {
            command = find_system_binary("stylua") or "stylua",
          },
          black = {
            command = find_system_binary("black") or "black",
          },
          prettier = {
            command = find_system_binary("prettier") or "prettier",
          },
          rustfmt = {
            command = find_system_binary("rustfmt") or "rustfmt",
          },
          gofmt = {
            command = find_system_binary("gofmt") or "gofmt",
          },
          nixfmt = {
            command = find_system_binary("nixfmt") or "nixfmt",
          },
        },

        -- Format on save
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- Modern linting with nvim-lint
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- NixOS compatibility: Helper to find system binaries
      local function find_system_binary(name)
        local paths = {
          "/run/current-system/sw/bin/" .. name,
          "/etc/profiles/per-user/" .. os.getenv("USER") .. "/bin/" .. name,
          "/home/" .. os.getenv("USER") .. "/.nix-profile/bin/" .. name,
        }

        for _, path in ipairs(paths) do
          if vim.fn.executable(path) == 1 then
            return path
          end
        end

        -- Fallback to system PATH
        if vim.fn.executable(name) == 1 then
          return name
        end

        return nil
      end

      local lint = require("lint")

      lint.linters_by_ft = {
        python = { "flake8" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        nix = { "statix" },
      }

      -- NixOS: Override linter commands
      if find_system_binary("flake8") then
        lint.linters.flake8.cmd = find_system_binary("flake8")
      end
      if find_system_binary("eslint_d") then
        lint.linters.eslint_d.cmd = find_system_binary("eslint_d")
      end
      if find_system_binary("statix") then
        lint.linters.statix.cmd = find_system_binary("statix")
      end

      -- Auto-lint on save and text changed
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- Enhanced Treesitter configuration
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "query",
          "javascript", "typescript", "tsx",
          "python", "rust", "go", "c", "cpp",
          "html", "css", "scss", "json", "yaml", "toml",
          "markdown", "markdown_inline",
          "bash", "fish", "dockerfile",
          "gitignore", "gitcommit", "diff",
          "regex", "sql",
          "nix", -- Add Nix support
        },

        auto_install = true,

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        indent = {
          enable = true,
        },

        incremental_selection = {
          enable = false,
        },

        textobjects = {
          select = {
            enable = false,
          },
          move = {
            enable = false,
          },
        },
      })

      -- Setup treesitter context
      require("treesitter-context").setup({
        enable = true,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = 'outer',
        mode = 'cursor',
      })
    end
  },

  -- Enhanced autopairs with treesitter integration
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true, -- Enable treesitter integration
        ts_config = {
          lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
          javascript = { "template_string" },
          java = false, -- Don't check treesitter on java
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
          map = '<M-e>',
          chars = { '{', '[', '(', '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=],
          end_key = '$',
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'Search',
          highlight_grey = 'Comment'
        },
      })

      -- Integration with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
  },

  -- Auto-close and rename HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
        per_filetype = {
          ["html"] = { enable_close = false },
        }
      })
    end
  },

  -- Context-aware commenting
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
    config = function(_, opts)
      require("ts_context_commentstring").setup(opts)
      vim.g.skip_ts_context_commentstring_module = true
    end
  },

  -- Better diagnostics UI
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    config = function()
      require("trouble").setup({
        use_diagnostic_signs = true,
      })
    end
  },
}
