return {
	{
		"numToStr/Comment.nvim",
		lazy = true,
		keys = {
			{ "gcc", mode = "n", desc = "Comment toggle current line" },
			{ "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
			{ "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
			{ "gbc", mode = "n", desc = "Comment toggle current block" },
			{ "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
			{ "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
			{
				"<leader>/",
				function()
					require("Comment.api").toggle.linewise.current()
				end,
				desc = "Toggle comment",
			},
			{
				"<leader>/",
				"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
				mode = "v",
				desc = "Toggle comment",
			},
		},
		config = function(_, opts)
			require("Comment").setup(opts)
		end,
	},
	{
		"folke/todo-comments.nvim",
		ft = require("utils.ft-known"),
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}
