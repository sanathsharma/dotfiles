return {
	{
		"ibhagwan/fzf-lua",
		config = function()
			require("plugins.navigation.fzf-lua").setup()
		end,
	},
	{
		"mikavilpas/yazi.nvim",
		version = "*", -- use the latest stable version
		event = "VeryLazy",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
		},
		-- 👇 if you use `open_for_directories=true`, this is recommended
		init = function()
			require("plugins.navigation.yazi").init()
		end,
		config = function()
			require("plugins.navigation.yazi").setup()
		end,
	},
	{
		"cbochs/grapple.nvim",
		config = function()
			require("plugins.navigation.grapple").setup()
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		init = function()
			require("plugins.navigation.tmux-navigator").setup_keymaps()
		end,
	},
}
