-- Extended functionality for minimalist neovim config

local M = {}

-- Case transformation utilities
local case = {}

-- Helper function to split string into words
local function split_words(str)
	if not str or str == "" then
		return {}
	end

	local words = {}

	-- First, split on explicit separators (spaces, hyphens, underscores, dots)
	local parts = {}
	for part in str:gmatch("[^%s%-%_%.]+") do
		if part and part ~= "" then
			table.insert(parts, part)
		end
	end

	-- Process each part for camelCase/PascalCase boundaries
	for _, part in ipairs(parts) do
		-- Insert spaces before uppercase letters for camelCase/PascalCase
		local spaced = part:gsub("(%l)(%u)", "%1 %2"):gsub("(%u)(%u%l)", "%1 %2")

		-- Split the spaced version and add to words
		for word in spaced:gmatch("[^%s]+") do
			if word and word ~= "" then
				table.insert(words, word:lower())
			end
		end
	end

	return words
end

-- Convert to camelCase
function case.camel_case(str)
	local words = split_words(str)
	if #words == 0 then
		return str
	end

	local result = words[1]:lower()
	for i = 2, #words do
		local word = words[i]:lower()
		result = result .. word:sub(1, 1):upper() .. word:sub(2)
	end
	return result
end

-- Convert to PascalCase
function case.pascal_case(str)
	local words = split_words(str)
	local result = ""
	for _, word in ipairs(words) do
		word = word:lower()
		result = result .. word:sub(1, 1):upper() .. word:sub(2)
	end
	return result
end

-- Convert to kebab-case
function case.kebab_case(str)
	local words = split_words(str)
	return table.concat(words, "-"):lower()
end

-- Convert to snake_case
function case.snake_case(str)
	local words = split_words(str)
	return table.concat(words, "_"):lower()
end

-- Convert to CONSTANT_CASE
function case.constant_case(str)
	local words = split_words(str)
	return table.concat(words, "_"):upper()
end

-- Convert to Start Case
function case.start_case(str)
	local words = split_words(str)
	local result = {}
	for _, word in ipairs(words) do
		word = word:lower()
		table.insert(result, word:sub(1, 1):upper() .. word:sub(2))
	end
	return table.concat(result, " ")
end

-- Convert to lowercase
function case.lower_case(str)
	local words = split_words(str)
	return table.concat(words, " "):lower()
end

-- Convert to UPPERCASE
function case.upper_case(str)
	local words = split_words(str)
	return table.concat(words, " "):upper()
end

-- Get text and determine if it's from selection or cursor
local function get_text_and_context(opts)
	-- Check if command was called with a range (indicating visual selection)
	local was_visual_command = opts and opts.range and opts.range > 0

	if was_visual_command then
		-- Command was called from visual mode, use the selection marks
		local start_pos = vim.fn.getpos("'<")
		local end_pos = vim.fn.getpos("'>")
		local lines = vim.api.nvim_buf_get_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3], {})
		local selection_text = table.concat(lines, " ")
		return selection_text, true -- true indicates selection
	else
		-- Command was called in normal mode, use cursor word
		local word = vim.fn.expand("<cWORD>")
		return word, false -- false indicates cursor word
	end
end

-- Replace text based on context (selection vs cursor word)
local function replace_text(new_text, was_selection, old_text)
	if was_selection then
		-- Replace the selection area
		vim.cmd("normal! gvc" .. new_text .. "")
	else
		-- Replace current WORD (not just word)
		if old_text == "" then
			vim.notify("No word under cursor", vim.log.levels.WARN)
			return
		end
		vim.cmd("normal! ciW" .. new_text)
	end

	vim.notify(string.format("Changed '%s' to '%s'", old_text, new_text), vim.log.levels.INFO)
end

-- Case transformation commands
local case_commands = {
	camel = {
		func = case.camel_case,
		desc = "Convert to camelCase",
	},
	pascal = {
		func = case.pascal_case,
		desc = "Convert to PascalCase",
	},
	kebab = {
		func = case.kebab_case,
		desc = "Convert to kebab-case",
	},
	snake = {
		func = case.snake_case,
		desc = "Convert to snake_case",
	},
	constant = {
		func = case.constant_case,
		desc = "Convert to CONSTANT_CASE",
	},
	start = {
		func = case.start_case,
		desc = "Convert to Start Case",
	},
	lower = {
		func = case.lower_case,
		desc = "Convert to lower case",
	},
	upper = {
		func = case.upper_case,
		desc = "Convert to UPPER CASE",
	},
}

