local M = {}

function M.setup()
	vim.keymap.set("n", "<leader>xg", "<cmd>Neogit<cr>", { desc = "Show Neogit UI" })
end

return M
