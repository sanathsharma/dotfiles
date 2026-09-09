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

return M
