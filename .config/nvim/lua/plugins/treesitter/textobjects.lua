local M = {}

function M.init()
	-- Disable entire built-in ftplugin mappings to avoid conflicts.
	-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
	vim.g.no_plugin_maps = true
end

local function setup_keymaps()
	local select_textobject = require("nvim-treesitter-textobjects.select").select_textobject
	-- local swap = require("nvim-treesitter-textobjects.swap")

	local function select(query_string, query_group)
		return function()
			select_textobject(query_string, query_group or "textobjects")
		end
	end

	-- You can use the capture groups defined in `textobjects.scm`
	-- List of capture groups: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/main/BUILTIN_TEXTOBJECTS.md
	local textobjects = {
		{ "if", "@function.inner", "Select inside function" },
		{ "af", "@function.outer", "Select around function" },
		{ "ac", "@comment.outer", "Select around comment" },
		{ "ic", "@comment.inner", "Select inside comment" },
		{ "al", "@loop.outer", "Select around loop" },
		{ "il", "@loop.inner", "Select inside loop" },
		{ "aj", "@conditional.outer", "Select around conditional" },
		{ "ij", "@conditional.inner", "Select inside conditional" },
		{ "aa", "@parameter.outer", "Select around parameter" },
		{ "ia", "@parameter.inner", "Select inside parameter" },
		{ "ab", "@block.outer", "Select around block" },
		{ "ib", "@block.inner", "Select inside block" },
		{ "aq", "@custom_string.outer", "Select around quote" },
		{ "iq", "@custom_string.inner", "Select inside quote" },
		{ "ao", "@custom_bracket.outer", "Select around bracket" },
		{ "io", "@custom_bracket.inner", "Select inside bracket" },
	}

	for _, t in ipairs(textobjects) do
		vim.keymap.set({ "x", "o" }, t[1], select(t[2]), { desc = t[3] })
	end

	-- You can also use captures from other query groups like `locals.scm`
	vim.keymap.set({ "x", "o" }, "as", select("@local.scope", "locals"), { desc = "Select around local scope" })

	-- Swap
	-- vim.keymap.set("n", "<leader>a", function() swap.swap_next("@parameter.inner") end)
	-- vim.keymap.set("n", "<leader>A", function() swap.swap_previous("@parameter.outer") end)
end

function M.setup()
	require("nvim-treesitter-textobjects").setup({
		select = {
			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,
			-- You can choose the select mode (default is charwise 'v')
			--
			-- Can also be a function which gets passed a table with the keys
			-- * query_string: eg '@function.inner'
			-- * method: eg 'v' or 'o'
			-- and should return the mode ('v', 'V', or '<c-v>') or a table
			-- mapping query_strings to modes.
			selection_modes = {
				-- ["@parameter.outer"] = "v", -- charwise
				-- ["@function.outer"] = "V", -- linewise
				-- ['@class.outer'] = '<c-v>', -- blockwise
			},
			-- If you set this to `true` (default is `false`) then any textobject is
			-- extended to include preceding or succeeding whitespace. Succeeding
			-- whitespace has priority in order to act similarly to eg the built-in
			-- `ap`.
			--
			-- Can also be a function which gets passed a table with the keys
			-- * query_string: eg '@function.inner'
			-- * selection_mode: eg 'v'
			-- and should return true of false
			include_surrounding_whitespace = false,
		},
		move = {
			-- whether to set jumps in the jumplist
			set_jumps = true,
		},
	})

	setup_keymaps()
end

return M
