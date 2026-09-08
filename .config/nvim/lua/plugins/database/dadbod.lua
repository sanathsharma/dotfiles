local M = {}

function M.init()
	vim.g.db_ui_use_nerd_fonts = 1
end

function M.is_temp_dir()
	local path_base = "/var/folders"
	if string.sub(vim.fn.expand("%"), 1, string.len(path_base)) == path_base then
		return true
	end
	return false
end

return M
