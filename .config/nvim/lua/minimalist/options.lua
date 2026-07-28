local M = {}

function M.setup()
	vim.g.mapleader = " " -- Set leader key to space
	vim.g.maplocalleader = "\\" -- Set local leader key to backslash
	vim.opt.colorcolumn = "100,120" -- Show vertical lines at columns 100 and 120
	vim.opt.cursorline = true -- Highlight current line
	vim.opt.cursorcolumn = true -- Highlight current column

	-- Indent options
	vim.opt.expandtab = false -- Use tabs instead of spaces
	vim.opt.shiftwidth = 2 -- Size of an indent
	vim.opt.shiftround = true -- Round indent to multiple of shiftwidth
	vim.opt.tabstop = 2 -- Number of spaces tabs count for
	vim.opt.softtabstop = 2 -- Number of spaces for a tab when editing
	vim.opt.smartindent = true -- Smart autoindenting
	vim.opt.autoindent = true -- Copy indent from current line

	vim.opt.scrolloff = 3 -- Keep 3 lines visible above/below cursor
	vim.opt.hlsearch = true -- Highlight search matches
	vim.opt.incsearch = true -- Show search matches as you type
	vim.opt.ignorecase = true -- Ignore case in search
	vim.opt.smartcase = true -- Ignore case if search pattern is all lowercase

	vim.opt.showbreak = "↪·" -- Indicate a line break in a long line of text
	vim.opt.listchars = "eol:⏎,tab:⇾·,trail:·,nbsp:⎵,extends:»,precedes:«,space:·"
	vim.opt.list = true -- Show list chars

	vim.opt.inccommand = "split" -- Incrementally show the matching lines in a horizontal split view
	vim.opt.swapfile = false -- Disable swap file
	vim.opt.conceallevel = 0 -- Hide all concealables
	vim.opt.winborder = "rounded" -- Enable rounded borders
	vim.cmd("set completeopt+=noselect") -- Disable selecting the popup menu
	vim.opt.splitright = true -- Horizontal splits on the right
	vim.opt.splitbelow = true -- Vertical splits below the current window
	vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
	-- vim.opt.exrc = true -- Read .nvimrc,.nvim.lua,.exrc in the current directory
	vim.opt.showmatch = true -- Highlight matching brackets
	vim.opt.updatetime = 300 -- Faster completion
	vim.opt.autoread = true -- Automatically read changed files from outside Neovim
	vim.opt.autowrite = false
	vim.opt.autochdir = false
	vim.opt.iskeyword:append("-") -- Don't consider words with '-' as keywords
	vim.opt.selection = "inclusive"
	-- vim.opt.clipboard:append("unnamedplus")
	vim.opt.encoding = "utf-8"
	vim.opt.termguicolors = true

	-- Status columns configuration
	vim.opt.statuscolumn = "%s%=%l %C "
	vim.opt.signcolumn = "yes:2" -- Show sign column, 2 columns
	vim.opt.relativenumber = true -- Show relative line numbers
	vim.opt.number = true -- Show absolute line number for current line
end

function M.setup_fold_opts()
	vim.opt.foldcolumn = "1" -- Show fold column, only 1
	vim.opt.foldlevel = 99
	vim.opt.foldlevelstart = 99
	vim.opt.foldenable = true
	vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:"
end

function M.setup_undodir_opts()
	vim.opt.undodir = vim.fn.expand("~") .. "/.undodir"
	vim.opt.undofile = true
end

function M.setup_terminal_opts()
	vim.opt.number = false
	vim.opt.relativenumber = false
end

return M
