-- Shared lazy.nvim-specific helper: loads every top-level *.lua file under a
-- module directory and concatenates their returned plugin-spec arrays into
-- one flat list, for passing directly as lazy.setup()'s `spec`.
--
-- Deliberately not lazy.nvim's own `{ import = modname }`: import also walks
-- a same-named sibling directory alongside a leaf spec file of the same
-- name, which is surprising and once corrupted a spec here (see
-- lua/plugins/theming/, renamed specifically to dodge that collision).
-- Building the file list ourselves is simpler to reason about and to debug.

local M = {}

---@param modname string  e.g. "minimalist.plugins"
---@return LazyPluginSpec[]
function M.load_dir(modname)
	local modpath = modname:gsub("%.", "/")
	local files = vim.api.nvim_get_runtime_file("lua/" .. modpath .. "/*.lua", true)
	table.sort(files)

	local spec = {}
	for _, file in ipairs(files) do
		local name = vim.fn.fnamemodify(file, ":t:r")
		local fullname = modname .. "." .. name

		local ok, mod = pcall(require, fullname)
		if not ok then
			error("Failed to load `" .. fullname .. "`:\n" .. mod)
		elseif type(mod) ~= "table" then
			error("Invalid spec module `" .. fullname .. "`: expected a table of plugin specs, got " .. type(mod))
		end

		vim.list_extend(spec, mod)
	end

	return spec
end

return M
