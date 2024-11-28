return { -- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	config = function() -- This is the function that runs, AFTER loading
		local whichKey = require("which-key")
		whichKey.setup({
			preset = "helix",
		})

		whichKey.add({
			{
				-- normal mode mappings register
				mode = "n",

				-- Document existing key chains
				{ "<leader>c", group = "[C]ode" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },

				-- custom key chains
				{ "<leader>f", group = "[F]uzzy find" },
				{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Fzf files" },
				{ "<leader>fG", "<cmd>FzfLua git_files<cr>", desc = "Fzf git files" },
				{ "<leader>fc", "<cmd>FzfLua git_status<cr>", desc = "Fzf modified/new files" },
				{ "<leader>fg", "<cmd>FzfLua live_grep_native<cr>", desc = "Fzf live grep" },
				{ "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Fzf help tags" },
				{ "<leader>fm", "<cmd>FzfLua manpages<cr>", desc = "Fzf manpages" },
				{ "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Fzf word under cursor" },
				{ "<leader>fi", "<cmd>FzfLua lgrep_curbuf<cr>", desc = "Fzf current buffer only" },
				{ "<leader>fr", "<cmd>FzfLua grep_last<cr>", desc = "Fzf resume last grep" },

				{ "<leader>b", group = "[B]uffer actions" },
				{ "<leader>bf", "<cmd>FzfLua buffers<cr>", desc = "Fzf buffers" },
				{ "<leader>ba", "<cmd>bufdo bd<CR>", desc = "Close [a]ll buffers" },
				{ "<leader>bd", "<cmd>bp|bd #<CR>", desc = "Close current buffer" },
				{ "<leader>bc", "<cmd>%bd|e#<CR>", desc = "Close all but current buffer" },

				{ "<leader>g", group = "[G]it action", mode = { "n", "v" } },
				{ "<leader>gf", "<cmd>FzfLua git_files<cr>", desc = "Fzf git branches" },
				{ "<leader>gB", "<cmd>FzfLua git_branchs<cr>", desc = "Fzf git branches" },
				{ "<leader>gc", "<cmd>FzfLua git_bcommits<cr>", desc = "Fzf git buffer commits" },

				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>tz", "<cmd>ZenMode<cr>", desc = "[T]oggle [z]en-mode" },

				{ "<leader>u", group = "[U]pgrade" },
				{ "<leader>m", group = "[M]arks" },
				{ "<leader>d", group = "[D]ebug adaptor protocol" },

				{ "<leader>h", group = "[H]TTP client" },
				{ "<leader>dt", group = "[D]AP [t]elescope" },
				{ "<leader>l", group = "[L]SP actions" },
				{ "<leader>lD", "<cmd>FzfLua lsp_declarations<cr>", desc = "Fzf lsp_declarations" },
				{ "<leader>ld", "<cmd>FzfLua lsp_definitions<cr>", desc = "Fzf lsp_definitions" },
				{ "<leader>li", "<cmd>FzfLua lsp_implementations<cr>", desc = "Fzf lsp_implementations" },
				{ "<leader>lr", "<cmd>FzfLua lsp_references<cr>", desc = "Fzf lsp_references" },
				{ "<leader>ls", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Fzf lsp_document_symbols" },
				{ "<leader>lw", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Fzf lsp_workspace_symbols" },
				{ "<leader>lt", "<cmd>FzfLua lsp_typedefs<cr>", desc = "Fzf lsp_typedefs" },

				{ "<leader>o", group = "[O]bsidian" },
				{ "<leader>x", group = "Trouble" },
				{ "<leader>w", group = "[W]orktree" },
				{ "<leader>vr", group = "[R]est client" },
				{ "<leader>vm", group = "Grapple Tags manager" },
				{ "<leader>v", group = "Plugin Keymaps namespace" },
				{ "<leader>z", group = "[Z]ellij" },
			},
			{
				-- visual mode mappings register
				mode = { "v", "n" },

				-- custom key chains
				{ "<leader>a", group = "[A]ctions" },
				{ "<leader>as", "<cmd>FzfLua spell_suggest<cr>", desc = "Fzf spell suggest" },
				{
					"<leader>ac",
					function()
						if vim.bo.filetype == "rust" then
							vim.cmd.RustLsp("codeAction")
						else
							vim.lsp.buf.code_action()
							-- require("fzf-lua").lsp_code_actions()
						end
					end,
					desc = "Fzf lsp code actions",
				},
			},
		})
	end,
}
