return {
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
		config = function()
			vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>")
			vim.keymap.set("n", "<C-l", "<cmd> TmuxNavigateRight<CR>")
			vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>")
			vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>")
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")

			harpoon:setup({
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
					key = function()
						local util = require("utils.get-os-cmd-output")
						local branch = util.get_os_command_output({
							"git",
							"rev-parse",
							"--abbrev-ref",
							"HEAD",
						})[1]

						if branch then
							return vim.uv.cwd() .. "-" .. branch
						else
							return vim.uv.cwd()
						end
					end,
				},
			})

			vim.keymap.set("n", "<leader>ma", function()
				harpoon:list():add()
			end, { desc = "Add mark" })
			vim.keymap.set("n", "<leader>mm", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Toggle harpoon menu" })

			for i = 1, 4, 1 do
				vim.keymap.set("n", "<leader>m" .. i, function()
					harpoon:list():select(i)
				end, { desc = "Jump to mark: " .. i })
			end

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-P>", function()
				harpoon:list():prev()
			end, { desc = "Jump to previous mark" })
			vim.keymap.set("n", "<C-S-N>", function()
				harpoon:list():next()
			end, { desc = "Jump to next mark" })
			vim.keymap.set("n", "<leader>mp", harpoon:list().prev, { desc = "Jump to [p]rev mark" })
			vim.keymap.set("n", "<leader>mn", harpoon:list().next, { desc = "Jump to [n]ext mark" })
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			vim.keymap.set("n", "<C-n>", ":Neotree source=filesystem toggle position=left reveal<CR>")

			require("neo-tree").setup({
				filesystem = {
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = false,
					},
					follow_current_file = {
						enabled = true,
						leave_dirs_open = false,
					},
				},
			})
		end,
	},
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-s>"] = "actions.select_vsplit",
					["<C-h>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<C-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
					["g\\"] = "actions.toggle_trash",
				},
				view_options = {
					show_hidden = true,
				},
			})

			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},
	{
		"ggandor/leap.nvim",
		config = function()
			vim.keymap.set({ "n", "x", "o" }, "m", "<Plug>(leap-forward)", { desc = "[M]ove cursor forward" })
			vim.keymap.set({ "n", "x", "o" }, "M", "<Plug>(leap-backward)", { desc = "[M]ove cursor backward" })
			vim.keymap.set(
				{ "n", "x", "o" },
				"mw",
				"<Plug>(leap-from-window)",
				{ desc = "[M]ove cursor across window splits" }
			)
		end,
	},
	{
		"cbochs/grapple.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
		},
		opts = {
			scope = "git_branch", -- also try out "git_branch"
		},
		event = { "BufReadPost", "BufNewFile" },
		cmd = "Grapple",
		keys = {
			{ "<leader>vma", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
			{ "<leader>vmm", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },

			{ "<leader>vm1", "<cmd>Grapple select index=1<cr>", desc = "Select first tag" },
			{ "<leader>vm2", "<cmd>Grapple select index=2<cr>", desc = "Select second tag" },
			{ "<leader>vm3", "<cmd>Grapple select index=3<cr>", desc = "Select third tag" },
			{ "<leader>vm4", "<cmd>Grapple select index=4<cr>", desc = "Select fourth tag" },

			{ "<leader>vmn", "<cmd>Grapple cycle_tags next<cr>", desc = "Go to next tag" },
			{ "<leader>vmp", "<cmd>Grapple cycle_tags prev<cr>", desc = "Go to previous tag" },
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		-- stylua: ignore
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
	},
}
