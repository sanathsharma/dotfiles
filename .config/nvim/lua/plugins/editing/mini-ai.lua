local M = {}

function M.setup()
	require("mini.ai").setup({
		custom_textobjects = {
			-- Owned by nvim-treesitter-textobjects instead (ia/aa, ib/ab, if/af)
			a = false,
			b = false,
			f = false,
			-- Re-expose the default "any bracket" alias under `o` (the old io/ao letter)
			-- since `b` is taken by treesitter's block, and `n`/`l` are reserved by
			-- mini.ai's an/in/al/il "next"/"last" mappings
			o = { { "%b()", "%b[]", "%b{}" }, "^.().*().$" },
		},
		mappings = {
			-- Main textobject prefixes
			around = "a",
			inside = "i",

			-- Next/last variants
			-- NOTE: This (deliberately) overrides Neovim>=0.12 built-in incremental
			-- selection mappings. See `:h MiniAi-default-an-in` for more details.
			around_next = "an",
			inside_next = "in",
			around_last = "al",
			inside_last = "il",

			-- Move cursor to corresponding edge of `a` textobject
			goto_left = "g[",
			goto_right = "g]",
		},
	})
end

return M
