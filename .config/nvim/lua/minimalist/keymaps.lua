local M = {}

function M.setup()
	require("which-key").add({
		{
			mode = { "n" },
			-- FzfLua
			{
				"<leader>f",
				"<cmd>FzfLua files<cr>",
				desc = "Open file picker",
			},
			-- { "<C-p>",            "<cmd>FzfLua global<cr>",                                                  desc = "Open global picker" },
			{
				"<leader>F",
				"<cmd>lua require('fzf-lua').files({ cwd = vim.fn.expand('%:p:h') })<cr>",
				desc = "Open file picker in current buffer directory",
			},
			{
				"<leader><leader>",
				"<cmd>FzfLua files<cr>",
				desc = "Open file picker",
			},
			{
				"<leader>'",
				"<cmd>FzfLua resume<cr>",
				desc = "Open last picker",
			},
			{
				"<leader>b",
				"<cmd>FzfLua buffers<cr>",
				desc = "Open buffer picker",
			},
			{
				"<leader>/",
				"<cmd>FzfLua live_grep<cr>",
				desc = "Global search in workspace folder",
			},
			{
				"<leader>j",
				"<cmd>FzfLua jumps<cr>",
				desc = "Open jumplist picker",
			},
			{
				"<leader>s",
				"<cmd>FzfLua lsp_document_symbols<cr>",
				desc = "Open symbol picker",
			},
			{
				"<leader>S",
				"<cmd>FzfLua lsp_workspace_symbols<cr>",
				desc = "Open workspace symbol picker",
			},
			{
				"<leader>d",
				"<cmd>FzfLua lsp_document_diagnostics<cr>",
				desc = "Open diagnostic picker",
			},
			{
				"<leader>D",
				"<cmd>FzfLua lsp_workspace_diagnostics<cr>",
				desc = "Open workspace diagnostic picker",
			},
			{
				"<leader>g",
				"<cmd>FzfLua git_status<cr>",
				desc = "Open changed file picker",
			},
			{
				"<leader>o",
				"<cmd>FzfLua lsp_incoming_calls<cr>",
				desc = "Open incoming calls picker",
			},
			{
				"<leader>O",
				"<cmd>FzfLua lsp_outgoing_calls<cr>",
				desc = "Open outgoing calls picker",
			},
			{
				"<leader>a",
				"<cmd>FzfLua lsp_code_actions<cr>",
				desc = "Perform code actions",
			},
			{
				"<leader>r",
				vim.lsp.buf.rename,
				desc = "Rename symbol",
			},
			{
				"<leader>k",
				vim.lsp.buf.hover,
				desc = "Show docs for item under cursor",
			},
			{ "<leader>m", "<cmd>FzfLua marks<cr>", desc = "Search and select marks" },

			-- Oil
			{
				"-",
				"<cmd>Oil<cr>",
				desc = "Open parent directory",
			},

			-- Split join
			{
				"<leader>tt",
				"<cmd>TSJToggle<CR>",
				desc = "Toggle split join",
			},
			{
				"<leader>ti",
				"<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>",
				desc = "Toggle lsp inlay hints",
			},

			-- Goto
			{
				"gd",
				vim.lsp.buf.definition,
				desc = "Goto definition",
			},
			{
				"gD",
				vim.lsp.buf.declaration,
				desc = "Goto declaration",
			},
			-- { "gy",               "<cmd>FzfLua lsp_typedefs<cr>",                                            desc = "Goto type definition" }, -- Use grt instead
			-- { "gr",               "<cmd>FzfLua lsp_references<cr>",                                          desc = "Goto references" }, -- Use grr instead
			-- { "gi",               "<cmd>FzfLua lsp_implementations<cr>",                                     desc = "Goto implementation" }, -- Use gri instead

			-- Git
			{
				"[h",
				"<cmd>Gitsigns nav_hunk prev<cr>",
				desc = "Previous hunk",
			},
			{
				"]h",
				"<cmd>Gitsigns nav_hunk next<cr>",
				desc = "Next hunk",
			},

			-- Helpers
			{
				"<leader>y",
				"\"+yy",
				desc = "Yank current line into system clipboard",
			},

			-- Remaps
			{ "<Esc>", "<cmd>nohlsearch<CR>" },
			{ "n", "nzzzv" },
			{ "N", "Nzzzv" },
			{ "<C-d>", "<C-d>zz" },
			{ "<C-u>", "<C-u>zz" },
			{ "U", "<C-r>" },

			-- Leap
			{
				"gw",
				"<Plug>(leap)",
				desc = "Leap anywhere",
			},
			{
				"gW",
				"<Plug>(leap-from-window)",
				desc = "Leap from window",
			},
			{ "<A-j>", "<cmd>move .+1==<cr>", noremap = true, silent = true },
			{ "<A-k>", "<cmd>move .-2==<cr>", noremap = true, silent = true },
		},
		{
			mode = { "n", "v" },
			-- Goto
			{ "ge", "G", desc = "Goto last line" },
			{ "gh", "0", desc = "Goto line start" },
			{ "gl", "$", desc = "Goto line end" },
			{ "gs", "^", desc = "Goto first non-blank in line" },
			{ "gk", "g_", desc = "Goto last non-blank in line" },

			-- Comments
			{ "<leader>c", "gcc", desc = "Comment/uncomment selections", noremap = true },
			{ "<leader>C", "gbc", desc = "Block comment/uncomment selections", noremap = true },
		},
		{
			mode = { "v" },
			-- Remaps
			{ ">", ">gv", noremap = true, desc = "Keep selection after right indent" },
			{ "<", "<gv", noremap = true, desc = "Keep selection after left indent" },
		},
		{
			mode = { "x", "v" },
			{ "<leader>y", "\"+y", noremap = true, desc = "Yank selection into system clipboard" },
			{ "<A-j>", ":move '>+1<CR>gv=gv", noremap = true, silent = true },
			{ "<A-k>", ":move '<-2<CR>gv=gv", noremap = true, silent = true },
		},
	})
