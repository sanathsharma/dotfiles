--- On-demand Claude suggestions for blink.cmp.
---
--- The source never runs while typing. It answers only after `trigger()` was
--- called from a keymap, and it returns nothing for any other request.
--- One `claude -p` call returns N alternatives. Each shows as a menu item,
--- and the documentation window shows its full code.
---
--- Auth uses the Claude Code CLI login. ANTHROPIC_API_KEY is stripped from the
--- subprocess so the CLI bills the subscription, not the API key.

local M = {}

M.provider_id = "claude" -- must match the key under sources.providers

local requested = false -- set by M.trigger(), consumed by the next get_completions call

local defaults = {
	cmd = "claude",
	model = "haiku", -- "sonnet" gives better suggestions but is slower
	num_suggestions = 3,
	lines_before = 80,
	lines_after = 30,
	timeout_ms = 30000,
}

--- Ask Claude for suggestions at the cursor. Call from a blink keymap.
--- Pressing it again while a menu is open requests fresh suggestions.
function M.trigger(cmp)
	local function show()
		requested = true
		cmp.show({ providers = { M.provider_id } })
	end
	if cmp.is_visible() then
		cmp.hide()
		vim.schedule(show)
	else
		show()
	end
	return true
end

--- True when the blink context was opened by M.trigger() (Claude-only menu).
function M.is_claude_context(ctx)
	return ctx ~= nil
		and type(ctx.providers) == "table"
		and #ctx.providers == 1
		and ctx.providers[1] == M.provider_id
end

--- True while the menu on screen is the Claude menu.
function M.is_active()
	local ok, list = pcall(require, "blink.cmp.completion.list")
	return ok and M.is_claude_context(list.context)
end

local source = {}

function M.new(opts)
	local self = setmetatable({}, { __index = source })
	self.opts = vim.tbl_deep_extend("force", defaults, opts or {})
	-- Run from an empty directory so the CLI skips the project's CLAUDE.md,
	-- .mcp.json and hooks on every request.
	self.cwd = vim.fn.stdpath("cache") .. "/claude_cmp"
	vim.fn.mkdir(self.cwd, "p")
	return self
end

function source:enabled()
	return vim.bo.buftype == "" and vim.fn.executable(self.opts.cmd) == 1
end

local function system_prompt(n)
	return table.concat({
		"You are a code completion engine inside a text editor.",
		"The user message is part of a file, with the marker <CURSOR> where the cursor is.",
		("Return exactly %d alternative completions for the text to insert at <CURSOR>."):format(n),
		"Make them meaningfully different: for example a short one, a fuller one, a different approach.",
		"Each must be the exact text to insert: correct indentation, no text already before or after the cursor,",
		"under 20 lines.",
		"Reply with ONLY this JSON object and nothing else, no markdown fences:",
		'{"suggestions": ["<completion 1>", "<completion 2>"]}',
	}, " ")
end

local function build_prompt(bufnr, row0, col, opts)
	local total = vim.api.nvim_buf_line_count(bufnr)
	local first = math.max(0, row0 - opts.lines_before)
	local last = math.min(total, row0 + 1 + opts.lines_after)

	local lines = vim.api.nvim_buf_get_lines(bufnr, first, row0, false)
	local cur = vim.api.nvim_buf_get_lines(bufnr, row0, row0 + 1, false)[1] or ""
	table.insert(lines, cur:sub(1, col) .. "<CURSOR>" .. cur:sub(col + 1))
	vim.list_extend(lines, vim.api.nvim_buf_get_lines(bufnr, row0 + 1, last, false))

	local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
	return ("File: %s (filetype: %s)\n\n%s"):format(name, vim.bo[bufnr].filetype, table.concat(lines, "\n"))
end

local function strip_fences(text)
	text = text:gsub("^%s*```[%w_+-]*\n", "")
	text = text:gsub("\n?```%s*$", "")
	return text
end

--- Turn the model's reply into a list of completion strings.
local function parse_suggestions(raw)
	local text = strip_fences(raw)
	local ok, data = pcall(vim.json.decode, text)
	if not (ok and type(data) == "table") then
		-- tolerate prose around the JSON object
		local s, e = text:find("{"), nil
		for i = #text, 1, -1 do
			if text:sub(i, i) == "}" then
				e = i
				break
			end
		end
		if s and e and e > s then
			ok, data = pcall(vim.json.decode, text:sub(s, e))
		end
	end

	local out, seen = {}, {}
	local list = ok and type(data) == "table" and (data.suggestions or data) or nil
	if type(list) == "table" then
		for _, s in ipairs(list) do
			if type(s) == "string" then
				s = strip_fences(s):gsub("%s+$", "")
				if s ~= "" and not seen[s] then
					seen[s] = true
					table.insert(out, s)
				end
			end
		end
	end
	-- not JSON at all: use the whole reply as one suggestion
	if #out == 0 then
		local s = text:gsub("%s+$", "")
		if s ~= "" then
			out[1] = s
		end
	end
	return out
