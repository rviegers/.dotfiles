-- Set leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' ' 

-- Relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Case insensitive searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- Sync clipboards
vim.o.clipboard = 'unnamedplus'

-- Highlight yanks
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- FZF lua (fuzzy finder)
vim.pack.add({
    { src = "https://github.com/ibhagwan/fzf-lua" },
})

require("fzf-lua").setup({
	keymap = {
		builtin = {
			["<C-d>"] = 'preview-page-down',
			["<C-u>"] = 'preview-page-up',
		}
	}
})

vim.keymap.set('n', '<leader><leader>', '<cmd>FzfLua files<cr>', { desc = 'Find Files'})
vim.keymap.set('n', '<leader>/', '<cmd>FzfLua live_grep<cr>', { desc = 'Find live grep'}) 

-- Neoscroll
vim.pack.add({
	{ src = "https://github.com/karb94/neoscroll.nvim" },
})

require('neoscroll').setup({
	hide_cursor = false,
	stop_eof = true,
	easing = 'qaudratic',
	duration_multiplier = 0.30, 
})

-- Color scheme (Rosepine)
vim.pack.add({
	{
		src = "https://github.com/rose-pine/neovim",
		name = "rose-pine",
	},
})
require("rose-pine").setup()
vim.cmd("colorscheme rose-pine")


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

