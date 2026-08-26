return {
  "mrcjkb/rustaceanvim",
  version = "^9",
  lazy = false,
  config = function(_, opts)
    vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
  end,
  opts = {
    server = {
      default_settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "check",
          },
        },
      },
    },
  },
}
