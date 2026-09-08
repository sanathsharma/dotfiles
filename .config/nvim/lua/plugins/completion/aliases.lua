local M = {}

function M.get()
	local aliases = {
		Themes = "FzfLua colorschemes",
		Livegrep = "FzfLua live_grep",
		Marks = "FzfLua marks",
		Tblame = "Gitsigns toggle_current_line_blame",
		Tdbui = "tab DBUI",
		Rhunk = "Gitsigns reset_hunk",
		Rbuffer = "Gitsigns reset_buffer",
		Shunk = "Gitsigns stage_hunk",
		Sbuffer = "Gitsigns stage_buffer",
		LoadSession = "source Session.vim",
	}
	return aliases
end

return M
