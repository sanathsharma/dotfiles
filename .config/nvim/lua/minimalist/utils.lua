local M = {}

---@param originalTable table<string, string[]>
---@param keysToInclude string[]
function M.filterTable(originalTable, keysToInclude)
	local resultTable = {}

	for _, key in ipairs(keysToInclude) do
		local value = originalTable[key]
		if value then
			resultTable[key] = value
		end
	end

	return resultTable
end

---@param path_one string
---@param current_buffer string
local get_distance_to = function(path_one, current_buffer)
	if path_one == nil then
		return math.huge
	end

	local common_prefix = ""
	local current_remaining = ""
	local other_remaining = ""

	for i = 1, math.min(#current_buffer, #path_one) do
		if current_buffer:sub(i, i) == path_one:sub(i, i) then
			common_prefix = common_prefix .. current_buffer:sub(i, i)
		else
			current_remaining = current_buffer:sub(i)
			other_remaining = path_one:sub(i)
			break
		end
	end

	-- Calculate the distance by counting directory separators
	local distance = 0

	for _ in current_remaining:gmatch("/") do
		distance = distance + 1
	end

	for _ in other_remaining:gmatch("/") do
		distance = distance + 1
	end

	return distance
end

-- Inspired by https://github.com/asilvadesigns/config/blob/87adf2bdc22c4ca89d1b06b013949d817b405e77/nvim/lua/plugins/conform.lua#L63
---@param _formatters table<string, string[]>
---@return string | nil
function M.get_closest_formatter(_formatters)
	---@type string
	local current_buffer_path = vim.api.nvim_buf_get_name(0)

	local available_formatters = require("conform").list_formatters(0)
	local keys_to_include = {}
	for _, value in ipairs(available_formatters) do
		table.insert(keys_to_include, value.name)
	end
	---@type table<string, string[]>
	_formatters = M.filterTable(_formatters, keys_to_include)

	---@type table<string, number>
	local distance = {}

	for formatter_name, formatter_configs in pairs(_formatters) do
		local formatter_config_path = nil

		for _, v in ipairs(formatter_configs) do
			local stop_dir = require("lspconfig.util").root_pattern(".git")(v)
			formatter_config_path = vim.fs.find(v, {
				path = current_buffer_path,
				stop = stop_dir,
				upward = true,
				type = "file",
			})
			if not formatter_config_path or #formatter_config_path == 0 then
				if stop_dir then
					local file_path = vim.fs.joinpath(stop_dir, v)
					if vim.fn.filereadable(file_path) == 1 then
						formatter_config_path = { file_path }
					end
				end
			end

			if formatter_config_path[1] ~= nil then
				break
			end
		end

		if formatter_config_path[1] ~= nil then
			distance[formatter_name] = get_distance_to(formatter_config_path[1], current_buffer_path)
		end
	end

	---@type string|nil
	local shortest_path_key = nil
	---@type number
	local shortest_path_val = math.huge

	for formatter_name, formatter_distance in pairs(distance) do
		if formatter_distance < shortest_path_val then
			shortest_path_key = formatter_name
			shortest_path_val = formatter_distance
		end
	end

	if shortest_path_key == nil then
		return nil
	end

	return shortest_path_key
end

function M.is_dadbod_temp_dir()
	local path_base = "/var/folders"
	if string.sub(vim.fn.expand("%"), 1, string.len(path_base)) == path_base then
		return true
	end
	return false
end

return M
