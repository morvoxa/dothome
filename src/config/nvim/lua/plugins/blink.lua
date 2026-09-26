vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mrcjkb/rustaceanvim" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
})
require("blink.cmp").setup({
	snippets = { preset = "luasnip" },
	keymap = { preset = "default" },

	appearance = {
		nerd_font_variant = "mono",
	},

	completion = {
		documentation = { auto_show = true },
	},

	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},

	fuzzy = {
		implementation = "rust",
	},
})
require("tiny-inline-diagnostic").setup()
require("trouble").setup({})
