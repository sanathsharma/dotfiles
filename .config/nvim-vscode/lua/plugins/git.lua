-- https://github.com/lewis6991/gitsigns.nvim
return {
	{
		"lewis6991/gitsigns.nvim",
		event = "BufEnter",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "-" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "│" },
				},

				on_attach = function(bufnr)
					local gitsigns = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]h", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]h", bang = true })
						else
							gitsigns.next_hunk()
						end
					end)

					map("n", "[h", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[h", bang = true })
						else
							gitsigns.prev_hunk()
						end
					end)

					-- Actions
					map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "[S]tage Hunk" })
					map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "[R]eset Hunk" })
					map("v", "<leader>gs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "[S]tage hunk" })
					map("v", "<leader>gr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "[R]eset hunk" })
					map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "[S]tage buffer" })
					map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "[U]ndo stage hunk" })
					map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "[R]eset buffer" })
					map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "[P]review hunk" })
					map("n", "<leader>gb", function()
						gitsigns.blame_line({ full = true })
					end, { desc = "[B]lame line" })
					map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle git line [b]lame" })
					map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle [d]eleted (Git)" })

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
					-- see https://github.com/lewis6991/gitsigns.nvim?tab=readme-ov-file#keymaps for other suggested keymaps
				end,
			})
		end,
	},
	{
		"tpope/vim-fugitive",
		cmd = "G",
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	},
}
