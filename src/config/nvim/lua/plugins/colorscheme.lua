vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
})
require("tokyonight").setup({
	transparent = true, -- Enable transparency for the main editor window
	styles = {
		sidebars = "transparent", -- Clear background for sidebars
		floats = "transparent", -- Clear background for floating windows
	},
})
vim.cmd("colorscheme tokyonight")
