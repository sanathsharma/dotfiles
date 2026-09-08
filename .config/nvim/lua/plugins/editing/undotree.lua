local M = {}

function M.init()
	vim.opt.undodir = vim.fn.expand("~") .. "/.undodir"
	vim.opt.undofile = true
end

function M.setup()
	vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle undotree" })
end

return M
