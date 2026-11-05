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

-- Navigate through nvim splits with ctrl h, j, k, l
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move to split below' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move to split above' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move to split right' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move to split left' })

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
	easing = 'quadratic',
	duration_multiplier = 0.30, 
})

-- Color scheme (Rosepine)
vim.pack.add({
	{
		src = "https://github.com/rose-pine/neovim",
		name = "rose-pine",
	},
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/AlexvZyl/nordic.nvim" },
	{ src = "https://github.com/sainnhe/everforest" },
	{ src = "https://github.com/EdenEast/nightfox.nvim" },
	{ src = "https://github.com/morhetz/gruvbox" },
})
require("rose-pine").setup({ variant = "moon" })
vim.opt.background = 'dark'
vim.g.everforest_background = 'hard'
vim.g.gruvbox_contrast_dark = 'hard'
local theme_file = vim.fn.expand('~/.config/terminal-theme/current')
local selected
local function apply_terminal_theme()
  local name = vim.fn.filereadable(theme_file) == 1 and vim.fn.readfile(theme_file)[1] or 'rose-pine-moon'
  if name == selected then return end
  local schemes = {
    ['rose-pine-moon'] = 'rose-pine-moon',
    ['rose-pine-main'] = 'rose-pine-main',
    ['kanagawa-dragon'] = 'kanagawa-dragon',
    ['nordic'] = 'nordic',
    ['everforest-dark'] = 'everforest',
    ['nightfox'] = 'nightfox',
    ['gruvbox-dark'] = 'gruvbox',
  }
  local ok, err = pcall(vim.cmd.colorscheme, schemes[name] or 'rose-pine')
  if ok then
    selected = name
  else
    vim.notify('Could not apply terminal theme: ' .. tostring(err), vim.log.levels.WARN)
  end
end
apply_terminal_theme()

-- Watch the directory because the switcher replaces the file atomically.
local theme_dir = vim.fn.fnamemodify(theme_file, ':h')
vim.fn.mkdir(theme_dir, 'p')
local theme_watcher = vim.uv.new_fs_event()
if theme_watcher then
  local ok = theme_watcher:start(theme_dir, {}, function(err, filename)
    if not err and (filename == 'current' or filename == nil) then
      vim.schedule(apply_terminal_theme)
    end
  end)
  if not ok then theme_watcher:close() end
  vim.api.nvim_create_autocmd('VimLeavePre', { callback = function()
    if not theme_watcher:is_closing() then theme_watcher:stop(); theme_watcher:close() end
  end })
end

-- One status line for all splits
vim.pack.add({
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
})
vim.opt.laststatus = 3
require('lualine').setup({
  options = {
    theme = 'auto',
    globalstatus = true,
    icons_enabled = false,
    section_separators = '',
    component_separators = '│',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {},
    lualine_c = { { 'filename', path = 1 }, 'diagnostics' },
    lualine_x = { 'filetype' },
    lualine_y = {},
    lualine_z = { 'location' },
  },
})
-- Don't show mode in text, since have Lualine now
vim.opt.showmode = false

vim.opt.cmdheight = 0

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

