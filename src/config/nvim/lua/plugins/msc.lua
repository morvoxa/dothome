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
require("nvim-ts-autotag").setup({
	opts = {
		-- Defaults
		enable_close = true, -- Auto close tags
		enable_rename = true, -- Auto rename pairs of tags
		enable_close_on_slash = false, -- Auto close on trailing </
	},
	-- Also override individual filetype configs, these take priority.
	-- Empty by default, useful if one of the "opts" global settings
	-- doesn't work well in a specific filetype
	per_filetype = {
		["html"] = {
			enable_close = false,
		},
	},
})

vim.cmd("colorscheme nord")
local transparent_groups = {
	"Normal",
	"SignColumn",
}

for _, group in ipairs(transparent_groups) do
	vim.api.nvim_set_hl(0, group, { bg = "none" })
end
