local M = {}

function M.setup()
	require("treesj").setup({
		use_default_keymaps = false,
	})

	vim.keymap.set("n", "<leader>tt", "<cmd>TSJToggle<CR>", { desc = "Toggle split join" })
end

return M