-- Register case transformation commands
function M.register_case_commands()
	-- Create the main Case command with completion
	vim.api.nvim_create_user_command("Case", function(opts)
		local subcommand = opts.args
		if subcommand == "" then
			vim.notify(
				"Available case transformations: " .. table.concat(vim.tbl_keys(case_commands), ", "),
				vim.log.levels.INFO
			)
			return
		end

		local cmd = case_commands[subcommand]
		if not cmd then
			vim.notify("Unknown case transformation: " .. subcommand, vim.log.levels.ERROR)
			return
		end

		local text, was_selection = get_text_and_context(opts)
		if text == "" then
			vim.notify("No word under cursor or selection", vim.log.levels.WARN)
			return
		end

		local transformed = cmd.func(text)
		replace_text(transformed, was_selection, text)
	end, {
		nargs = 1,
		complete = function()
			return vim.tbl_keys(case_commands)
		end,
		desc = "Transform case of word under cursor or selection",
		range = true,
	})

	-- Create individual subcommands for easier access
	for name, cmd in pairs(case_commands) do
		vim.api.nvim_create_user_command("Case" .. name:sub(1, 1):upper() .. name:sub(2), function(opts)
			local text, was_selection = get_text_and_context(opts)
			if text == "" then
				vim.notify("No word under cursor or selection", vim.log.levels.WARN)
				return
			end

			local transformed = cmd.func(text)
			replace_text(transformed, was_selection, text)
		end, {
			desc = cmd.desc .. " of word under cursor or selection",
			range = true,
		})
	end
end

-- LSP rename functionality
local function lsp_rename_word(old_word, new_word)
	-- Check if LSP is available and supports rename
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	local rename_client = nil

	for _, client in pairs(clients) do
		if client.supports_method("textDocument/rename") then
			rename_client = client
			break
		end
	end

	if not rename_client then
		vim.notify("No LSP client supports rename functionality", vim.log.levels.WARN)
		return false
	end

	-- Perform LSP rename
	local params = vim.lsp.util.make_position_params()
	params.newName = new_word

	vim.lsp.buf_request(0, "textDocument/rename", params, function(err, result, ctx, config)
		if err then
			vim.notify("LSP rename failed: " .. err.message, vim.log.levels.ERROR)
			return
		end

		if result and result.changes then
			-- Apply the workspace edit
			vim.lsp.util.apply_workspace_edit(result, rename_client.offset_encoding or "utf-16")
			vim.notify(
				string.format("Renamed '%s' to '%s' across %d files", old_word, new_word, vim.tbl_count(result.changes)),
				vim.log.levels.INFO
			)
		else
			vim.notify("No references found to rename", vim.log.levels.WARN)
		end
	end)

	return true
end

-- Register LSP rename case transformation commands
function M.register_lsp_case_commands()
	-- Define programming-focused case commands for LSP rename (no upper, lower, start, kebab)
	local lsp_case_commands = {
		camel = case_commands.camel,
		pascal = case_commands.pascal,
		snake = case_commands.snake,
		constant = case_commands.constant,
	}

	-- Create the main CaseRename command
	vim.api.nvim_create_user_command("CaseRename", function(opts)
		local subcommand = opts.args
		if subcommand == "" then
			vim.notify(
				"Available LSP case transformations: " .. table.concat(vim.tbl_keys(lsp_case_commands), ", "),
				vim.log.levels.INFO
			)
			return
		end

		local cmd = lsp_case_commands[subcommand]
		if not cmd then
			vim.notify("Unknown case transformation: " .. subcommand, vim.log.levels.ERROR)
			return
		end

		-- For LSP rename, only use cursor word (not visual selection)
		local word = vim.fn.expand("<cword>") -- Use <cword> for variable names
		if word == "" then
			vim.notify("No word under cursor", vim.log.levels.WARN)
			return
		end

		local transformed = cmd.func(word)
		if transformed == word then
			vim.notify("No transformation needed", vim.log.levels.INFO)
			return
		end

		-- Use LSP rename
		if not lsp_rename_word(word, transformed) then
			-- Fallback to regular case transformation
			vim.notify("Falling back to local transformation", vim.log.levels.INFO)
			vim.cmd("normal! ciw" .. transformed)
			vim.notify(string.format("Changed '%s' to '%s' (local only)", word, transformed), vim.log.levels.INFO)
		end
	end, {
		nargs = 1,
		complete = function()
			return vim.tbl_keys(lsp_case_commands)
		end,
		desc = "Transform case of word under cursor using LSP rename",
	})

	-- Create individual LSP rename subcommands
	for name, cmd in pairs(lsp_case_commands) do
		vim.api.nvim_create_user_command("CaseRename" .. name:sub(1, 1):upper() .. name:sub(2), function()
			local word = vim.fn.expand("<cword>")
			if word == "" then
				vim.notify("No word under cursor", vim.log.levels.WARN)
				return
			end

			local transformed = cmd.func(word)
			if transformed == word then
				vim.notify("No transformation needed", vim.log.levels.INFO)
				return
			end

			-- Use LSP rename
			if not lsp_rename_word(word, transformed) then
				-- Fallback to regular case transformation
				vim.notify("Falling back to local transformation", vim.log.levels.INFO)
				vim.cmd("normal! ciw" .. transformed)
				vim.notify(string.format("Changed '%s' to '%s' (local only)", word, transformed), vim.log.levels.INFO)
			end
		end, {
			desc = cmd.desc .. " of word under cursor using LSP rename",
		})
	end
end

M.case = case
return M
