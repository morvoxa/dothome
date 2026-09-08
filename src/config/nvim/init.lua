if vim.g.vscode then
	vim.o.relativenumber = true
	vim.o.number = true
	vim.o.clipboard = "unnamedplus"
	vim.o.ignorecase = true
	vim.o.smartcase = true
	vim.o.hlsearch = true
	vim.o.incsearch = true
	vim.o.scrolloff = 8
	vim.o.sidescrolloff = 8
	vim.o.whichwrap = "b,s,<,>,[,],h,l"
	vim.o.autoindent = true
	vim.o.smartindent = true
	vim.o.timeoutlen = 500
	vim.o.laststatus = 0

	local vscode = require("vscode")
	vim.g.mapleader = " "
	vim.keymap.set("n", "<leader>r", function()
		vscode.action("workbench.action.openRecent")
	end, { desc = "Open Recent Workspaces / Files" })
	vim.keymap.set("n", "<leader>ff", function()
		vscode.action("workbench.action.quickOpen")
	end, { desc = "Find Files" })

	vim.keymap.set("n", "<leader>w", function()
		vscode.action("workbench.action.files.save")
		vscode.notify("File saved successfully!")
	end, { desc = "Save File with Notification" })

	vim.keymap.set("n", "<leader>p", function()
		vscode.action("workbench.action.showCommands")
	end, { desc = "Command Palette" })

	vim.keymap.set("n", "<leader>t", function()
		vscode.action("workbench.action.terminal.toggleTerminal")
	end, { desc = "Toggle Terminal" })

	vim.keymap.set("n", "<leader>e", function()
		vscode.action("workbench.view.explorer")
	end, { desc = "Focus File Explorer" })

	vim.keymap.set("n", "<leader>bd", function()
		vscode.action("workbench.action.closeActiveEditor")
	end, { desc = "Close File" })

	vim.keymap.set("n", "H", function()
		vscode.action("workbench.action.previousEditor")
	end, { desc = "Prev File" })

	vim.keymap.set("n", "L", function()
		vscode.action("workbench.action.nextEditor")
	end, { desc = "Next File" })

	vim.keymap.set("n", "<leader>nh", function()
		vim.cmd("noh")
		vscode.action("notifications.clearAll")
		vscode.action("notifications.hideList")
	end, { desc = "No Highlight & Clear Notifications" })
	vim.pack.add({
		{ src = "https://github.com/folke/flash.nvim" },
	})

	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true, remap = false })
	end

	map({ "n", "x", "o" }, "s", function()
		require("flash").jump()
	end, "Flash")

	map({ "n", "x", "o" }, "S", function()
		require("flash").treesitter()
	end, "Flash Treesitter")

	map("o", "r", function()
		require("flash").remote()
	end, "Remote Flash")

	map({ "o", "x" }, "R", function()
		require("flash").treesitter_search()
	end, "Treesitter Search")

	map("c", "<c-s>", function()
		require("flash").toggle()
	end, "Toggle Flash Search")
else
	local o = vim.opt
	local map = vim.api.nvim_set_keymap
	o.number = true
	o.relativenumber = true
	o.clipboard = "unnamedplus"
	o.tabstop = 2
	o.ignorecase = true
	o.autoindent = true
	o.smartindent = true
	vim.g.mapleader = " "
	map("i", "jk", "<esc>", {})
	map("n", "<leader>w", ":w<esc>", {})
	map("n", "<leader>e", ":Neotree toggle<cr>", {})
	map("n", "<leader>c", ":!", {})

	map("n", "<leader>x", ":bd!<cr>", {})
	map("n", "<leader>nh", ":nohl<cr>", {})
	map("n", "<C-l>", "<C-w>l", {})
	map("n", "<C-h>", "<C-w>h", {})
	map("n", "<leader>ff", ":FzfLua files<cr>", {})
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
			-- Stack Next.js (JavaScript / TypeScript / React)
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			-- Styling & Konfigurasi Web
			css = { "prettier" },
			scss = { "prettier" },
			less = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			graphql = { "prettier" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			kdl = { "kdlfmt" },
			toml = { "taplo" },
			cmake = { "gersemi" },
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
		{ src = "https://github.com/mrcjkb/rustaceanvim" },
		{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
		{ src = "https://github.com/neovim/nvim-lspconfig" },
		{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
		{ src = "https://github.com/windwp/nvim-autopairs" },
		{ src = "https://github.com/j-hui/fidget.nvim" },
		{ src = "https://github.com/ibhagwan/fzf-lua" },
		{ src = "https://github.com/romus204/tree-sitter-manager.nvim" },
		{ src = "https://github.com/Saghen/blink.cmp", version = "v1.10.2" },
	})

	require("neo-tree").setup({
		filesystem = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},
			bind_to_cwd = true,
		},
	})
	require("tree-sitter-manager").setup({
		auto_install = true,
		highlight = true,
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
	vim.lsp.enable("zls")
	--pnpm add -g @tailwindcss/language-server @vtsls/language-server emmet-ls vscode-langservers-extracted prettier oxlint
	vim.lsp.enable("tailwindcss")
	vim.lsp.enable("vtsls")
	vim.lsp.enable("oxlint")
	vim.lsp.enable("emmet_ls")
	vim.lsp.enable("html")
	vim.lsp.enable("cssls")
	vim.lsp.enable("jsonls")
	--pnpm add -g @tailwindcss/language-server @vtsls/language-server emmet-ls vscode-langservers-extracted prettier oxlint
end
