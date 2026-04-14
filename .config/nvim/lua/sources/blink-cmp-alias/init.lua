--- Customize the kind icon for a specific source in blink.cmp.
---
--- By default, `kind_icon` renders the LSP kind icon. You can override it
--- per-item by storing a custom `kind_name` field on your completion items
--- and branching in the `text` function.
---
--- Example (in your blink.cmp setup):
--- ```lua
--- completion = {
---   menu = {
---     draw = {
---       components = {
---         kind_icon = {
---           text = function(ctx)
---             -- customize icon for alias source
---             if ctx.item.kind_name == "Alias" then
---               return " "
---             end
---             -- fallback to default behavior
---             return ctx.kind_icon .. ctx.icon_gap
---           end,
---         },
---       },
---     },
---   },
--- },
--- ```

local function setup_cmds(aliases)
	for name, cmd in pairs(aliases) do
		vim.cmd(string.format("cnoreabbrev %s %s", name, cmd))
	end
end

local function is_subcommand(ctx)
	local col = ctx.cursor and ctx.cursor[2] or 1

	return col ~= 1
end

local function create_completion_items(aliases)
	local items = {}

	local kind = require("blink.cmp.types").CompletionItemKind.Property

	for name, cmd in pairs(aliases) do
		table.insert(items, {
			label = name,
			kind = kind, -- fallback
			kind_name = "Alias",
			filterText = name .. " " .. cmd,
			insertText = cmd,
			insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
			documentation = {
				kind = "markdown",
				value = "```\n:" .. cmd .. "\n```",
			},
		})
	end

	return items
end

---@module 'blink.cmp'
---@class blink.cmp.Source
---@field aliases? table<string, string>
local source = {}

function source.new(opts)
	local self = setmetatable({}, { __index = source })
	self.aliases = opts.aliases or {}

	setup_cmds(self.aliases)
	return self
end

function source:get_completions(ctx, callback)
	if is_subcommand(ctx) then
		return callback({ items = {}, is_incomplete_forward = false, is_incomplete_backward = false })
	end

	local items = create_completion_items(self.aliases)

	callback({ items = items, is_incomplete_forward = false, is_incomplete_backward = false })
end

return source
