local map = vim.api.nvim_set_keymap
vim.g.mapleader = " "
map("i", "jk", "<esc>", {})
map("n", "<leader>w", ":w<cr>", {})
map("n", "<leader>x", ":bd<cr>", {})
map("n", "<leader>q", ":q<cr>", {})
map("n", "<leader>nh", ":nohl<cr>", {})
map("n", "<C-h>", "<C-w>w", {})

map("n", "s", '<cmd>lua require("flash").jump()<CR>', { noremap = true, silent = true })
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle focus=true<cr>", { silent = true, noremap = true })
