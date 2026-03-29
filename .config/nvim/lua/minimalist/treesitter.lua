local parsers = require("minimalist.constants").treesitter_parsers

local M = {}

function M.setup_autocmds()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = parsers,
		callback = function()
			-- Highlighting
			vim.treesitter.start()

			-- Folds
			-- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			-- vim.wo[0][0].foldmethod = "expr"

			-- Indent
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})
end

function M.install()
	local alreadyInstalled = require("nvim-treesitter.config").get_installed()
	local parsersToInstall = vim
		.iter(parsers)
		:filter(function(parser)
			return not vim.tbl_contains(alreadyInstalled, parser)
		end)
		:totable()
	require("nvim-treesitter").install(parsersToInstall)
end

return M
