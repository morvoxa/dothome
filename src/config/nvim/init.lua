if vim.g.vscode then
	local vscode = require("vscode")
	local o = vim.o
	o.clipboard = "unnamedplus"
	o.ignorecase = true
	local map = vim.api.nvim_set_keymap
	vim.notify = vscode.notify
	vim.g.mapleader = " "
	map(
		"n",
		"<leader>w",
		":lua require('vscode').action('workbench.action.files.save')<cr>:lua require('vscode').notify('Saved Succesfully')<cr>",
		{}
	)
	map("n", "<leader>t", ":lua require('vscode').action('workbench.action.terminal.focus')<cr>", {})
	map("n", "<leader>nh", ":lua require('vscode').action('notifications.clearAll')<cr>:nohl<cr>", {})
	map("n", "L", ":lua require('vscode').action('workbench.action.nextEditor')<cr>", {})
	map("n", "H", ":lua require('vscode').action('workbench.action.previousEditor')<cr>", {})
	map("n", "<leader>x", ":lua require('vscode').action('workbench.action.closeActiveEditor')<cr>", {})
	map("n", "<leader>r", ":lua require('vscode').action('workbench.action.openRecent')<cr>", {})
	map("n", "<leader>e", ":lua require('vscode').action('workbench.view.explorer')<cr>", {})
	vim.pack.add({
		{ src = "https://github.com/folke/flash.nvim" },
	})
	vim.api.nvim_set_keymap("n", "s", '<cmd>lua require("flash").jump()<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap("x", "s", '<cmd>lua require("flash").jump()<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap("o", "s", '<cmd>lua require("flash").jump()<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "S", '<cmd>lua require("flash").treesitter()<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap("x", "S", '<cmd>lua require("flash").treesitter()<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap("o", "S", '<cmd>lua require("flash").treesitter()<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap("o", "r", '<cmd>lua require("flash").remote()<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap(
		"o",
		"R",
		'<cmd>lua require("flash").treesitter_search()<CR>',
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"x",
		"R",
		'<cmd>lua require("flash").treesitter_search()<CR>',
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap("c", "<c-s>", '<cmd>lua require("flash").toggle()<CR>', { noremap = true, silent = true })
else
end
