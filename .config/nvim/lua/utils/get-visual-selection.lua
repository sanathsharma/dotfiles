local function get_visual_selection()
	local _, ls, cs = table.unpack(vim.fn.getpos("'<"))
	local _, le, ce = table.unpack(vim.fn.getpos("'>"))
	return { start = { line = ls, col = cs }, ["end"] = { line = le, col = ce } }
end

return { get_visual_selection = get_visual_selection }
