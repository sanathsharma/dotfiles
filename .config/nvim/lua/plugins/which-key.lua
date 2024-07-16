return { -- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	config = function() -- This is the function that runs, AFTER loading
		local whichKey = require("which-key")
		whichKey.setup()

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
				{ "<leader>b", group = "[B]uffer" },
				{ "<leader>g", group = "[G]o to" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>u", group = "[U]pgrade" },
				{ "<leader>m", group = "[M]arks" },
				{ "<leader>d", group = "[D]ebug adaptor protocol" },
				{ "<leader>l", group = "[L]azy" },
				{ "<leader>o", group = "[O]bsidian" },
				{ "<leader>x", group = "Trouble" },
				{ "<leader>w", group = "[W]orktree" },
			},
			{
				-- visual mode mappings register
				mode = { "v", "n" },

				-- custom key chains
				{ "<leader>a", group = "[A]ctions" },
				{ "<leader>h", group = "Git actions" },
			},
		})
	end,
}
