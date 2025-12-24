local M = {}

-- Function to prompt user for debugger port with validation
-- @param default_port string: The default port to prefill in the input prompt
-- @param prompt_message string: Optional custom prompt message
-- @return number: The validated port number
local function get_debugger_port(default_port, prompt_message)
	prompt_message = prompt_message or "Debug adapter port: "
	local user_port = vim.fn.input(prompt_message, tostring(default_port))

	-- Validate port input - ensure it's numeric and within valid range
	if user_port == "" or not user_port:match("^%d+$") then
		vim.notify("Invalid input. Using default port " .. default_port, vim.log.levels.WARN)
		return tonumber(default_port)
	end

	local port_num = tonumber(user_port)
	if port_num < 1024 or port_num > 65535 then
		vim.notify("Invalid port range (1024-65535). Using default port " .. default_port, vim.log.levels.WARN)
		return tonumber(default_port)
	end

	return port_num
end

-- Reference: https://www.lazyvim.org/extras/lang/typescript#nvim-dap-optional
local setup_js_debug_adapter = function()
	local dap = require("dap")

	for _, adapterType in ipairs({ "node", "chrome", "msedge" }) do
		local pwaType = "pwa-" .. adapterType

		if not dap.adapters[pwaType] then
			dap.adapters[pwaType] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = { vim.fn.expand("~") .. "/dap-adapters/js-debug/src/dapDebugServer.js", "${port}" },
				},
			}
		end

		-- Define adapters without the "pwa-" prefix for VSCode compatibility
		if not dap.adapters[adapterType] then
			dap.adapters[adapterType] = function(cb, config)
				local nativeAdapter = dap.adapters[pwaType]

				config.type = pwaType

				if type(nativeAdapter) == "function" then
					nativeAdapter(cb, config)
				else
					cb(nativeAdapter)
				end
			end
		end
	end

	local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

	local vscode = require("dap.ext.vscode")
	vscode.type_to_filetypes["node"] = js_filetypes
	vscode.type_to_filetypes["pwa-node"] = js_filetypes

	for _, language in ipairs(js_filetypes) do
		if not dap.configurations[language] then
			local runtimeExecutable = nil
			if language:find("typescript") then
				runtimeExecutable = vim.fn.executable("tsx") == 1 and "tsx" or "ts-node"
			end
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					runtimeExecutable = runtimeExecutable,
					skipFiles = {
						"<node_internals>/**",
						"node_modules/**",
					},
					resolveSourceMapLocations = {
						"${workspaceFolder}/**",
						"!**/node_modules/**",
					},
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					runtimeExecutable = runtimeExecutable,
					port = function()
						return get_debugger_port(9229, "Attach to debug port: ")
					end,
					skipFiles = {
						"<node_internals>/**",
						"node_modules/**",
					},
					resolveSourceMapLocations = {
						"${workspaceFolder}/**",
						"!**/node_modules/**",
					},
					restart = true,
				},
			}
		end
	end
end

M.setup = function()
	setup_js_debug_adapter()
end

return M
