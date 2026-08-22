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
        --pnpm add -g @tailwindcss/language-server @vtsls/language-server eslint_d emmet-ls vscode-langservers-extracted prettier
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
        jedi_language_server = {}, --uv tool install jedi-language-server
        ruff = {}, --uv tool install ruff
        pylyzer = {}, --uv tool install pylyzer
        taplo = {},
      },
    },
  },
}
