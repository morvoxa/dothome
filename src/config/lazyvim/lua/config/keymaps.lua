local map = vim.keymap.set
map("i", "jk", "<Esc>", { desc = "Exit Insert Mode" })
map("n", "<leader>w", ":w<cr>", { desc = "Save File" })
map("n", "<leader>1", "<C-w>w", { desc = "Switch Window" })

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
map("n", "<leader>hh", toggle_lsp_features, { desc = "Toggle LSP Diagnostics & Inlay Hints" })
