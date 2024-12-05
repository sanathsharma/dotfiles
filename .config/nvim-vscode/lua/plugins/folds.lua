return {
	{
		"kevinhwang91/nvim-ufo",
		lazy = true,
		cond = function ()
			return vim.g.vscode == nil
		end,
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
		end,
	},
}
