vim.cmd("colorscheme nord")
local transparent_groups = {
	"Normal",
	"SignColumn",
}

for _, group in ipairs(transparent_groups) do
	vim.api.nvim_set_hl(0, group, { bg = "none" })
end
