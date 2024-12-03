return {             -- Useful plugin to show you pending keybinds.
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
				{ "<leader>c",  group = "[C]ode" },
				{ "<leader>r",  group = "[R]ename" },
				{ "<leader>s",  group = "[S]earch" },

				-- custom key chains
				{ "<leader>f",  group = "[F]uzzy find" },

				{ "<leader>b",  group = "[B]uffer actions" },
				{ "<leader>ba", "<cmd>bufdo bd<CR>",                                         desc = "Close [a]ll buffers" },
				{ "<leader>bd", "<cmd>bd<CR>",                                               desc = "Close current buffer" },
				{ "<leader>bc", "<cmd>%bd|e#<CR>",                                           desc = "Close all but current buffer" },

				{ "<leader>g",  group = "[G]it action",                                      mode = { "n", "v" } },

				{ "<leader>t",  group = "[T]oggle" },
				{ "<leader>tz", "<cmd>ZenMode<cr>",                                          desc = "[T]oggle [z]en-mode" },

				{ "<leader>u",  group = "[U]pgrade" },
				{ "<leader>m",  group = "[M]arks" },

				-- DAP
				{ "<leader>d",  group = "[D]ebug adaptor protocol" },
				-- { "<leader>de", "<cmd>DapEnable<cr>", desc = "Enable DAP" },


				{ "<leader>h",  group = "[H]TTP client" },
				{ "<leader>dt", group = "[D]AP [t]elescope" },
				{ "<leader>l",  group = "[L]SP actions" },

				{ "<leader>o",  group = "[O]bsidian" },
				{ "<leader>x",  group = "Trouble" },
				{ "<leader>w",  group = "[W]orktree" },
				{ "<leader>vr", group = "[R]est client" },
				{ "<leader>vm", group = "Grapple Tags manager" },
				{ "<leader>v",  group = "Plugin Keymaps namespace" },
				{ "<leader>z",  group = "[Z]ellij" },
				{ "<leader>e",  group = "Extras" },
				{ "<leader>ec", "<cmd>g/console.log/d<cr>",                                  desc = "Delete console.log" },

				-- Oil
				{ "-",          "<cmd>Oil<cr>",                                              desc = "Oil open parent dir" },

				-- Neotree
				{ "<C-n>",      ":Neotree source=filesystem toggle position=left reveal<CR>" },
			},
			{
				-- visual mode mappings register
				mode = { "v", "n" },

				-- custom key chains
				{ "<leader>a",  group = "[A]ctions" },
			},
		})
	end,
}
