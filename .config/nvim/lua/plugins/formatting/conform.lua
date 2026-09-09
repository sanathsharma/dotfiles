local M = {}

local stylelint_files = {
	".stylelintrc",
	".stylelintrc.mjs",
	".stylelintrc.cjs",
	".stylelintrc.js",
	".stylelintrc.json",
	".stylelintrc.yaml",
	".stylelintrc.yml",
	"stylelint.config.mjs",
	"stylelint.config.cjs",
	"stylelint.config.js",
}

local function concat_formatters(formatters)
	local names = {}
	for _, formatter in ipairs(formatters) do
		table.insert(names, formatter.name)
	end
	return table.concat(names, ", ")
end

local function get_range_from_usrcmd_args(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end

	return range
end

---@param path_one string
---@param current_buffer string
local function get_distance_to(path_one, current_buffer)
	if path_one == nil then
		return math.huge
	end

	local common_prefix = ""
	local current_remaining = ""
	local other_remaining = ""

	for i = 1, math.min(#current_buffer, #path_one) do
		if current_buffer:sub(i, i) == path_one:sub(i, i) then
			common_prefix = common_prefix .. current_buffer:sub(i, i)
		else
			current_remaining = current_buffer:sub(i)
			other_remaining = path_one:sub(i)
			break
		end
	end

	-- Calculate the distance by counting directory separators
	local distance = 0

	for _ in current_remaining:gmatch("/") do
		distance = distance + 1
	end

	for _ in other_remaining:gmatch("/") do
		distance = distance + 1
	end

	return distance
end

-- Inspired by https://github.com/asilvadesigns/config/blob/87adf2bdc22c4ca89d1b06b013949d817b405e77/nvim/lua/plugins/conform.lua#L63
---@param _formatters table<string, string[]>
---@return string[] | nil
local function get_closest_formatter(_formatters)
	---@type string
	local current_buffer_path = vim.api.nvim_buf_get_name(0)

	local available_formatters = require("conform").list_formatters(0)
	local keys_to_include = {}
	for _, value in ipairs(available_formatters) do
		table.insert(keys_to_include, value.name)
	end
	---@type table<string, string[]>
	_formatters = require("core.utils").filterTable(_formatters, keys_to_include)

	---@type table<string, number>
	local distance = {}

	for formatter_name, formatter_configs in pairs(_formatters) do
		local formatter_config_path = nil

		for _, v in ipairs(formatter_configs) do
			local stop_dir = require("lspconfig.util").root_pattern(".git")(v)
			formatter_config_path = vim.fs.find(v, {
				path = current_buffer_path,
				stop = stop_dir,
				upward = true,
				type = "file",
			})
			if not formatter_config_path or #formatter_config_path == 0 then
				if stop_dir then
					local file_path = vim.fs.joinpath(stop_dir, v)
					if vim.fn.filereadable(file_path) == 1 then
						formatter_config_path = { file_path }
					end
				end
			end

			if formatter_config_path[1] ~= nil then
				break
			end
		end

		if formatter_config_path[1] ~= nil then
			distance[formatter_name] = get_distance_to(formatter_config_path[1], current_buffer_path)
		end
	end

	---@type string|nil
	local shortest_path_key = nil
	---@type number
	local shortest_path_val = math.huge
	---@type table<string, boolean>
	local tied_formatters = {}

	for formatter_name, formatter_distance in pairs(distance) do
		if formatter_distance < shortest_path_val then
			shortest_path_key = formatter_name
			shortest_path_val = formatter_distance
			tied_formatters = { [formatter_name] = true }
		elseif formatter_distance == shortest_path_val then
			tied_formatters[formatter_name] = true
		end
	end

	if shortest_path_key == nil then
		return nil
	end

	---@type string[]
	local result = {}
	for formatter_name in pairs(tied_formatters) do
		table.insert(result, formatter_name)
	end

	return result
end

local function setup_usercmds()
	vim.api.nvim_create_user_command("Fmt", function(args)
		local range = get_range_from_usrcmd_args(args)

		-- Inspired by https://github.com/asilvadesigns/config/blob/87adf2bdc22c4ca89d1b06b013949d817b405e77/nvim/lua/plugins/conform.lua#L145
		local formatters_with_config = get_closest_formatter({
			stylelint = stylelint_files,
			["biome-check"] = { "biome.json" },
			prettierd = { ".prettierrc", "prettier.config.js", ".prettierrc.json" },
		})

		local fidget = require("fidget")

		local conform = require("conform")
		if not formatters_with_config then
			conform.format({ async = true, lsp_format = "fallback", range = range })

			local bufnr = vim.api.nvim_get_current_buf()
			local formatters = conform.list_formatters_to_run(bufnr)
			local text = #formatters > 0 and concat_formatters(formatters) or "lsp"
			fidget.notify("Formatting with " .. text, vim.log.levels.INFO)
		else
			conform.format({
				async = true,
				formatters = formatters_with_config,
				lsp_fromat = "never",
				range = range,
			})

			local running_formatters_str = vim.iter(formatters_with_config):join(", ")
			fidget.notify("Formatting with " .. running_formatters_str, vim.log.levels.INFO)
		end
	end, { range = true })

	vim.api.nvim_create_user_command("Fmtb", function()
		require("conform").format({
			async = true,
			formatters = { "biome-check" },
		})
		require("fidget").notify("Running biome formatting", vim.log.levels.INFO)
	end, {})

	vim.api.nvim_create_user_command("Fmtp", function()
		require("conform").format({
			async = true,
			formatters = { "prettierd" },
		})
		require("fidget").notify("Running prettierd formatting", vim.log.levels.INFO)
	end, {})

	vim.api.nvim_create_user_command("FmtWith", function(args)
		local conform = require("conform")
		local formatters = vim
			.iter(conform.list_formatters(0))
			:map(function(formatter)
				return formatter.name
			end)
			:totable()

		require("fzf-lua").fzf_exec(formatters, {
			prompt = "Select formatter to run:",
			actions = {
				["default"] = function(selected)
					conform.format({
						async = true,
						formatters = selected,
						range = get_range_from_usrcmd_args(args),
					})

					local formatters_str = vim.iter(selected):join(", ")
					require("fidget").notify("Running " .. formatters_str .. " formatting", vim.log.levels.INFO)
				end,
			},
		})
	end, { range = true })

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "css", "scss", "less", "sass", "stylus" },
		callback = function()
			vim.api.nvim_create_user_command("FmtCss", function(args)
				require("conform").format({
					async = true,
					formatters = { "stylelint", "biome-check" },
					range = get_range_from_usrcmd_args(args),
				})
				require("fidget").notify("Running stylelint, biome-check formatting", vim.log.levels.INFO)
			end, { range = true })
		end,
	})

	vim.api.nvim_create_user_command("Fmtlsp", function()
		require("conform").format({ async = true })
		require("fidget").notify("Running lsp formatting", vim.log.levels.INFO)
	end, {})

	vim.api.nvim_create_user_command("BiomeCheck", function()
		local fidget = require("fidget")
		local current_file = vim.api.nvim_buf_get_name(0)

		if current_file == "" then
			fidget.notify("No file associated with current buffer", vim.log.levels.WARN)
			return
		end

		if vim.fn.filereadable(current_file) == 0 then
			fidget.notify("Current buffer file does not exist on disk", vim.log.levels.WARN)
			return
		end

		-- Save buffer first
		vim.cmd("write")

		local biome_bin = vim.fs.find("node_modules/.bin/biome", {
			path = vim.fn.fnamemodify(current_file, ":h"),
			upward = true,
			stop = vim.loop.os_homedir(),
			type = "file",
		})[1] or "biome"

		local cmd = string.format("%s check --write %s", vim.fn.shellescape(biome_bin), vim.fn.shellescape(current_file))
		local output = vim.fn.system(cmd)
		local exit_code = vim.v.shell_error

		if exit_code == 0 then
			fidget.notify("Biome check and fix completed ✓", vim.log.levels.INFO)
			-- Reload the buffer to show changes
			vim.cmd("edit!")
		else
			fidget.notify("Biome check failed ✗", vim.log.levels.ERROR)
			print(output)
		end
	end, {
		desc = "Run biome check with --write on current buffer",
	})

	vim.api.nvim_create_user_command("BiomeOrganizeImports", function()
		require("conform").format({
			async = true,
			formatters = { "biome-organize-imports" },
		})
		require("fidget").notify("Organizing imports w/ biome", vim.log.levels.INFO)
	end, {})
