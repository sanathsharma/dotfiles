return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "UIEnter",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"stylua",
					"codelldb",
					"biome",
					"gofumpt",
					"goimports-reviser",
					"golines",
					"mypy", -- Python static type checking
					"debugpy" -- Python debugger
				},
			})
		end,
	},
}
