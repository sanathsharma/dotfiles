local M = {}

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

local function setup_usercmds()
	vim.api.nvim_create_user_command("Fmt", function(args)
		local range = get_range_from_usrcmd_args(args)

		local fidget = require("fidget")

		local conform = require("conform")
		conform.format({ async = true, lsp_format = "fallback", range = range })

		local bufnr = vim.api.nvim_get_current_buf()
		local formatters = conform.list_formatters_to_run(bufnr)
		local text = #formatters > 0 and concat_formatters(formatters) or "lsp"
		fidget.notify("Formatting with " .. text, vim.log.levels.INFO)
	end, { range = true })

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

local util = require("conform.util")

local function has(bufnr, pkg)
	return vim.fs.root(bufnr, "node_modules/" .. pkg) ~= nil
end

local function js_formatters(bufnr)
	-- Vite+ bundles Oxlint + Oxfmt
	if has(bufnr, "vite-plus") then
		return { "vp_lint", "vp_fmt" }
	end

	-- Biome handles lint fixes and formatting in one pass
	if has(bufnr, "@biomejs/biome") then
		return { "biome-check" }
	end

	local list = {}

	-- linter fixes first
	if has(bufnr, "oxlint") then
		table.insert(list, "oxlint")
	end

	-- then one formatter
	if has(bufnr, "oxfmt") then
		table.insert(list, "oxfmt")
	elseif has(bufnr, "prettier") then
		table.insert(list, "prettierd")
	end

	return list
end

local function css_formatters(bufnr)
	local list = {}

	if has(bufnr, "stylelint") then
		table.insert(list, "stylelint")
	end

	if has(bufnr, "@biomejs/biome") then
		table.insert(list, "biome-check")
	end

	if has(bufnr, "prettier") then
		table.insert(list, "prettierd")
	end

	if has(bufnr, "oxlint") then
		table.insert(list, "oxlint")
	end

	if has(bufnr, "oxfmt") then
		table.insert(list, "oxfmt")
	end

	return list
end

function M.setup()
	require("conform").setup({
		formatters_by_ft = {
			c = { "clang_format" },
			cpp = { "clang_format" },
			css = css_formatters,
			html = js_formatters,
			javascript = js_formatters,
			javascriptreact = js_formatters,
			json = js_formatters,
			jsonc = js_formatters,
			lua = { "stylua" },
			rust = { "rustfmt" },
			sh = { "shfmt" },
			sql = { "sql_formatter" },
			svelte = js_formatters,
			typescript = js_formatters,
			typescriptreact = js_formatters,
			yaml = { "yamlfmt" },
			toml = { "taplo" },
		},
		formatters = {
			["biome-check"] = {
				command = util.from_node_modules("@biomejs/biome"),
				cwd = require("conform.util").root_file({ "biome.json" }),
				require_cwd = true, -- skip if no root file was found
			},
			prettierd = {
				cwd = require("conform.util").root_file({ ".prettierrc", "prettier.config.js", ".prettierrc.json" }),
				require_cwd = true, -- skip if no root file was found
			},
			vp_fmt = {
				command = util.from_node_modules("vp"),
				args = { "fmt", "--stdin-filepath", "$FILENAME" },
				stdin = true,
				cwd = util.root_file({ "vite.config.ts", "vite.config.mts", "vite.config.js", "vite.config.mjs" }),
			},
			vp_lint = {
				command = util.from_node_modules("vp"),
				args = { "lint", "--fix", "$FILENAME" },
				stdin = false,
				exit_codes = { 0, 1 }, -- don't fail the format when unfixable lint errors remain
				cwd = util.root_file({ "vite.config.ts", "vite.config.mts", "vite.config.js", "vite.config.mjs" }),
			},
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
