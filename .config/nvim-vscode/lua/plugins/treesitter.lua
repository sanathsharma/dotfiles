return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	cond = function()
		return vim.g.vscode == nil
	end,
	event = "BufEnter",
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
					-- Start selection with space + v (similar to visual mode)
					init_selection = "<Space>v",
					-- Grow selection outward with space + k
					node_incremental = "<Space>k",
					-- Grow selection to scope with space + j
					scope_incremental = "<Space>j",
					-- Shrink selection with space + h
					node_decremental = "<Space>h",
				},
			},
		})
	end,
}
