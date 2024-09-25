return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { "node_modules/", "vendor/", ".git/", "package-lock.json" },
				},
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", function()
				builtin.find_files({ hidden = true })
			end, { desc = "Find [f]iles" })
			vim.keymap.set("n", "<leader>fs", builtin.git_files, { desc = "Find [s]ource control files (Git)" })
			vim.keymap.set("n", "<leader>fc", builtin.git_branches, { desc = "Find git branches" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live [g]rep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find [b]uffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search [h]elp" })
			vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Search current [W]ord" })
			vim.keymap.set("n", "<leader>fs", builtin.git_status, { desc = "Move between changed files in current HEAD" })
			vim.keymap.set("n", "<leader>fi", builtin.current_buffer_fuzzy_find, { desc = "Live grep [i]n current buffer" })
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
							["<Esc>"] = function(prompt_bufnr)
								actions.close(prompt_bufnr)
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
