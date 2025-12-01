local utils = {}
function utils.exec(client, command_params_cb)
	return function()
		client:exec_cmd(command_params_cb())
	end
end

local ts_commands = {}
ts_commands.organize_imports = function()
	return {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
end

local user_commands = {
	ts_ls = {
		{ "OrganizeImports", ts_commands.organize_imports, { desc = "Organize Imports" } },
	},
}

local M = {}
M.setup = function(client)
	if not user_commands[client.name] then
		return
	end

	for _, command in ipairs(user_commands[client.name]) do
		vim.api.nvim_create_user_command(command[1], utils.exec(client, command[2]), command[3])
	end
end

return M
