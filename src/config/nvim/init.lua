local o = vim.opt
local map = vim.api.nvim_set_keymap
o.number = true
o.relativenumber = true
o.clipboard = "unnamedplus"
o.tabstop = 2
vim.g.mapleader = " "
map("i", "jk", "<esc>", {})
map("n", "<leader>w", ":w<esc>", {})
map("n", "<leader>e", ":Neotree toggle<cr>", {})
map("n", "<leader>c", ":!", {})
map("n", "<leader>x", ":bdel<cr>", {})
map("n", "<C-l>", "<C-w>l", {})
map("n", "<C-h>", "<C-w>h", {})
local function toggle_lsp_features()
	local current_buf = vim.api.nvim_get_current_buf()
	local current_config = vim.diagnostic.config()
	local virtual_text_enabled = current_config and current_config.virtual_text ~= false
	local target_state = not virtual_text_enabled
	vim.diagnostic.config({
		virtual_text = target_state,
		signs = true,
	})

	local hint_status = ""
	if vim.lsp.inlay_hint then
		vim.lsp.inlay_hint.enable(target_state, { bufnr = current_buf })
		hint_status = target_state and " & Hints Enabled" or " & Hints Disabled"
	end
	local msg = target_state and "LSP Text: ENABLED" or "LSP Text: DISABLED"
	vim.notify(msg .. hint_status, vim.log.levels.INFO)
end
vim.keymap.set("n", "<leader>hh", toggle_lsp_features, { desc = "Toggle LSP Diagnostics & Inlay Hints" })

vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})
vim.pack.add({
	"https://github.com/folke/flash.nvim",
})
require("flash").setup({})
vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash Jump" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })
vim.keymap.set("c", "<c-s>", function()
	require("flash").toggle()
end, { desc = "Toggle Flash Search" })

vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.10.2" },
})
require("fidget").setup({})
vim.notify = require("fidget").notify
require("nvim-autopairs").setup({})
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
vim.lsp.enable("clangd")
vim.lsp.enable("lua_ls")
