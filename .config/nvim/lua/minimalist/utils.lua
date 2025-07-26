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

return {
	filterTable = filterTable,
}
