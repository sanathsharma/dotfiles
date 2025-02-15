return {
	"nvimtools/none-ls.nvim",
	event = "BufEnter",
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- Lua
				null_ls.builtins.formatting.stylua,
				-- JS, CSS
				null_ls.builtins.formatting.biome,
				-- Go
				null_ls.builtins.formatting.gofumpt,
				null_ls.builtins.formatting.goimports_reviser,
				null_ls.builtins.formatting.golines,
				-- Git
				null_ls.builtins.code_actions.gitsigns,
				-- Python
				null_ls.builtins.diagnostics.mypy,
			},
		})
	end,
}
