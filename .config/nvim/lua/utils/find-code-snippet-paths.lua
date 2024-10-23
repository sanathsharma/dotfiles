local function find_code_snippets_paths(snippets_path)
	local files = {}

	-- Check if directory exists
	local stat = vim.loop.fs_stat(snippets_path)
	if not stat then
		-- print(".vscode/snippets folder not found")
		return
	end

	-- Traverse the directory
	local handle = vim.loop.fs_scandir(snippets_path)
	if handle then
		while true do
			local name, typ = vim.loop.fs_scandir_next(handle)
			if not name then
				break
			end
			if typ == "file" and name:match("%.code%-snippets$") then
				table.insert(files, snippets_path .. "/" .. name)
			end
		end
	end

	return files
end

return { find_code_snippets_paths = find_code_snippets_paths }
