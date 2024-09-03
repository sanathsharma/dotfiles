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
			local dap = require("dap")

			require("dap-go").setup()

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
						name = "----- ↑ launch.json configs ↑ -----",
						type = "",
						request = "launch",
					},
				}
			end
			--#endregion

			--#region keymaps
			local function opts(desc)
				return { noremap = true, silent = true, desc = desc }
			end
			vim.keymap.set("n", "<F5>", function()
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
			end, opts("Start/Continue Debugging"))
			vim.keymap.set("n", "<F10>", "<cmd>lua require\"dap\".step_over()<CR>", opts("Step Over"))
			vim.keymap.set("n", "<F11>", "<cmd>lua require\"dap\".step_into()<CR>", opts("Step Into"))
			vim.keymap.set("n", "<F12>", "<cmd>lua require\"dap\".step_out()<CR>", opts("Step Out"))
			vim.keymap.set("n", "<F6>", "<cmd>lua require\"dap\".pause()<CR>", opts("Pause"))
			vim.keymap.set("n", "<F7>", "<cmd>lua require\"dap\".terminate()<CR>", opts("Stop Debugging"))
			vim.keymap.set("n", "<F9>", "<cmd>lua require\"dap\".toggle_breakpoint()<CR>", opts("Toggle Breakpoint"))
			vim.keymap.set(
				"n",
				"<leader>db",
				"<cmd>lua require\"dap\".set_breakpoint(vim.fn.input(\"Breakpoint condition: \"))<CR>",
				opts("Set Conditional Breakpoint")
			)
			vim.keymap.set(
				"n",
				"<leader>dl",
				"<cmd>lua require\"dap\".set_breakpoint(nil, nil, vim.fn.input(\"Log point message: \"))<CR>",
				opts("Set Logpoint")
			)
			vim.keymap.set("n", "<leader>de", "<cmd>lua require\"dap.ui.widgets\".hover()<CR>", opts("Evaluate Expression"))
			vim.keymap.set("n", "<leader>dr", "<cmd>lua require\"dap\".repl.toggle()<CR>", opts("Toggle REPL"))
			vim.keymap.set(
				"n",
				"<leader>dl",
				"<cmd>lua require\"dap\".run_last()<CR>",
				opts("Run Last Debug Adapter Configuration")
			)
			vim.keymap.set("n", "<leader>dc", "<cmd>lua require(\"dap\").run_to_cursor()<CR>", opts("Run to cursor"))
			vim.keymap.set("n", "<leader>d?", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end, opts("Open scope"))
			vim.keymap.set(
				"n",
				"<leader>dB",
				"<cmd>lua require(\"dap\").clear_breakpoints()<cr>",
				opts("Clear all breakpoints")
			)
			--#endregion
		end,
	},
	-- {
	-- 	"theHamsta/nvim-dap-virtual-text",
	-- 	config = function()
	-- 		require("nvim-dap-virtual-text").setup()
	-- 	end,
	-- },
	-- {
	-- 	"nvim-telescope/telescope-dap.nvim",
	-- 	dependencies = {
	-- 		"nvim-telescope/telescope.nvim",
	-- 		"mfussenegger/nvim-dap",
	-- 	},
	-- 	ft = js_based_languages,
	-- 	config = function()
	-- 		require("telescope").load_extension("dap")
	-- 		vim.keymap.set("n", "<leader>dtf", ":Telescope dap frames<CR>", { desc = "List frames" })
	-- 		vim.keymap.set("n", "<leader>dte", ":Telescope dap commands<CR>", { desc = "List commands" })
	-- 		vim.keymap.set("n", "<leader>dtb", ":Telescope dap list_breakpoints<CR>", { desc = "List breakpoints" })
	-- 	end,
	-- },
	{
		"leoluz/nvim-dap-go",
		ft = { "go" },
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-go").setup()
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = { "python" },
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			local mason_registry = require("mason-registry")

			local codelldb = mason_registry.get_package("debugpy")
			local python_path = codelldb:get_install_path() .. "/venv/bin/python"
			print("python_path", python_path)
			require("dap-python").setup(python_path)

			vim.keymap.set("n", "<leader>dpr", function()
				require("dap-python").test_method()
			end)
		end,
	},
}
