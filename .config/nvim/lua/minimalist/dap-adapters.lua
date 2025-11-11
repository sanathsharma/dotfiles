local M = {}

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
					skipFiles = {
						"<node_internals>/**",
						"node_modules/**",
					},
					resolveSourceMapLocations = {
						"${workspaceFolder}/**",
						"!**/node_modules/**",
					},
				},
			}
		end
	end
end

M.setup = function()
	setup_js_debug_adapter()
end

return M
