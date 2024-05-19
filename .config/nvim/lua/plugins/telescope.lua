return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find [f]iles" })
			vim.keymap.set("n", "<leader>fs", builtin.git_files, { desc = "Find [s]ource control files (Git)" })
			vim.keymap.set("n", "<leader>fc", builtin.git_branches, { desc = "Find git branches" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live [g]rep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find [b]uffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search [h]elp" })
			vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Search current [W]ord" })
			vim.keymap.set(
				"n",
				"<leader>fs",
				builtin.git_status,
				{ desc = "Move between changed files in current HEAD" }
			)
			vim.keymap.set("n", "<leader>fi", function()
				builtin.live_grep({ search_dirs = { vim.fn.expand("%:p") } })
			end, { desc = "Live grep [i]n in current buffer" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-j>"] = function(prompt_bufnr)
								actions.move_selection_next(prompt_bufnr)
							end,
							["<C-k>"] = function(prompt_bufnr)
								actions.move_selection_previous(prompt_bufnr)
							end,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
