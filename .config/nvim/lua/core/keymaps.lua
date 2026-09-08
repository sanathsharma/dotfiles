-- Keymaps with zero plugin coupling. Anything that depends on a plugin lives
-- in that plugin's own module under lua/plugins/<category>/ instead.

local M = {}

function M.setup()
	vim.keymap.set("n", "<C-s>", "<cmd>wa<cr>", { desc = "Save all files" })

	vim.keymap.set("n", "]t", "<cmd>tabn<cr>", { desc = "Next tab" })
	vim.keymap.set("n", "[t", "<cmd>tabp<cr>", { desc = "Previous tab" })

	-- Helpers
	vim.keymap.set("n", "<leader>y", '"+yy', { desc = "Yank current line into system clipboard" })
	vim.keymap.set("n", "<leader>p", '"_dP', { desc = "Paste without yanking" })
	vim.keymap.set({ "n", "v" }, "<leader>X", '"_d', { desc = "Delete without yanking" })

	-- Remaps
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
	vim.keymap.set("n", "n", "nzzzv")
	vim.keymap.set("n", "N", "Nzzzv")
	vim.keymap.set("n", "<C-d>", "<C-d>zz")
	vim.keymap.set("n", "<C-u>", "<C-u>zz")
	vim.keymap.set("n", "U", "<C-r>")

	vim.keymap.set("n", "<A-j>", "<cmd>move .+1==<cr>", { noremap = true, silent = true })
	vim.keymap.set("n", "<A-k>", "<cmd>move .-2==<cr>", { noremap = true, silent = true })

	-- Goto
	vim.keymap.set({ "n", "v" }, "ge", "G", { desc = "Goto last line" })
	vim.keymap.set({ "n", "v" }, "gh", "0", { desc = "Goto line start" })
	vim.keymap.set({ "n", "v" }, "gl", "$", { desc = "Goto line end" })
	vim.keymap.set({ "n", "v" }, "gs", "^", { desc = "Goto first non-blank in line" })
	vim.keymap.set({ "n", "v" }, "gk", "g_", { desc = "Goto last non-blank in line" })

	-- Visual mode remaps
	vim.keymap.set("v", ">", ">gv", { noremap = true, desc = "Keep selection after right indent" })
	vim.keymap.set("v", "<", "<gv", { noremap = true, desc = "Keep selection after left indent" })

	vim.keymap.set({ "x", "v" }, "<leader>y", '"+y', { noremap = true, desc = "Yank selection into system clipboard" })
	vim.keymap.set({ "x", "v" }, "<A-j>", ":move '>+1<CR>gv=gv", { noremap = true, silent = true })
	vim.keymap.set({ "x", "v" }, "<A-k>", ":move '<-2<CR>gv=gv", { noremap = true, silent = true })
	vim.keymap.set({ "x", "v" }, "<leader>s", ":<C-u>'<,'>sort<CR>", { desc = "Sort selections" })
end

return M
