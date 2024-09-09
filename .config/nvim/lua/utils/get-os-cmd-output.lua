local Job = require("plenary.job")

local function get_os_command_output(cmd, cwd)
	if type(cmd) ~= "table" then
		return {}
	end
	local command = table.remove(cmd, 1)
	local stderr = {}
	local stdout, ret = Job:new({
		command = command,
		args = cmd,
		cwd = cwd,
		on_stderr = function(_, data)
			table.insert(stderr, data)
		end,
	}):sync()
	return stdout, ret, stderr
end

return { get_os_command_output = get_os_command_output }
