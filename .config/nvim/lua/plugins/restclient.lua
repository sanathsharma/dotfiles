return {
	{
		"rest-nvim/rest.nvim",
		lazy = false,
		config = function()
			vim.keymap.set("n", "<leader>hs", "<cmd>Rest env select<cr>", { desc = "Select env for current file" })
			vim.keymap.set("n", "<leader>hr", "<cmd>Rest run<cr>", { desc = "Run request under the cursor" })
			vim.keymap.set("n", "<leader>ho", "<cmd>Rest open<cr>", { desc = "Open results pane" })
			vim.keymap.set("n", "<leader>hl", "<cmd>Rest last<cr>", { desc = "Re-run last request" })
		end,
	},
}
