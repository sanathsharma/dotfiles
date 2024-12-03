-- Inspiration: https://github.com/benfrain/neovim/blob/main/lua/setup/lualine.lua

local mode_map = {
	["NORMAL"] = "N",
	["O-PENDING"] = "N?",
	["INSERT"] = "I",
	["VISUAL"] = "V",
	["V-BLOCK"] = "VB",
	["V-LINE"] = "VL",
	["V-REPLACE"] = "VR",
	["REPLACE"] = "R",
	["COMMAND"] = "!",
	["SHELL"] = "SH",
	["TERMINAL"] = "T",
	["EX"] = "X",
	["S-BLOCK"] = "SB",
	["S-LINE"] = "SL",
	["SELECT"] = "S",
	["CONFIRM"] = "Y?",
	["MORE"] = "M",
}

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

local function place()
	local colPre = "C:"
	local col = "%c"
	local linePre = " L:"
	local line = "%l/%L"
	return string.format("%s%s%s%s", colPre, col, linePre, line)
end

local function window()
	return vim.api.nvim_win_get_number(0)
end

return {
	"nvim-lualine/lualine.nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- local custom_auto = require("lualine.themes.auto")
		-- custom_auto.normal.c.bg = "#1e1e2e" -- catppuccin color

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { " ", " " },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {},
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(s)
							return mode_map[s] or s
						end,
					},
				},
				lualine_b = {
					{
						"branch",
						fmt = function(str)
							local max_length = vim.o.columns / 3.5
							if string.len(str) > max_length then
								return str:sub(1, max_length) .. "..."
							end
							return str
						end,
						icon = "󰘬",
					},
					{
						"diff",
						colored = true,
						source = diff_source,
						diff_color = {
							color_added = "#a7c080",
							color_modified = "#ffdf1b",
							color_removed = "#ff6666",
						},
					},
					"diagnostics",
				},
				lualine_c = {
					{
						"filename",
						file_status = true,
						path = 1,
						shorting_target = 40,
						symbols = {
							modified = "󰐖", -- Text to show when the file is modified.
							readonly = "", -- Text to show when the file is non-modifiable or readonly.
							unnamed = "[No Name]", -- Text to show for unnamed buffers.
							newfile = "[New]", -- Text to show for new created file before first writting
						},
					},
					{
						"searchcount",
					},
					{
						"selectioncount",
					},
				},
				lualine_x = {
					{
						require("noice").api.status.mode.get,
						cond = require("noice").api.status.mode.has,
					},
					"rest",
					"filetype",
					{
						"fileformat",
						icons_enabled = true,
						symbols = {
							unix = "LF",
							dos = "CRLF",
							mac = "CR",
						},
					},
				},
				lualine_y = { "progress" },
				lualine_z = { { place, padding = { left = 1, right = 1 } } },
			},
			inactive_sections = {
				lualine_a = { { window, color = { fg = "#26ffbb", bg = "#282828" } } },
				lualine_b = {
					{
						"diff",
						source = diff_source,
						color_added = "#a7c080",
						color_modified = "#ffdf1b",
						color_removed = "#ff6666",
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1,
						shorting_target = 40,
						symbols = {
							modified = "󰐖", -- Text to show when the file is modified.
							readonly = "", -- Text to show when the file is non-modifiable or read only.
							unnamed = "[No Name]", -- Text to show for unnamed buffers.
							newfile = "[New]", -- Text to show for new created file before first writing
						},
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { { place, padding = { left = 1, right = 1 } } },
			},
		})
	end,
}
