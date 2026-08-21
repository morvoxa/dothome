return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- LSP Standar
        clangd = {},
        lua_ls = {},
        slint_lsp = {},
        --web
        --pnpm add -g @tailwindcss/language-server @vtsls/language-server eslint_d emmet-ls vscode-langservers-extracted prettier prettierd
        tailwindcss = {},
        vtsls = {},
        eslint = {},
        emmet_ls = {},
        html = {},
        cssls = {},
        jsonls = {},
        --
        yamlls = {},
        nixd = {},
        pyright = {},
        ruff_lsp = {},
        taplo = {},
      },
    },
  },
}
