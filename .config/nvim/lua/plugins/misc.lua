return {
	{ "tpope/vim-unimpaired", event = "VeryLazy" },
	{ "tpope/vim-surround", event = "VeryLazy" },
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.keymap.set("n", "<leader>xx", function()
				require("trouble").toggle()
			end, { desc = "Toggle Trouble" })
			vim.keymap.set("n", "<leader>xw", function()
				require("trouble").toggle("workspace_diagnostics")
			end, { desc = "Toggle workspace_diagnostics" })
			vim.keymap.set("n", "<leader>xd", function()
				require("trouble").toggle("document_diagnostics")
			end, { desc = "Toggle document_diagnostics" })
			vim.keymap.set("n", "<leader>xq", function()
				require("trouble").toggle("quickfix")
			end, { desc = "Toggle quickfix" })
			vim.keymap.set("n", "<leader>xl", function()
				require("trouble").toggle("loclist")
			end, { desc = "Toggle location list" })
			vim.keymap.set("n", "gR", function()
				require("trouble").toggle("lsp_references")
			end, { desc = "Toggle lsp_references" })
		end,
	},
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "VeryLazy",
		config = function()
			require("treesj").setup()
			vim.keymap.set("n", "<leader>tt", "<cmd>TSJToggle<CR>", { desc = "Toggle split join" })
		end,
	},
}
