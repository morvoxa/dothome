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
  vim.o.timeoutlen = 300
  vim.o.laststatus = 0

  local vscode = require("vscode")
  vim.g.mapleader = " "
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

  vim.keymap.set("n", "<leader>c", function()
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
  require("config.lazy")
end
