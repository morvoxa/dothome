vim.pack.add({
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/nvim-svelte/nvim-svelte-snippets" },
})
-- will exclude all javascript snippets
require("luasnip.loaders.from_vscode").load({
	--	exclude = { "javascript" },
})
require("nvim-svelte-snippets").setup({
	auto_detect = true, -- Only load in SvelteKit projects
})
