return {
	{
		"rest-nvim/rest.nvim",
		lazy = true,
		keys = {
			{
				"<leader>hs",
				"<cmd>Rest env select<cr>",
				desc = "Select env for current file",
			},
			{
				"<leader>hr",
				"<cmd>Rest run<cr>",
				desc = "Run request under the cursor",
			},
			{
				"<leader>ho",
				"<cmd>Rest open<cr>",
				desc = "Open results pane",
			},
			{
				"<leader>hl",
				"<cmd>Rest last<cr>",
				desc = "Re-run last request",
			},
		},
		-- config = function()
		-- 	vim.keymap.set("n", "<leader>hs", "<cmd>Rest env select<cr>", { desc = "Select env for current file" })
		-- 	vim.keymap.set("n", "<leader>hr", "<cmd>Rest run<cr>", { desc = "Run request under the cursor" })
		-- 	vim.keymap.set("n", "<leader>ho", "<cmd>Rest open<cr>", { desc = "Open results pane" })
		-- 	vim.keymap.set("n", "<leader>hl", "<cmd>Rest last<cr>", { desc = "Re-run last request" })
		-- end,
	},
}
