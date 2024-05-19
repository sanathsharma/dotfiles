return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		config = function()
			require("ufo").setup({
				provider_selector = function()
					return { "lsp", "indent" }
				end,
			})

			vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
			vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
			vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds with" }) -- closeAllFolds == closeFoldsWith(0)
			vim.keymap.set("n", "zK", require("ufo").peekFoldedLinesUnderCursor, { desc = "Peef fold" })
		end,
	},
}