end

function M.setup_luasnip_keymaps()
	local ls = require("luasnip")
	require("which-key").add({
		{
			mode = { "i" },
			silent = true,
			{
				"<C-K>",
				function()
					ls.expand()
				end,
				desc = "Expand snippet",
			},
		},
		{
			mode = { "i", "s" },
			silent = true,
			{
				"<C-L>",
				function()
					ls.jump(1)
				end,
				desc = "Jump forward",
			},
			{
				"<C-J>",
				function()
					ls.jump(-1)
				end,
				desc = "Jump backward",
			},
			{
				"<C-E>",
				function()
					if ls.choice_active() then
						ls.change_choice(1)
					end
				end,
				desc = "Change choice",
			},
		},
	})
end

function M.setup_rustaceanvim_keymaps()
	local bufnr = vim.api.nvim_get_current_buf()
	require("which-key").add({
		{
			mode = { "n" },
			silent = true,
			buffer = bufnr,
			noremap = true,
			{
				"<leader>a",
				function()
					vim.cmd.RustLsp("codeAction")
				end,
				desc = "Rust code action",
			},
			{
				"K",
				function()
					vim.cmd.RustLsp({ "hover", "actions" })
				end,
				desc = "Rust hover actions",
			},
		},
	})
end

function M.setup_dap_keymaps()
	require("which-key").add({
		{
			mode = { "n" },
			{ "<leader>,", "", desc = "+Dap" },
			{ "<leader>,c", "<cmd>DapContinue<cr>", desc = "Start/Continue" },
			{ "<leader>,n", "<cmd>DapStepOver<cr>", desc = "Step over" },
			{ "<leader>,i", "<cmd>DapStepInto<cr>", desc = "Step into" },
			{ "<leader>,o", "<cmd>DapStepOut<cr>", desc = "Step out" },
			{ "<leader>,x", "<cmd>DapTerminate<cr>", desc = "Terminate debug session" },
			{ "<leader>,q", "<cmd>DapDisconnect<cr>", desc = "Disconnect debug session" },
			{ "<leader>,b", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint" },
			{ "<leader>,r", "<cmd>DapRestartFrame<cr>", desc = "Restart frame" },
		},
	})
end

function M.setup_dapview_keymaps()
	require("which-key").add({
		{
			mode = { "n" },
			{ "<leader>,v", "<cmd>DapViewToggle<cr>", desc = "Toggle debug view" },
		},
	})
end

function M.setup_test_keymaps()
	require("which-key").add({
		{
			mode = { "n" },
			{
				"<leader>.",
				"",
				desc = "+test",
			},
			{
				"<leader>.t",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run File (Neotest)",
			},
			{
				"<leader>.T",
				function()
					require("neotest").run.run(vim.uv.cwd())
				end,
				desc = "Run All Test Files (Neotest)",
			},
			{
				"<leader>.r",
				function()
					require("neotest").run.run()
				end,
				desc = "Run Nearest (Neotest)",
			},
			{
				"<leader>.d",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "Run Nearest with DAP (Neotest)",
			},
			{
				"<leader>.l",
				function()
					require("neotest").run.run_last()
				end,
				desc = "Run Last (Neotest)",
			},
			{
				"<leader>.s",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle Summary (Neotest)",
			},
			{
				"<leader>.o",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "Show Output (Neotest)",
			},
			{
				"<leader>.O",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle Output Panel (Neotest)",
			},
			{
				"<leader>.S",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop (Neotest)",
			},
			{
				"<leader>.w",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				desc = "Toggle Watch (Neotest)",
			},
		},
	})
end

function M.setup_codeium_keymaps()
	require("which-key").add({
		{
			mode = "i",
			{
				"<M-n>",
				"<cmd>lua require('codeium.virtual_text').cycle_or_complete()<cr>",
				desc = "Codeium: cycle or complete",
			},
		},
	})
end

function M.setup_lazy_module_keymaps()
	require("which-key").add({
		{
			mode = "n",
			{ "<leader>l", "", desc = "+lazy" },
			{ "<leader>ld", "<cmd>Lazy load nvim-dap-view<cr>", desc = "Lazy load dap setup" },
			{ "<leader>lt", "<cmd>Lazy load neotest", desc = "Lazy load neotest" },
			{ "<leader>lf", "<cmd>Lazy load nvim-ufo", desc = "Lazy load folds" },
		},
	})
end

function M.setup_fold_keymaps()
	require("which-key").add({
		{
			mode = "n",
			{ "zR", require("ufo").openAllFolds, desc = "Open all folds" },
			{ "zM", require("ufo").closeAllFolds, desc = "Close all folds" },
		},
	})
end

return M
