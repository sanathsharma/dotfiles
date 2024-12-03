return {
	{
		"kevinhwang91/nvim-ufo",
		lazy = true,
		keys = {
			{ "zR", mode = "n", "<cmd>lua require(\"ufo\").openAllFolds<cr>",               desc = "Open all folds" },
			{ "zM", mode = "n", "<cmd>lua require(\"ufo\").closeAllFolds<cr>",              desc = "Close all folds" },
			{ "zr", mode = "n", "<cmd>lua require(\"ufo\").openFoldsExceptKinds<cr>",       desc = "Open folds except kinds" },
			{ "zm", mode = "n", "<cmd>lua require(\"ufo\").closeFoldsWith<cr>",             desc = "Close folds with" }, -- closeAllFolds == closeFoldsWith(0)
			{ "zK", mode = "n", "<cmd>lua require(\"ufo\").peekFoldedLinesUnderCursor<cr>", desc = "Peef fold" },
		},
		dependencies = {
			"kevinhwang91/promise-async",
		},
		config = function()
			require("ufo").setup({
				provider_selector = function()
					return { "lsp", "indent" }
				end,
			})

			-- vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
			-- vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
			-- vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
			-- vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds with" }) -- closeAllFolds == closeFoldsWith(0)
			-- vim.keymap.set("n", "zK", require("ufo").peekFoldedLinesUnderCursor, { desc = "Peef fold" })
		end,
	},
}
