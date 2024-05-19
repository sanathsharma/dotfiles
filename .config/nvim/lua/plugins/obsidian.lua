return {
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		-- ft = "markdown",
		-- instead of applying to all markdown files, following lines adds obsidian support only on mentioned file paths
		event = function()
			-- load plugin only in ObsidianVaults folder or sub folders (workspaces)
			if vim.fn.expand("%:p:h"):find("^" .. vim.fn.expand("~") .. "/ObsidianVaults") ~= nil then
				return "VimEnter *"
			end
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("obsidian").setup({
				workspaces = {
					{
						name = "Personal",
						path = "~/ObsidianVaults/personal",
					},
					{
						name = "Work",
						path = "~/ObsidianVaults/work",
					},
				},
				completion = {
					nvim_cmp = true,
					min_chars = 2,
				},
				new_notes_location = "current_dir",
				mappings = {
					["<leader>of"] = {
						action = function()
							return require("obsidian").util.gf_passthrough()
						end,
						opts = { noremap = false, expr = true, buffer = true, desc = "Obsidian [f]ollow" },
					},
					["<leader>oc"] = {
						action = function()
							return require("obsidian").util.toggle_checkbox()
						end,
						opts = { desc = "Obsidian Check Checkbox" },
					},
					["<leader>ot"] = {
						action = function()
							return vim.cmd("<cmd>ObsidianTemplate<CR>")
						end,
						opts = { desc = "Insert Obsidian Template" },
					},
					["<leader>oo"] = {
						action = function()
							vim.cmd("<cmd>ObsidianOpen<CR>")
						end,
						opts = { desc = "Open in Obsidian App" },
					},
					["<leader>ob"] = {
						action = function()
							vim.cmd("<cmd>ObsidianBacklinks<CR>")
						end,
						opts = { desc = "Show ObsidianBacklinks" },
					},
					["<leader>ol"] = {
						action = function()
							vim.cmd("<cmd>ObsidianLinks<CR>")
						end,
						opts = { desc = "Show ObsidianLinks" },
					},
					["<leader>on"] = {
						action = function()
							vim.cmd("<cmd>ObsidianNew<CR>")
						end,
						opts = { desc = "Create New Note" },
					},
					["<leader>os"] = {
						action = function()
							vim.cmd("<cmd>ObsidianSearch<CR>")
						end,
						opts = { desc = "Search Obsidian" },
					},
					["<leader>oq"] = {
						action = function()
							vim.cmd("<cmd>ObsidianQuickSwitch<CR>")
						end,
						opts = { desc = "Quick Switch" },
					},
				},
				daily_notes = {
					folder = "$daily",
					date_format = "%Y-%m-%d",
					alias_format = "%B %-d, %Y",
					template = nil,
				},

				wiki_link_func = function(opts)
					if opts.id == nil then
						return string.format("[[%s]]", opts.label)
					elseif opts.label ~= opts.id then
						return string.format("[[%s|%s]]", opts.id, opts.label)
					else
						return string.format("[[%s]]", opts.id)
					end
				end,
				note_frontmatter_func = function(note)
					-- This is equivalent to the default frontmatter function.
					local out = { id = note.id, aliases = note.aliases, tags = note.tags, area = "", project = "" }

					-- `note.metadata` contains any manually added fields in the frontmatter.
					-- So here we just make sure those fields are kept in the frontmatter.
					if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
						for k, v in pairs(note.metadata) do
							out[k] = v
						end
					end
					return out
				end,

				note_id_func = function(title)
					-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
					-- In this case a note with the title 'My new note' will be given an ID that looks
					-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
					local suffix = ""
					if title ~= nil then
						-- If title is given, transform it into valid file name.
						suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
					else
						-- If title is nil, just add 4 random uppercase letters to the suffix.
						for _ = 1, 4 do
							suffix = suffix .. string.char(math.random(65, 90))
						end
					end
					return tostring(os.time()) .. "-" .. suffix
				end,
			})
		end,
	},
}
