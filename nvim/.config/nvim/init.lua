-- Set leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' ' 

vim.opt.number = false
vim.opt.relativenumber = false

vim.opt.mouse = ""

vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Autosave 
vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost" }, {
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" then
      vim.cmd("silent! write")
    end
  end,
})

