return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cond = function()
		return vim.g.vscode == nil
	end,
	event = "BufEnter",
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- Spell check
				-- Inserts intermediate text suggestions, which is annoying. See https://github.com/hrsh7th/cmp-nvim-lsp/issues/20
				-- null_ls.builtins.completion.spell,
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
