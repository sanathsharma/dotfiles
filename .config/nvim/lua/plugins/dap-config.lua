local js_based_languages = {
	"typescript",
	"javascript",
	"typescriptreact",
	"javascriptreact",
	"vue",
}

local function pick_url()
	local co = coroutine.running()
	return coroutine.create(function()
		vim.ui.input({
			prompt = "Enter URL: ",
			default = "http://localhost:3000",
		}, function(url)
			if url == nil or url == "" then
				return
			else
				coroutine.resume(co, url)
			end
		end)
	end)
end

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"leoluz/nvim-dap-go",
			{
				"microsoft/vscode-js-debug",
				-- After install, build it and rename the dist directory to out
				build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
				version = "*",
			},
			{
				"mxsdev/nvim-dap-vscode-js",
				config = function()
					require("dap-vscode-js").setup({
						-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
						debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
						adapters = { "pwa-node" }, -- which adapters to register in nvim-dap
					})
				end,
			},
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			require("dap-go").setup()
			dapui.setup()

			--#region js
			dap.adapters["chrome"] = {
				type = "executable",
				command = "chrome-debug-adapter",
				args = { "--remote-debugging-port=9222" },
			}

			for _, language in ipairs(js_based_languages) do
				dap.configurations[language] = {
					-- Debug single nodejs files
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = vim.fn.getcwd(),
						protocol = "inspector",
						restart = true,
						stopOnEntry = false,
						sourceMaps = true,
					},
					-- Debug nodejs processes (make sure to add --inspect when you run the process)
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						cwd = vim.fn.getcwd(),
						protocol = "inspector",
						sourceMaps = true,
						restart = true,
						stopOnEntry = false,
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach to process",
						processId = require("dap.utils").pick_process,
						cwd = vim.fn.getcwd(),
						protocol = "inspector",
						sourceMaps = true,
						restart = true,
						stopOnEntry = false,
					},
					-- Debug web applications (client side)
					{
						type = "chrome",
						request = "launch",
						name = "Launch & Debug Chrome",
						url = pick_url,
						webRoot = vim.fn.getcwd(),
						protocol = "inspector",
						sourceMaps = true,
						userDataDir = false,
					},
					{
						type = "chrome",
						request = "attach",
						name = "Attach to chrome process",
						program = "${file}",
						processId = require("dap.utils").pick_process,
						cwd = vim.fn.getcwd(),
						sourceMaps = true,
						protocol = "inspector",
						port = 9222,
						webRoot = "${workspaceFolder}",
					},
					-- Divider for the launch.json derived configs
					{
						name = "----- ↓ launch.json configs ↓ -----",
						type = "",
						request = "launch",
					},
				}
			end
			--#endregion

			--#region event listeners
			dap.listeners.before.attach.dapui_config = function()
				dapui.open({ reset = true })
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open({ reset = true })
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
			--#endregion

			--#region keymaps
			vim.keymap.set(
				"n",
				"<leader>dt",
				"<cmd>lua require('dapui').toggle()<CR>",
				{ noremap = true, desc = "[T]oggle DAP UI" }
			)
			vim.keymap.set(
				"n",
				"<leader>db",
				"<cmd>DapToggleBreakpoint<CR>",
				{ noremap = true, desc = "[T]oggle DAP breakpoint" }
			)
			vim.keymap.set("n", "<leader>dx", "<cmd>DapTerminate<CR>", { noremap = true, desc = "DAP Terminate" })
			vim.keymap.set("n", "<leader>dc", function()
				if vim.fn.filereadable(".vscode/launch.json") then
					local dap_vscode = require("dap.ext.vscode")
					dap_vscode.load_launchjs(nil, {
						["pwa-node"] = js_based_languages,
						["node"] = js_based_languages,
						["chrome"] = js_based_languages,
						["pwa-chrome"] = js_based_languages,
						["lldb"] = { "rust" },
					})
				end
				require("dap").continue()
			end, { noremap = true, desc = "DAP continue" })
			vim.keymap.set(
				"n",
				"<leader>dr",
				"<cmd>lua require('dapui').open({ reset = true })<CR>",
				{ noremap = true, desc = "[R]eset DAP UI" }
			)
			vim.keymap.set("n", "<leader>dus", function()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.open()
			end, { noremap = true, desc = "Open debugging sidebar" })
			--#endregion
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
	},
	{
		"nvim-telescope/telescope-dap.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope").load_extension("dap")
		end,
	},
}
