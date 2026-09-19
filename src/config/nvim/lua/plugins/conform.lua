require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		toml = { "taplo" },
		bash = { "shfmt" },
		sh = { "shfmt" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettier" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})
