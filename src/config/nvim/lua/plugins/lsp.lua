return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- LSP Standar
        clangd = { cmd = { "clangd19" } },
        lua_ls = {},
        slint_lsp = {},
        tailwindcss = {},
        vtsls = {},
        eslint = {},
        emmet_ls = {},
        html = {},
        cssls = {},
        jsonls = {},
        yamlls = {},
        nixd = {},
        pyright = {},
        ruff_lsp = {}
      },
    },
  },
}
