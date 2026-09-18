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
	local o = vim.o
	o.number = true
	o.tabstop = 4
	o.shiftwidth = 4
	o.relativenumber = true
	o.clipboard = "unnamedplus"
	local map = vim.api.nvim_set_keymap
	vim.g.mapleader = " "
	map("i", "jk", "<esc>", {})
	map("n", "<leader>w", ":w<cr>", {})
	map("n", "<leader>x", ":bd<cr>", {})
	map("n", "<leader>q", ":q<cr>", {})
	map("n", "<leader>nh", ":nohl<cr>", {})
	vim.pack.add({
		{ src = "https://github.com/folke/flash.nvim" },
		{ src = "https://github.com/windwp/nvim-autopairs" },
		{ src = "https://github.com/stevearc/conform.nvim" },
		{ src = "https://github.com/stevearc/oil.nvim" },
		{ src = "https://github.com/nvim-telescope/telescope.nvim" },
		{ src = "https://github.com/neovim/nvim-lspconfig" },
		{ src = "https://github.com/mrcjkb/rustaceanvim" },
		{ src = "https://github.com/nvim-lua/plenary.nvim" },
		{ src = "https://github.com/j-hui/fidget.nvim" },
		{ src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
	})
	require("fidget").setup({})
	require("blink.cmp").setup({
		keymap = { preset = "default" },

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = { auto_show = false },
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
	})
	require("oil").setup({
		columns = {
			"permissions",
			"size",
			"mtime",
		},
	})
	require("nvim-autopairs").setup()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			rust = { "rustfmt", lsp_format = "fallback" },
			javascript = { "prettier" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "never",
		},
	})

	require("nvim-autopairs").setup({})
	--lsp
	vim.lsp.enable("lua_ls")
	--plugins keymap
	map("n", "<leader>e", ":Oil<cr>", {})
	map("n", "s", '<cmd>lua require("flash").jump()<CR>', { noremap = true, silent = true })
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
	vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
end
