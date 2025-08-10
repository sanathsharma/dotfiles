local M = {}

local function find_git_root()
	local current_dir = vim.fn.expand("%:p:h")
	if current_dir == "" then
		current_dir = vim.fn.getcwd()
	end

	local git_root =
		vim.fn.systemlist("git -C " .. vim.fn.shellescape(current_dir) .. " rev-parse --show-toplevel 2>/dev/null")[1]
	if git_root and git_root ~= "" then
		return git_root
	end

	local git_dir =
		vim.fn.systemlist("git -C " .. vim.fn.shellescape(current_dir) .. " rev-parse --git-dir 2>/dev/null")[1]
	if git_dir and git_dir ~= "" then
		if git_dir:match("%.git$") then
			return vim.fn.fnamemodify(git_dir, ":h")
		else
			return git_dir
		end
	end

	return nil
end

function M.load_project_config()
	local git_root = find_git_root()
	if not git_root then
		return
	end

	local project_init = git_root .. "/config.lua"
	if vim.fn.filereadable(project_init) == 1 then
		local ok, err = pcall(dofile, project_init)
		if not ok then
			vim.notify("Error loading project config: " .. err, vim.log.levels.ERROR)
		end
	end
end

return M

