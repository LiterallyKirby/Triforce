return {
  "SmiteshP/nvim-navic",
  dependencies = "neovim/nvim-lspconfig",
  config = function()
    local navic = require("nvim-navic")
    vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

    -- Example for attaching navic to LSP
    local on_attach = function(client, bufnr)
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end
    end

    -- Add this on_attach to your LSP setup:
    require("lspconfig").lua_ls.setup({
      on_attach = on_attach,
      settings = {
        Lua = { diagnostics = { globals = { "vim" } } },
      },
    })
  end,
}

