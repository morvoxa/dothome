return {
  {
    "stevearc/conform.nvim",
    opts = {
      -- 1. Custom Formatter Definitions
      formatters = {
        ["dioxus"] = {
          cmd = { "dx", "fmt", "--file", "$FILENAME" },
        },
        ["clang-format"] = {
          prepend_args = { "--style=Google" },
        },

        ["kdlfmt"] = {
          cmd = { "kdlfmt" },
        },
      },

      -- 2. Formatter per Language
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        cmake = { "gersemi" },
        h = { "clang-format" },
        lua = { "stylua" },
        rust = { "dioxus", "rustfmt" },
        toml = { "taplo" },
        nix = { "nixfmt" },
        python = { "black" },

        -- Web Stack
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        markdown = { "prettier" },
        kdl = { "kdlfmt" },
      },
    },
  },
}
