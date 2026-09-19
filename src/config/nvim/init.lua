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
		{ silent = true }
	)
	map("n", "<leader>t", ":lua require('vscode').action('workbench.action.terminal.focus')<cr>", { silent = true })
	map("n", "<leader>nh", ":lua require('vscode').action('notifications.clearAll')<cr>:nohl<cr>", { silent = true })
	map("n", "L", ":lua require('vscode').action('workbench.action.nextEditor')<cr>", { silent = true })
	map("n", "H", ":lua require('vscode').action('workbench.action.previousEditor')<cr>", { silent = true })
	map("n", "<leader>x", ":lua require('vscode').action('workbench.action.closeActiveEditor')<cr>", { silent = true })
	map("n", "<leader>r", ":lua require('vscode').action('workbench.action.openRecent')<cr>", { silent = true })
	map("n", "<leader>e", ":lua require('vscode').action('workbench.view.explorer')<cr>", { silent = true })
	vim.pack.add({
		{ src = "https://github.com/folke/flash.nvim" },
	})
	vim.api.nvim_set_keymap("n", "s", '<cmd>lua require("flash").jump()<CR>', { noremap = true, silent = true })
else
	vim.pack.add({
		{ src = "https://github.com/folke/flash.nvim" },
		{ src = "https://github.com/windwp/nvim-autopairs" },
		{ src = "https://github.com/stevearc/conform.nvim" },
		{ src = "https://github.com/stevearc/oil.nvim" },
		{ src = "https://github.com/nvim-telescope/telescope.nvim" },
		{ src = "https://github.com/neovim/nvim-lspconfig" },
		{ src = "https://github.com/yorumicolors/yorumi.nvim" },
		{ src = "https://github.com/mrcjkb/rustaceanvim" },
		{ src = "https://github.com/nvim-lua/plenary.nvim" },
		{ src = "https://github.com/j-hui/fidget.nvim" },
		{ src = "https://github.com/folke/trouble.nvim" },
		{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
		{ src = "https://github.com/romus204/tree-sitter-manager.nvim" },
		{ src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
		{ src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
	})
	require("core.options")
	require("core.keymaps")
	require("plugins.blink")
	require("plugins.conform")
	require("plugins.lsp")
	require("plugins.msc")
end
