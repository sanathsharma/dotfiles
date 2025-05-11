-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.cmd("set noexpandtab") -- tabs
-- vim.cmd("set expandtab") -- spaces
vim.cmd("set shiftwidth=2")
vim.cmd("set softtabstop=2")
vim.cmd("set tabstop=2")
vim.opt.relativenumber = true
vim.opt.mouse = ""
vim.opt.number = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.conceallevel = 2
vim.opt.smartcase = false
vim.opt.ignorecase = true

-- color 120th column to identify formatter overflow
vim.opt.colorcolumn = "100,120"

vim.opt.cursorline = true
vim.opt.cursorcolumn = true

vim.opt.foldmethod = "manual"
-- vim.o.foldcolumn = "1"
vim.o.foldlevel = 99 -- Using ufo provider need a large value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldnestmax = 1

-- store all change in a file, so that we can undo changes which are days old
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.scrolloff = 5
vim.opt.signcolumn = "yes"

-- highlight special characters
vim.cmd("set showbreak=↪·") -- indicate a line break in a long line of text
vim.cmd("set listchars=eol:⏎,tab:⇾·,trail:·,nbsp:⎵,extends:»,precedes:«,space:·")
-- vim.opt.list = false
vim.keymap.set("n", "<leader>tl", function()
	vim.cmd("set list!")
end, { desc = "Toggle special characters [l]ist" })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Undercurl
if vim.fn.has("termguicolors") == 1 then
	vim.o.termguicolors = true
	-- Enable undercurl
	vim.api.nvim_set_var("t_Cs", "\\e[4:3m")
	vim.api.nvim_set_var("t_Ce", "\\e[4:0m")
end

if vim.g.vscode == nil then
	-- Spell checking
	vim.opt.spell = true
	vim.opt.spelllang = { "en_us" }
end

-- Enable loader to speed up start time
if vim.loader then
	vim.loader.enable()
end

vim.g.neovide_scale_factor = 0.95
