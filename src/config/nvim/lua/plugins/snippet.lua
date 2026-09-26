vim.pack.add({
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/nvim-svelte/nvim-svelte-snippets" },
})
require("luasnip.loaders.from_vscode").load({
	exclude = { "javascript" },
})
