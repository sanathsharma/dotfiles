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
vim.opt.cmdheight = 1

-- color 120th column to identify formatter overflow
vim.opt.colorcolumn = "120"
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#24273a" })

vim.opt.foldmethod = "manual"
-- vim.o.foldcolumn = "1"
vim.o.foldlevel = 99 -- Using ufo provider need a large value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- store all change in a file, so that we can undo changes which are days old
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.scrolloff = 5
vim.opt.signcolumn = "yes"

-- highlight special characters
vim.cmd("set showbreak=↪·") -- indicate a line break in a long line of text
vim.cmd("set listchars=eol:⏎,tab:⇾·,trail:·,nbsp:⎵,extends:»,precedes:«,space:·")
vim.api.nvim_set_hl(0, "Whitespace", { fg = "NvimDarkGray4" })
vim.keymap.set("n", "<leader>tl", function()
	vim.cmd("set list!")
end, { desc = "Toggle special characters [l]ist" })
vim.cmd("set list") -- highlight special by default

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