end

function M.setup()
	require("conform").setup({
		formatters_by_ft = {
			c = { "clang_format" },
			cpp = { "clang_format" },
			css = { "stylelint", "biome-check", "prettierd", stop_after_first = true },
			html = { "biome-check", "prettierd", stop_after_first = true },
			javascript = { "biome-check", "prettierd", stop_after_first = true },
			javascriptreact = { "biome-check", "prettierd", stop_after_first = true },
			json = { "biome-check", "prettierd", stop_after_first = true },
			jsonc = { "biome-check", "prettierd", stop_after_first = true },
			lua = { "stylua" },
			rust = { "rustfmt" },
			sh = { "shfmt" },
			sql = { "sql_formatter" },
			svelte = { "biome-check", "prettierd" },
			typescript = { "biome-check", "prettierd", stop_after_first = true },
			typescriptreact = { "biome-check", "prettierd", stop_after_first = true },
			yaml = { "yamlfmt" },
			toml = { "taplo" },
		},
		formatters = {
			sql_formatter = {
				meta = {
					url = "https://github.com/sql-formatter-org/sql-formatter",
					description = "A whitespace formatter for different query languages.",
				},
				command = "sql-formatter",
				args = {
					"--config",
					vim.fn.expand("~") .. "/.config/sql-formatter/sql_formatter.json",
				},
			},
		},
	})

	setup_usercmds()
end

return M
