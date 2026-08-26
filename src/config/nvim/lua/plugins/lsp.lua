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
        --pnpm add -g @tailwindcss/language-server @vtsls/language-server emmet-ls vscode-langservers-extracted prettier oxlint
        tailwindcss = {},
        vtsls = {},
        oxlint = {},
        emmet_ls = {},
        html = {},
        cssls = {},
        jsonls = {},
        --
        yamlls = {},
        nixd = {},
        pyright = {},
        taplo = {},
        zls = {},
      },
    },
  },
}
