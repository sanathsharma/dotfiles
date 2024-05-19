-- filetype support for .env.development or .env.local
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
	pattern = ".env*",
	command = "set filetype=sh",
})

vim.cmd("set noexpandtab")
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

-- buffer commands
vim.keymap.set("n", "<leader>ba", "<cmd>bufdo bd<CR>", { desc = "Close [a]ll buffers" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Close current buffer" })
vim.keymap.set("n", "<leader>bc", "<cmd>%bd|e#<CR>", { desc = "Close all but current buffer" })

-- move selected lines up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- exit from insert mode
vim.keymap.set("i", "jk", "<ESC>", { noremap = true, silent = true })

-- half page jump
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- search to stay in middle when switching back and forth between them
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- keep old copied content even after pasting it over another selected content
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Past over selection w/o loosing the clipboard content" })

-- navigating sugestion
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- use plus register for yanking
-- vim.opt.clipboard = "unnamedplus"
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- stay in vim mode after command execution
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true })

-- search and replace, shortcut
vim.keymap.set(
	"n",
	"<leader>sr",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "search and replace" }
)
-- executes search and replace in all the buffers of a quickfix list
vim.keymap.set(
	"n",
	"<leader>sg",
	[[:cdo s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "global search and replace" }
)

-- make the current sh script into an executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "sh file to executable" })

-- rebase current branch
vim.keymap.set(
	"n",
	"<leader>hf",
	"<cmd>!git fetch<CR><cmd>!git rebase<CR>",
	{ desc = "[f]etch origin, and rebase current branch" }
)

vim.keymap.set("n", "<leader>tn", function()
	vim.cmd("set number!")
end, { desc = "Toggle line [n]umbering" })

vim.keymap.set("n", "<leader>tr", function()
	vim.cmd("set relativenumber!")
end, { desc = "Toggle [r]elative line numbering" })

-- copy current buffer paths
vim.api.nvim_create_user_command("CopyCurrentBufferFullPath", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":p")
	vim.fn.setreg("+", path) -- put path to + register (clipboard)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})
vim.api.nvim_create_user_command("CopyCurrentBufferRelPath", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), "")
	vim.fn.setreg("+", path) -- put path to + register (clipboard)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

-- kill a process running in a specific port
vim.keymap.set("n", "<leader>k", function()
	vim.ui.input({
		prompt = "Enter Port: ",
		default = "3000",
	}, function(port)
		if port == nil or port == "" then
			return
		else
			vim.cmd("!sudo kill -9 $(sudo lsof -t -i:" .. port .. ")")
		end
	end)
end, { desc = "[K]ill a process by port number" })

-- see https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua for more helpful configurations and keymaps
-- all configurations and keymaps below this line are from kickstart.nvim template

-- Disable arrow keys in normal mode (to improve vim usage)
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

