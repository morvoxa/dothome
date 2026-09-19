require("tiny-inline-diagnostic").setup()
vim.diagnostic.config({ virtual_text = false })
require("ibl").setup()
require("trouble").setup({})
require("tree-sitter-manager").setup({
	auto_install = true,
})
require("fidget").setup({})
vim.notify = require("fidget").notify
require("oil").setup({
	columns = {
		"permissions",
		"size",
		"mtime",
	},
})
require("nvim-autopairs").setup()

vim.cmd("colorscheme yorumi")
