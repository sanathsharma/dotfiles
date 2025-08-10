local filterTable = function(sourceTable, filterTable)
	local result = {}
	local filterSet = {}

	-- Create a lookup set from the filter table for O(1) lookups
	for _, value in ipairs(filterTable) do
		filterSet[value] = true
	end

	-- Add elements from sourceTable to result only if they're not in filterSet
	for _, value in ipairs(sourceTable) do
		if not filterSet[value] then
			table.insert(result, value)
		end
	end

	return result
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
---@return string[] | nil
local get_closest_formatter = function(_formatters)
	---@type string
	local current_buffer_path = vim.api.nvim_buf_get_name(0)

	local available_formatters = require("conform").list_formatters(0)
	local keys_to_include = {}
	for _, value in ipairs(available_formatters) do
		table.insert(keys_to_include, value.name)
	end
	---@type table<string, string[]>
	_formatters = filterTable(_formatters, keys_to_include)

	---@type table<string, number>
	local distance = {}

	for formatter_name, formatter_configs in pairs(_formatters) do
		local formatter_config_path = nil

		for _, v in ipairs(formatter_configs) do
			formatter_config_path = vim.fs.find(v, {
				path = current_buffer_path,
				stop = require("lspconfig.util").root_pattern(".git")(v),
				upward = true,
			})
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

	return { shortest_path_key }
end

return {
	filterTable = filterTable,
	get_closest_formatter = get_closest_formatter,
}
