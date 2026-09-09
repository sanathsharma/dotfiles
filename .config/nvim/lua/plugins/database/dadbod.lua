-- Extracts the scheme (postgres, mysql, redis, etc.) from a DB URL
local function get_scheme(url)
	return url:match("^(%a+)://") or "db"
end

-- Counts how many existing entries already use this base name
-- (matches exact name or name+number, e.g. "postgres", "postgres2")
local function count_matching(dbs, base_name)
	local count = 0
	for _, entry in ipairs(dbs) do
		if entry.name == base_name or entry.name:match("^" .. base_name .. "%d+$") then
			count = count + 1
		end
	end
	return count
end

-- Builds a unique name for a new entry, disambiguating if needed
local function make_unique_name(dbs, base_name)
	local count = count_matching(dbs, base_name)
	if count > 0 then
		return base_name .. (count + 1)
	end
	return base_name
end

-- Adds a single url to the dbs list, returning the updated list
local function add_db(dbs, url)
	local name = get_scheme(url)
	name = make_unique_name(dbs, name)
	table.insert(dbs, { name = name, url = url })
	return dbs
end

-- Loads dadbod/dadbod-ui and opens DBUI
local function open_dbui()
	require("lazy").load({ plugins = { "vim-dadbod", "vim-dadbod-ui" } })
	vim.cmd("DBUI")
end

local M = {}

function M.init()
	vim.g.db_ui_use_nerd_fonts = 1

	-- Used by the dbui fish shell function. See .config/fish/config.fish
	vim.api.nvim_create_user_command("DBConnect", function(opts)
		local dbs = vim.g.dbs or {}

		for _, url in ipairs(opts.fargs) do
			dbs = add_db(dbs, url)
		end

		vim.g.dbs = dbs
		open_dbui()
	end, { nargs = "+" })
end

function M.is_temp_dir()
	local path_base = "/var/folders"
	if string.sub(vim.fn.expand("%"), 1, string.len(path_base)) == path_base then
		return true
	end
	return false
end

return M
