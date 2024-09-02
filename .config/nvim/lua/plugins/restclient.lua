return {
	{
		"rest-nvim/rest.nvim",
		lazy = false,
		config = function()
			vim.keymap.set("n", "<leader>vrs", "<cmd>Rest env select<cr>", { desc = "Select env for current file" })
			vim.keymap.set("n", "<leader>vrr", "<cmd>Rest run<cr>", { desc = "Run request under the cursor" })
			vim.keymap.set("n", "<leader>vro", "<cmd>Rest open<cr>", { desc = "Open results pane" })
			vim.keymap.set("n", "<leader>vrl", "<cmd>Rest last<cr>", { desc = "Re-run last request" })
		end,
	},
}
