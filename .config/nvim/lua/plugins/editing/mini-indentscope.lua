local M = {}

function M.setup()
	require("mini.indentscope").setup({
		draw = {
			delay = 0,
			animation = require("mini.indentscope").gen_animation.none(),
		},
		symbol = "╎",
		mappings = {
			-- Textobjects
			object_scope = "ii",
			object_scope_with_border = "ai",

			-- Motions (jump to respective border line; if not present - body line)
			goto_top = "[i",
			goto_bottom = "]i",
		},
	})
end

return M
