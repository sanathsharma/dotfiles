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
			vim.keymap.set(
				"n",
				"<leader>dt",
				"<cmd>DapToggleBreakpoint<CR>",
				{ noremap = true, desc = "[T]oggle DAP breakpoint" }
			)
			vim.keymap.set(
				"n",
				"<leader>dT",
				":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
				{ desc = "Set conditional breakpoint" }
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
			vim.keymap.set("n", "<leader>dk", ":lua require\"dap\".up()<CR>zz", { desc = "DAP up" })
			vim.keymap.set("n", "<leader>dj", ":lua require\"dap\".down()<CR>zz", { desc = "DAP down" })
			vim.keymap.set({ "n", "t" }, "<leader>do", function()
				require("dap").step_out()
			end, { desc = "DAP step out" })
			vim.keymap.set({ "n", "t" }, "<leader>di", function()
				require("dap").step_into()
			end, { desc = "DAP step into" })
			vim.keymap.set({ "n", "t" }, "<leader>dO", function()
				require("dap").step_over()
			end, { desc = "DAP step over" })
			vim.keymap.set("n", "<leader>dn", function()
				require("dap").run_to_cursor()
			end, { desc = "DAP run to cursor" })
			vim.keymap.set("n", "<leader>dK", function()
				require("dap.ui.widgets").hover()
			end, { desc = "DAP hover widget" })
			vim.keymap.set("n", "<leader>d?", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end, { desc = "DAP scopes widget" })
			vim.keymap.set(
				"n",
				"<leader>dr",
				":lua require\"dap\".repl.toggle({}, \"vsplit\")<CR><C-w>l",
				{ desc = "DAP toggle repl" }
			)
			vim.keymap.set("n", "<leader>dR", function()
				require("dap").clear_breakpoints()
			end, { desc = "DAP clear all breakpoints" })
			--#endregion
		end,
	},
	-- {
	-- 	"theHamsta/nvim-dap-virtual-text",
	-- 	config = function()
	-- 		require("nvim-dap-virtual-text").setup()
	-- 	end,
	-- },
	{
		"nvim-telescope/telescope-dap.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope").load_extension("dap")
			vim.keymap.set("n", "<leader>df", ":Telescope dap frames<CR>", { desc = "Dap [f]rames" })
			vim.keymap.set("n", "<leader>de", ":Telescope dap commands<CR>", { desc = "Dap [c]ommands" })
			vim.keymap.set("n", "<leader>db", ":Telescope dap list_breakpoints<CR>", { desc = "Dap [v]reakpoints" })
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
