local harpoonKeymap = {
	{
		"<leader>ma",
		"<cmd>lua require('harpoon'):list().add()<cr>",
		mode = "n",
		desc = "Add mark",
	},
	{
		"<leader>mm",
		"<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>",
		mode = "n",
		desc = "Toggle harpoon menu",
	},
	{
		"<C-S-P>",
		mode = "n",
		"<cmd>lua require('harpoon'):list():prev()<cr>",
		desc = "Jump to previous mark",
	},
	{
		"<C-S-N>",
		mode = "n",
		"<cmd>lua require('harpoon'):list():next()<cr>",
		desc = "Jump to next mark",
	},
	{
		"<leader>mp",
		mode = "n",
		"<cmd>lua require('harpoon'):list().prev<cr>",
		desc = "Jump to [p]rev mark",
	},
	{
		"<leader>mn",
		mode = "n",
		"<cmd>lua require('harpoon'):list().next<cr>",
		desc = "Jump to [n]ext mark",
	},
}
for i = 1, 4, 1 do
	table.insert(harpoonKeymap, {
		"<leader>m" .. i,
		mode = "n",
		"<cmd>lua require('harpoon'):list():select(" .. i .. ")<cr>",
		desc = "Jump to mark: " .. i,
	})
end

return {
	{
		"christoomey/vim-tmux-navigator",
		lazy = true,
		keys = {
			{ "<C-h>", mode = "n", "<cmd> TmuxNavigateLeft<CR>" },
			{ "<C-l",  mode = "n", "<cmd> TmuxNavigateRight<CR>" },
			{ "<C-j>", mode = "n", "<cmd> TmuxNavigateDown<CR>" },
			{ "<C-k>", mode = "n", "<cmd> TmuxNavigateUp<CR>" },
		},
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = true,
		keys = harpoonKeymap,
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

			-- vim.keymap.set("n", "<leader>ma", function()
			-- 	harpoon:list():add()
			-- end, { desc = "Add mark" })
			-- vim.keymap.set("n", "<leader>mm", function()
			-- 	harpoon.ui:toggle_quick_menu(harpoon:list())
			-- end, { desc = "Toggle harpoon menu" })
			--
			-- for i = 1, 4, 1 do
			-- 	vim.keymap.set("n", "<leader>m" .. i, function()
			-- 		harpoon:list():select(i)
			-- 	end, { desc = "Jump to mark: " .. i })
			-- end
			--
			-- -- Toggle previous & next buffers stored within Harpoon list
			-- vim.keymap.set("n", "<C-S-P>", function()
			-- 	harpoon:list():prev()
			-- end, { desc = "Jump to previous mark" })
			-- vim.keymap.set("n", "<C-S-N>", function()
			-- 	harpoon:list():next()
			-- end, { desc = "Jump to next mark" })
			-- vim.keymap.set("n", "<leader>mp", harpoon:list().prev, { desc = "Jump to [p]rev mark" })
			-- vim.keymap.set("n", "<leader>mn", harpoon:list().next, { desc = "Jump to [n]ext mark" })
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
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
		cmd = "Oil",
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
	--[[ {
		"ggandor/leap.nvim",
		event = "UIEnter",
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
	}, ]]
	{
		"folke/flash.nvim",
		---@type Flash.Config
		opts = {
			search = {
				-- mode = "fuzzy"
			},
		},
		-- stylua: ignore
		lazy = true,
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
	},
}
