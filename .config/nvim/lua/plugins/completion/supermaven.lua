local M = {}

function M.setup()
	require("supermaven-nvim").setup({
		keymaps = {
			accept_suggestion = "<M-y>",
			clear_suggestion = "<M-c>",
			accept_word = "<M-w>",
		},
	})

	vim.keymap.set("n", "<leader>ts", "<cmd>SupermavenToggle<cr>", { desc = "Toggle supermaven code completions" })
end

return M
