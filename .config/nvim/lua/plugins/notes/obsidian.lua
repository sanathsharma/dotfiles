local M = {}

local function setup_autocmds()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "markdown" },
		callback = function()
			if
				string.sub(vim.fn.expand("%:p"), 1, string.len(vim.fn.expand("~") .. "/vaults/"))
				== vim.fn.expand("~") .. "/vaults/"
			then
				vim.opt.conceallevel = 2
			end
		end,
	})
end

function M.setup()
	require("obsidian").setup({
		workspaces = {
			{
				name = "personal",
				path = "~/vaults/personal",
			},
			{
				name = "work",
				path = "~/vaults/work",
			},
			{
				name = "work",
				path = "~/vaults/scribble",
			},
		},
		ui = {
			checkboxes = {
				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" }, -- to-do
				["x"] = { char = "", hl_group = "ObsidianDone" }, -- done
				["/"] = { char = "󱎖", hl_group = "ObsidianInProgress" }, -- incomplete
				["-"] = { char = "", hl_group = "ObsidianCanceled" }, -- canceled
				[">"] = { char = "󰒊", hl_group = "ObsidianForwarded" }, -- forwarded
				["<"] = { char = "", hl_group = "ObsidianScheduling" }, -- scheduling
				["?"] = { char = "", hl_group = "ObsidianQuestion" }, -- question
				["!"] = { char = "", hl_group = "ObsidianImportant" }, -- important
				["*"] = { char = "", hl_group = "ObsidianStar" }, -- star
				['"'] = { char = "", hl_group = "ObsidianQuote" }, -- quote
				["l"] = { char = "", hl_group = "ObsidianLocation" }, -- location
				["B"] = { char = "", hl_group = "ObsidianBookmark" }, -- bookmark
				["i"] = { char = "", hl_group = "ObsidianInformation" }, -- information
				["S"] = { char = "", hl_group = "ObsidianSavings" }, -- savings
				["I"] = { char = "", hl_group = "ObsidianIdea" }, -- idea
				["p"] = { char = "", hl_group = "ObsidianPros" }, -- pros
				["c"] = { char = "", hl_group = "ObsidianCons" }, -- cons
				["f"] = { char = "󰈸", hl_group = "ObsidianFire" }, -- fire
				["k"] = { char = "", hl_group = "ObsidianKey" }, -- key
				["u"] = { char = "󰔵", hl_group = "ObsidianUp" }, -- up
				["d"] = { char = "󰔳", hl_group = "ObsidianDown" }, -- down
				["b"] = { char = "󰥪", hl_group = "ObsidianBacklog" }, -- backlog
				["."] = { char = "󱄵", hl_group = "ObsidianCarriedOver" }, -- carried over
				["t"] = { char = "", hl_group = "ObsidianBrainstorm" }, -- brainstorm
				["D"] = { char = "󰭹", hl_group = "ObsidianDiscussion" }, -- discusstion needed
			},
			hl_groups = {
				-- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
				ObsidianTodo = { bold = true, fg = "#f78c6c" },
				ObsidianDone = { bold = true, fg = "#89ddff" },
				ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
				ObsidianTilde = { bold = true, fg = "#ff5370" },
				ObsidianImportant = { bold = true, fg = "#d73128" },
				ObsidianInProgress = { bold = true, fg = "#ffcb6b" },
				ObsidianBacklog = { bold = true, fg = "#82aaff" },
				ObsidianCarriedOver = { bold = true, fg = "#c792ea" },
				ObsidianBrainstorm = { bold = true, fg = "#e0af68" },
				ObsidianDiscussion = { bold = true, fg = "#ff9e64" },
				ObsidianBullet = { bold = true, fg = "#89ddff" },
				ObsidianRefText = { underline = true, fg = "#c792ea" },
				ObsidianExtLinkIcon = { fg = "#c792ea" },
				ObsidianTag = { italic = true, fg = "#89ddff" },
				ObsidianBlockID = { italic = true, fg = "#89ddff" },
				ObsidianHighlightText = { bg = "#75662e" },
				ObsidianCanceled = { bold = true, fg = "#676e95" },
				ObsidianForwarded = { bold = true, fg = "#82aaff" },
				ObsidianScheduling = { bold = true, fg = "#ffcb6b" },
				ObsidianQuestion = { bold = true, fg = "#c3e88d" },
				ObsidianStar = { bold = true, fg = "#ffc777" },
				ObsidianQuote = { bold = true, fg = "#f07178" },
				ObsidianLocation = { bold = true, fg = "#ff9cac" },
				ObsidianBookmark = { bold = true, fg = "#bb9af7" },
				ObsidianInformation = { bold = true, fg = "#7dcfff" },
				ObsidianSavings = { bold = true, fg = "#9ece6a" },
				ObsidianIdea = { bold = true, fg = "#e0af68" },
				ObsidianPros = { bold = true, fg = "#73daca" },
				ObsidianCons = { bold = true, fg = "#f7768e" },
				ObsidianFire = { bold = true, fg = "#ff757f" },
				ObsidianKey = { bold = true, fg = "#ffc777" },
				ObsidianUp = { bold = true, fg = "#9ece6a" },
				ObsidianDown = { bold = true, fg = "#f7768e" },
			},
		},
	})

	setup_autocmds()
end

return M
