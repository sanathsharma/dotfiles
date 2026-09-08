return {
	{
		"igorlfs/nvim-dap-view",
		lazy = true,
		dependencies = {
			{
				"mfussenegger/nvim-dap",
				config = function()
					require("plugins.debugging.dap").setup_dap()
				end,
			},
		},
		config = function()
			require("plugins.debugging.dap").setup_dap_view()
		end,
	},
}
