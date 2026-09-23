require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		toml = { "taplo" },
		bash = { "shfmt" },
		sh = { "shfmt" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },

		javascript = { "oxfmt" },
		javascriptreact = { "oxfmt" },
		typescript = { "oxfmt" },
		typescriptreact = { "oxfmt" },
		json = { "oxfmt" },
		jsonc = { "oxfmt" },
		html = { "oxfmt" },
		css = { "oxfmt" },
		scss = { "oxfmt" },
		markdown = { "oxfmt" },
		yaml = { "oxfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		h = { "clang-format" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "never",
	},
})
