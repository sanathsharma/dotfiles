-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

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

-- stay in vim mode after command execution
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true })

vim.api.nvim_set_keymap("n", "ge", "G", { noremap = true })
vim.api.nvim_set_keymap("v", "ge", "G", { noremap = true })
vim.api.nvim_set_keymap("n", "d", "x", { noremap = true })
vim.api.nvim_set_keymap("n", "x", "V$", { noremap = true })
vim.api.nvim_set_keymap("n", "U", "<c-r>", { noremap = true })
vim.keymap.set("n", "m", "<Nop>", { noremap = true })
vim.keymap.set("v", "m", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("n", "mi", "vi", { noremap = true })
vim.api.nvim_set_keymap("n", "ma", "va", { noremap = true })
vim.api.nvim_set_keymap("n", "gh", "0", { noremap = true })
vim.api.nvim_set_keymap("v", "gh", "0", { noremap = true })
vim.api.nvim_set_keymap("n", "gl", "$", { noremap = true })
vim.api.nvim_set_keymap("v", "gl", "$", { noremap = true })
vim.api.nvim_set_keymap("n", "gs", "^", { noremap = true })
vim.api.nvim_set_keymap("v", "gs", "^", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>c", "gcc", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>C", "gbc", { noremap = true })
vim.api.nvim_set_keymap("v", "<leader>c", "gc", { noremap = true })
vim.api.nvim_set_keymap("v", "<leader>C", "gb", { noremap = true })
vim.api.nvim_set_keymap("n", "mm", "%", { noremap = true })
vim.api.nvim_set_keymap("v", "mm", "%", { noremap = true })
vim.keymap.set("n", "<leader>k", function()
	vim.lsp.buf.hover()
end, { noremap = true })
vim.api.nvim_set_keymap("n", "%", "ggVG", { noremap = true })
vim.api.nvim_set_keymap("v", "%", "<ESC>ggVG", { noremap = true })
-- check if selection spans from first letter of first line to last letter of last line
-- If yes, apply j$ (move down and to end of line), else apply V (switch to line-wise visual mode)
vim.keymap.set("v", "x", function()
	if vim.fn.mode() == "V" then
		vim.cmd("normal! j$")
	else
		vim.cmd("normal! V")
	end
end, { noremap = true })

vim.keymap.set("n", "<leader>th", function()
	if vim.lsp.inlay_hint == nil then
		print("Error: inlay hints not supported by LSP")
		return
	end

	-- toggle inlay hints
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle inlay [h]ints" })

vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua git_status<cr>", { noremap = true })
vim.keymap.set("n", "<leader>f.", function()
	local buf_dir = vim.fn.expand("%:p:h")
	require("fzf-lua").files({ cwd = buf_dir })
end, { noremap = true })
vim.api.nvim_set_keymap(
	"n",
	"<leader>tc",
	'<cmd>lua require("utils.switch-case").switch_case()<CR>',
	{ noremap = true, silent = true, desc = "[T]oggle switch [c]ase" }
)
