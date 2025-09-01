local M = {}

function M.setup()
	vim.g.mapleader = " " -- Set leader key to space
	vim.g.maplocalleader = "\\" -- Set local leader key to backslash
	vim.opt.relativenumber = true -- Show relative line numbers
	vim.opt.number = true -- Show absolute line number for current line
	vim.opt.colorcolumn = "100,120" -- Show vertical lines at columns 100 and 120
	vim.opt.cursorline = true -- Highlight current line
	vim.opt.cursorcolumn = true -- Highlight current column
	vim.opt.expandtab = false -- Use tabs instead of spaces
	vim.opt.shiftwidth = 2 -- Size of an indent
	vim.opt.shiftround = true -- Round indent to multiple of shiftwidth
	vim.opt.tabstop = 2 -- Number of spaces tabs count for
	vim.opt.softtabstop = 2 -- Number of spaces for a tab when editing
	vim.opt.scrolloff = 3 -- Keep 3 lines visible above/below cursor
	vim.opt.signcolumn = "yes" -- Always show sign column
	vim.opt.hlsearch = true -- Highlight search matches
	vim.opt.incsearch = true -- Show search matches as you type
	vim.opt.fixendofline = false -- Don't fix eol and eof
	vim.opt.showbreak = "↪·" -- Indicate a line break in a long line of text
	vim.opt.listchars = "eol:⏎,tab:⇾·,trail:·,nbsp:⎵,extends:»,precedes:«,space:·"
	vim.opt.ignorecase = true -- Ignore case in search
	vim.opt.smartcase = true -- Ignore case if search pattern is all lowercase
	vim.opt.inccommand = "split" -- Incrementally show the matching lines in a horizontal split view
end

function M.setup_fold_opts()
	vim.opt.foldcolumn = "0"
	vim.opt.foldlevel = 99
	vim.opt.foldlevelstart = 99
	vim.opt.foldenable = true
end

return M
