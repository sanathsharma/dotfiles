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

-- Disable arrow keys in normal mode (to improve vim usage)
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set(
	"n",
	"<leader>lg",
	":!tmux new-window -c " .. vim.fn.getcwd() .. " -- lazygit <CR><CR>",
	{ desc = "Lazy[g]it in new tmux window", silent = true }
)
vim.keymap.set(
	"n",
	"<leader>ld",
	":!tmux new-window -c " .. vim.fn.getcwd() .. " -- lazydocker <CR><CR>",
	{ desc = "Lazy[d]ocker in new tmux window", silent = true }
)
