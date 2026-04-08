local M = {}

function M.setup_fzflua_keymaps()
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
				"<cmd>Fmt<cr>",
				desc = "Format file",
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
				"<leader>w",
				"<cmd>FzfLua grep_cword<cr>",
				desc = "Search word under cursor",
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
			{ "<leader>m", "<cmd>FzfLua keymaps<cr>", desc = "Search and select keymaps" },
		},
		{
			mode = { "v" },
			{
				"<leader>a",
				"<cmd>FzfLua lsp_code_actions<cr>",
				desc = "Perform visual mode code actions",
				silent = true,
			},
		},
	})
end

function M.setup_yazi_keymaps()
	require("which-key").add({
		{
			mode = { "n" },
			{
				"<leader>e",
				"<cmd>Yazi<cr>",
				desc = "Open yazi at the current file",
			},
		},
	})
end

function M.setup_oil_keymaps()
	require("which-key").add({
		{
			mode = { "n" },
			{
				"<leader>e",
				"<cmd>Oil<cr>",
				desc = "Open parent directory",
			},
		},
	})
end

function M.setup()
	require("which-key").add({
		{
			mode = { "n" },
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

			{
				"<C-s>",
				"<cmd>wa<cr>",
				desc = "Save all files",
			},

			{
				"]t",
				"<cmd>tabn<cr>",
				desc = "Next tab",
			},
			{
				"[t",
				"<cmd>tabp<cr>",
				desc = "Previous tab",
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

			-- Undotree
			{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undotree" },
		},
		{
			mode = { "n", "v" },
			-- Goto
			{ "ge", "G", desc = "Goto last line" },
			{ "gh", "0", desc = "Goto line start" },
			{ "gl", "$", desc = "Goto line end" },
			{ "gs", "^", desc = "Goto first non-blank in line" },
			{ "gk", "g_", desc = "Goto last non-blank in line" },
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
			{
				"<leader>s",
				":<C-u>'<,'>sort<CR>",
				desc = "Sort selections",
			},
		},
	})

	M.setup_toggle_keymaps()
end

function M.setup_toggle_keymaps()
	require("which-key").add({
		{
			mode = { "n" },
			{ "<leader>t", "", desc = "+toggle" },
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
			{
				"<leader>tb",
				"<cmd>Gitsigns toggle_current_line_blame<CR>",
				desc = "Toggle current line blame",
			},
			{
				"<leader>td",
				function()
					local virtual_text_enabled = vim.diagnostic.config().virtual_text or false
					-- Toggle virtual_text: if nil/false, set to true, otherwise set to false
					vim.diagnostic.config({ virtual_text = not virtual_text_enabled, underline = true })

					require("fidget").notify("Diagnositics virtual text: " .. tostring(virtual_text_enabled), vim.log.levels.INFO)
				end,
				desc = "Toggle diagnostics virtual text",
			},
		},
	})
end

function M.setup_luasnip_keymaps()
	local ls = require("luasnip")
	require("which-key").add({
		{
			mode = { "i", "s" },
			silent = true,
			{
				"<C-Up>",
				function()
					if ls.expand_or_jumpable() then
						ls.expand_or_jump()
					end
				end,
				desc = "Expand snippet or jump",
			},
			{
				"<C-Right>",
				function()
					if ls.choice_active() then
						ls.change_choice(1)
					end
				end,
				desc = "Change choice",
			},
			{
				"<C-Down>",
				function()
					if ls.jumpable(-1) then
						ls.jump(-1)
					end
				end,
				desc = "Jump backward",
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
			{ "<leader>,e", "<cmd>lua require(\"dap\").set_exception_breakpoints()<cr>", desc = "Set exception breakpoints" },
			{
				"<leader>,k",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Expression under cursor",
			},
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
			{ "<leader>lt", "<cmd>Lazy load neotest<cr>", desc = "Lazy load neotest" },
			{ "<leader>lf", "<cmd>Lazy load nvim-ufo<cr>", desc = "Lazy load folds" },
			{ "<leader>lD", "<cmd>Lazy load diffview.nvim<cr>", desc = "Lazy load diffview" },
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

function M.setup_harpoon_keymaps()
	require("which-key").add({
		{
			mode = "n",
			{ "<leader>h", ":lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Toggle quick menu" },
			{ "<leader>hm", ":lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Toggle quick menu" },
			{ "<leader>ha", ":lua require('harpoon.mark').add_file()<cr>", desc = "Toggle quick menu" },
			{ "<leader>1", ":lua require('harpoon.ui').nav_file(1)<cr>", desc = "Go to file 1" },
			{ "<leader>2", ":lua require('harpoon.ui').nav_file(2)<cr>", desc = "Go to file 2" },
			{ "<leader>3", ":lua require('harpoon.ui').nav_file(3)<cr>", desc = "Go to file 3" },
			{ "<leader>4", ":lua require('harpoon.ui').nav_file(4)<cr>", desc = "Go to file 4" },
			{ "<leader>5", ":lua require('harpoon.ui').nav_file(5)<cr>", desc = "Go to file 5" },
		},
	})
end

function M.setup_comment_keymaps()
	local api = require("Comment.api")

	require("which-key").add({
		{
			mode = { "n" },
			{
				"<leader>c",
				function()
					require("Comment.api").toggle.linewise.current()
				end,
				desc = "Comment/uncomment selections",
			},
			{
				"<leader>C",
				function()
					require("Comment.api").toggle.blockwise.current()
				end,
				desc = "Block comment/uncomment selections",
			},
		},
		{
			mode = { "x" },
			{
				"<leader>c",
				function()
					api.toggle.linewise(vim.fn.visualmode())
				end,
				desc = "Comment/uncomment selections",
			},
			{
				"<leader>C",
				function()
					api.toggle.blockwise(vim.fn.visualmode())
				end,
				desc = "Block comment/uncomment selections",
			},
		},
	})
end

function M.setup_scribble_keymaps()
	require("which-key").add({
		{
			mode = { "n" },
			{ "<leader>xs", "", desc = "+scribble" },
			{
				"<leader>xss",
				"<cmd>ScribbleListBranch<cr>",
				desc = "Scribble select from a list of branch specific scratchfles",
			},
			{
				"<leader>xsm",
				function()
					local dir = require("scribble").get_dir()
					require("yazi").yazi({}, dir)
				end,
				desc = "Open yazi at the scribble directory",
			},
			{
				"<leader>xsl",
				"<cmd>ScribbleListAll<cr>",
				desc = "Scribble select from a list of all scratchfles",
			},
			{
				"<leader>xsf",
				"<cmd>ScribbleListFiletype<cr>",
				desc = "Scribble select from a list of filetype specific scratchfles",
			},
		},
		{
			mode = { "n", "v" },
			{
				"<leader>xsa",
				"<cmd>ScribbleCreate<cr>",
				desc = "Scribble select create options",
			},
			{
				"<leader>xsc",
				"",
				desc = "+Scribble create",
			},
			{
				"<leader>xscb",
				"<cmd>ScribbleCreateBranch<cr>",
				desc = "Create branch specific scratch file",
			},
			{
				"<leader>xscm",
				"<cmd>ScribbleCreateMisc<cr>",
				desc = "Create miscellaneous scratch file",
			},
			{
				"<leader>xscf",
				"<cmd>ScribbleCreateFiletype<cr>",
				desc = "Create filetype specific scratch file",
			},
		},
	})
end

function M.setup_flash_keymaps()
	require("which-key").add({
		{
			mode = { "n", "x", "o" },
			{
				"gw",
				"<cmd>lua require('flash').jump()<cr>",
				desc = "Flash",
			},
			{
				"<leader>xt",
				function()
					require("flash").treesitter({
						actions = {
							["<Up>"] = "next",
							["<Down>"] = "prev",
						},
					})
				end,
				desc = "Treesitter incremental selection",
			},
		},
	})
end

function M.setup_rustowl_keymaps()
	require("which-key").add({
		{
			mode = { "n", "x", "o" },
			{
				"<leader>to",
				"<cmd>lua require('rustowl').toggle()<cr>",
				desc = "Toggle rustowl",
			},
		},
	})
end

function M.setup_99_keymaps()
	local _99 = require("99")
	require("which-key").add({
		{
			mode = { "n" },
			{ "<leader>p", "", desc = "+99" },
			{
				"<leader>ps",
				function()
					_99.search()
				end,
				desc = "99: Search",
			},
			{
				"<leader>px",
				function()
					_99.stop_all_requests()
				end,
				desc = "99: Cancel all requests",
			},
			{
				"<leader>pm",
				function()
					require("99.extensions.fzf_lua").select_model()
				end,
				desc = "99: Select model",
			},
			{
				"<leader>pp",
				function()
					require("99.extensions.fzf_lua").select_provider()
				end,
				desc = "99: Select provider",
			},
		},
		{
			mode = { "v" },
			{
				"<leader>pv",
				function()
					_99.visual()
				end,
				desc = "99: Replace selection with AI output",
			},
		},
	})
end

M.setup_treesitter_textobjects_keymaps = function()
	local select_textobject = require("nvim-treesitter-textobjects.select").select_textobject
	local swap = require("nvim-treesitter-textobjects.swap")

	require("which-key").add({
		{
			mode = { "x", "o" },
			-- You can use the capture groups defined in `textobjects.scm`
			-- List of capture groups: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/main/BUILTIN_TEXTOBJECTS.md
			{
				"if",
				function()
					select_textobject("@function.inner", "textobjects")
				end,
				desc = "Select inside function",
			},
			{
				"af",
				function()
					select_textobject("@function.outer", "textobjects")
				end,
				desc = "Select around function",
			},
			{
				"ac",
				function()
					select_textobject("@comment.outer", "textobjects")
				end,
				desc = "Select around comment",
			},
			{
				"ic",
				function()
					select_textobject("@comment.inner", "textobjects")
				end,
				desc = "Select inside comment",
			},
			{
				"al",
				function()
					select_textobject("@loop.outer", "textobjects")
				end,
				desc = "Select around loop",
			},
			{
				"il",
				function()
					select_textobject("@loop.inner", "textobjects")
				end,
				desc = "Select inside loop",
			},
			{
				"aj",
				function()
					select_textobject("@conditional.outer", "textobjects")
				end,
				desc = "Select around conditional",
			},
			{
				"ij",
				function()
					select_textobject("@conditional.inner", "textobjects")
				end,
				desc = "Select inside conditional",
			},
			{
				"aa",
				function()
					select_textobject("@parameter.outer", "textobjects")
				end,
				desc = "Select around parameter",
			},
			{
				"ia",
				function()
					select_textobject("@parameter.inner", "textobjects")
				end,
				desc = "Select inside parameter",
			},
			{
				"ab",
				function()
					select_textobject("@block.outer", "textobjects")
				end,
				desc = "Select around block",
			},
			{
				"ib",
				function()
					select_textobject("@block.inner", "textobjects")
				end,
				desc = "Select inside block",
			},
			{
				"aq",
				function()
					select_textobject("@custom_string.outer", "textobjects")
				end,
				desc = "Select around quote",
			},
			{
				"iq",
				function()
					select_textobject("@custom_string.inner", "textobjects")
				end,
				desc = "Select inside quote",
			},
			{
				"ao",
				function()
					select_textobject("@custom_bracket.outer", "textobjects")
				end,
				desc = "Select around bracket",
			},
			{
				"io",
				function()
					select_textobject("@custom_bracket.inner", "textobjects")
				end,
				desc = "Select inside bracket",
			},

			-- You can also use captures from other query groups like `locals.scm`
			{
				"as",
				function()
					select_textobject("@local.scope", "locals")
				end,
				desc = "Select around local scope",
			},
		},
		{
			mode = { "n" },
			-- Swap
			-- {
			-- 	"<leader>a",
			-- 	function()
			-- 		swap.swap_next("@parameter.inner")
			-- 	end,
			-- },
			-- {
			-- 	"<leader>A",
			-- 	function()
			-- 		swap.swap_previous("@parameter.outer")
			-- 	end,
			-- },
		},
	})
end

M.setup_terminal_keymaps = function()
	require("which-key").add({
		{
			mode = { "n" },
			{
				"<leader>xu",
				function()
					vim.cmd.vsplit()
					vim.cmd.terminal()
					vim.cmd.wincmd("J")
					vim.api.nvim_win_set_height(0, 15)
				end,
				desc = "Open terminal",
			},
		},
	})
end

M.setup_gitcommit_ft_keymaps = function()
	local hostname = vim.uv.os_gethostname()
	if hostname == "pop-os" then
		require("which-key").add({
			{
				mode = { "n" },
				{
					"<c-c><c-g>",
					function()
						local fidget = require("fidget")
						fidget.notify("Generating commit message...", vim.log.levels.INFO, { title = "gen-commit" })

						vim.system({ "gen-commit", "--print" }, { text = true }, function(obj)
							if obj.code ~= 0 then
								fidget.notify("Failed to generate commit message!", vim.log.levels.ERROR, { title = "gen-commit" })
								return
							end

							local result = obj.stdout:gsub("^%s+", ""):gsub("%s+$", "")
							vim.schedule(function()
								vim.api.nvim_buf_set_lines(0, 0, 0, false, { result })
								require("fidget").notify("Commit message generated!", vim.log.levels.INFO, { title = "gen-commit" })
							end)
						end)
					end,
					desc = "Commit with gen-commit cli",
				},
			},
		})
		return
	end
	require("which-key").add({
		{
			mode = { "n" },
			{
				"<c-c><c-g>",
				"<cmd>read !COMMIT_PRINT_ONLY=1 ./scripts/commit-claude.sh<cr>",
				desc = "Commit with claude code",
			},
		},
	})
end

return M
