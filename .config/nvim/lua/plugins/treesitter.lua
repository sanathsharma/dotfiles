return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	ft = require("utils.ft-known"),
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			rainbow = {
				enable = true,
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = nil, -- Do not enable for files with more than n lines, int
			},
			autotag = {
				enable = true,
				filetypes = {
					"html",
					"javascript",
					"typescript",
					"markdown",
				},
			},
			-- INFO: use `o` to jump between either ends of selection for inc/dec selection w/ j,k
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>",
					scope_incremental = "<CR>",
					node_incremental = "<CR>",
					node_decremental = "<TAB>",
				},
			},
		})
	end,
}
