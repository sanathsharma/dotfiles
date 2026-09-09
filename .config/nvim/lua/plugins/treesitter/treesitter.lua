local M = {}

local parsers = {
	"bash",
	"c",
	"fish",
	"javascript",
	"json",
	"jsx",
	"lua",
	"markdown",
	"rust",
	"svelte",
	"toml",
	"tsx",
	"typescript",
	"yaml",
	"zsh",
}

function M.init()
	vim.opt.foldcolumn = "1" -- Show fold column, only 1
	vim.opt.foldlevel = 99
	vim.opt.foldlevelstart = 99
	vim.opt.foldenable = true
	vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:"
end

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = parsers,
		callback = function()
			-- Highlighting
			vim.treesitter.start()

			-- Folds
			vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.wo[0][0].foldmethod = "expr"

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
