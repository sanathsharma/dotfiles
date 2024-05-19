return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.biome,
				null_ls.builtins.formatting.gofumpt,
				null_ls.builtins.formatting.goimports_reviser,
				null_ls.builtins.formatting.golines,
				null_ls.builtins.code_actions.gitsigns,
			},
		})

		vim.keymap.set("n", "<leader>af", vim.lsp.buf.format, { desc = "[F]ormat file" })
		vim.keymap.set(
			"v",
			"<leader>af",
			vim.lsp.buf.format,
			{ desc = "Format selected [r]ange", noremap = true }
		)
	end,
}
