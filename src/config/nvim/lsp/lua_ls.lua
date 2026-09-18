return {
	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						vim.api.nvim_get_runtime_file("", true),
					},
				},
			},
		},
	}),
}