end

-- Spinner shown while `claude -p` runs. Needs fidget's progress display to stay
-- visible in insert mode (see suppress_on_insert in plugins/ui/fidget.lua).
local function progress_start(msg)
	local ok, progress = pcall(require, "fidget.progress")
	if not ok then
		return nil
	end
	return progress.handle.create({ title = "Claude", message = msg, lsp_client = { name = "claude" } })
end

local function progress_stop(handle)
	if handle then
		handle:finish()
	end
end

local function empty(callback)
	callback({ items = {}, is_incomplete_forward = false, is_incomplete_backward = false })
end

function source:get_completions(ctx, callback)
	-- Answer only requests that came from M.trigger().
	if not requested then
		return empty(callback)
	end
	requested = false

	local bufnr = ctx.bufnr
	local row0, col = ctx.cursor[1] - 1, ctx.cursor[2] -- 0-based row, 0-based byte column
	local keyword = ctx.line:sub(1, col):match("[%w_]*$") or ""
	local filetype = vim.bo[bufnr].filetype
	local n = self.opts.num_suggestions

	local cmd = {
		"env",
		"-u",
		"ANTHROPIC_API_KEY", -- use the subscription login, not the API key
		self.opts.cmd,
		"-p",
		"--model",
		self.opts.model,
		"--output-format",
		"json",
		"--system-prompt",
		system_prompt(n), -- replaces Claude Code's agent prompt
		"--tools",
		"", -- no tools: one model call
		"--strict-mcp-config", -- no MCP servers
		"--no-session-persistence",
	}

	local handle = progress_start(("generating %d suggestions…"):format(n))
	local done = false

	local function on_exit(res)
		vim.schedule(function()
			if done then
				return
			end
			done = true
			progress_stop(handle)

			local ok, data = pcall(vim.json.decode, res.stdout or "")
			if res.code ~= 0 or not ok or type(data) ~= "table" or data.is_error or type(data.result) ~= "string" then
				local msg = (ok and type(data) == "table" and data.result) or res.stderr or "unknown error"
				vim.notify("claude: " .. tostring(msg):sub(1, 200), vim.log.levels.WARN)
				return empty(callback)
			end

			local items = {}
			for i, text in ipairs(parse_suggestions(data.result)) do
				local first_line = text:match("^[^\n]*")
				local _, newlines = text:gsub("\n", "")
				local shown = first_line ~= "" and first_line or ("↵ " .. (text:match("\n%s*([^\n]+)") or ""))
				local label = keyword .. vim.trim(shown)
				if vim.fn.strchars(label) > 50 then
					label = vim.fn.strcharpart(label, 0, 49) .. "…"
				end

				table.insert(items, {
					label = label,
					labelDetails = { description = ("#%d · %d line%s"):format(i, newlines + 1, newlines == 0 and "" or "s") },
					filterText = keyword .. first_line,
					sortText = ("%02d"):format(i), -- keep Claude's order
					kind = require("blink.cmp.types").CompletionItemKind.Text,
					kind_name = "Claude",
					insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
					textEdit = {
						newText = keyword .. text, -- replaces the word under the cursor with word + completion
						range = {
							start = { line = row0, character = col - #keyword },
							["end"] = { line = row0, character = col },
						},
					},
					documentation = { kind = "markdown", value = ("```%s\n%s\n```"):format(filetype, text) },
				})
			end

			if #items == 0 then
				vim.notify("claude: no suggestions", vim.log.levels.INFO)
			end
			-- typing or backspacing filters these items and never re-asks Claude
			callback({ items = items, is_incomplete_forward = false, is_incomplete_backward = false })
		end)
	end

	local ok, proc = pcall(vim.system, cmd, {
		stdin = build_prompt(bufnr, row0, col, self.opts),
		text = true,
		cwd = self.cwd,
		timeout = self.opts.timeout_ms,
	}, on_exit)

	if not ok then
		progress_stop(handle)
		vim.notify("claude: failed to start " .. self.opts.cmd, vim.log.levels.WARN)
		return empty(callback)
	end

	-- blink calls this when the menu closes or the request is superseded
	return function()
		if done then
			return
		end
		done = true
		progress_stop(handle)
		pcall(proc.kill, proc, 15)
	end
end

return M
