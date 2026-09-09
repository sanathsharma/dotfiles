-- Clustered debugging domain module: nvim-dap + nvim-dap-view.

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
local function setup_js_debug_adapter()
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
					name = "Attach by process and port",
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
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach by port",
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

local function setup_dap_keymaps()
	vim.keymap.set("n", "<leader>,c", "<cmd>DapContinue<cr>", { desc = "Start/Continue" })
	vim.keymap.set("n", "<leader>,n", "<cmd>DapStepOver<cr>", { desc = "Step over" })
	vim.keymap.set("n", "<leader>,i", "<cmd>DapStepInto<cr>", { desc = "Step into" })
	vim.keymap.set("n", "<leader>,o", "<cmd>DapStepOut<cr>", { desc = "Step out" })
	vim.keymap.set("n", "<leader>,x", "<cmd>DapTerminate<cr>", { desc = "Terminate debug session" })
	vim.keymap.set("n", "<leader>,q", "<cmd>DapDisconnect<cr>", { desc = "Disconnect debug session" })
	vim.keymap.set("n", "<leader>,b", "<cmd>DapToggleBreakpoint<cr>", { desc = "Toggle breakpoint" })
	vim.keymap.set("n", "<leader>,r", "<cmd>DapRestartFrame<cr>", { desc = "Restart frame" })
	vim.keymap.set("n", "<leader>,e", function()
		require("dap").set_exception_breakpoints()
	end, { desc = "Set exception breakpoints" })
	vim.keymap.set("n", "<leader>,k", function()
		require("dap.ui.widgets").hover()
	end, { desc = "Expression under cursor" })
end

local function setup_dapview_keymaps()
	vim.keymap.set("n", "<leader>,v", "<cmd>DapViewToggle<cr>", { desc = "Toggle debug view" })
end

function M.setup_dap()
	setup_js_debug_adapter()
	setup_dap_keymaps()
end

function M.setup_dap_view()
	require("dap-view").setup({
		winbar = {
			sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "sessions", "console" },
			controls = { enabled = true },
		},
		switchbuf = "useopen,usetab,uselast",
	})
	setup_dapview_keymaps()
end

return M
