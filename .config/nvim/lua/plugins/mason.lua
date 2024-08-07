return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
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
