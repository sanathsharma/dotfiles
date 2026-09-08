return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("plugins.git.gitsigns").setup()
		end,
	},
	{ "sindrets/diffview.nvim", lazy = true },
	{
		"NeogitOrg/neogit",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"ibhagwan/fzf-lua",
		},
		cmd = "Neogit",
		config = function()
			require("plugins.git.neogit").setup()
		end,
	},
}
