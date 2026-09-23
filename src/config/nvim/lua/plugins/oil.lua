require("oil").setup({
	columns = {
		"permissions",
		"size",
		"mtime",
	},
})
local map = vim.api.nvim_set_keymap
map("n", "<leader>e", ":Oil<cr>", {})
