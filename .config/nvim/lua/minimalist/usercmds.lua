vim.api.nvim_create_user_command("Fmt", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end

	-- Inspired by https://github.com/asilvadesigns/config/blob/87adf2bdc22c4ca89d1b06b013949d817b405e77/nvim/lua/plugins/conform.lua#L145
	local formatter = require("minimalist.utils").get_closest_formatter({
		biome = { "biome.json" },
		prettierd = { ".prettierrc", "prettier.config.js" },
	})

	local fidget = require("fidget")

	if not formatter then
		require("conform").format({ async = true, lsp_format = "fallback", range = range })
		fidget.notify("Running lsp formatting", vim.log.levels.INFO)
	else
		require("conform").format({
			async = true,
			formatters = { formatter },
			lsp_fromat = "never",
			range = range,
		})
		fidget.notify("Running " .. formatter .. " formatting", vim.log.levels.INFO)
	end
end, { range = true })

vim.api.nvim_create_user_command("Fmtb", function()
	require("conform").format({
		async = true,
		formatters = { "biome" },
		lsp_fromat = "never",
	})
end, {})

vim.api.nvim_create_user_command("Fmtp", function()
	require("conform").format({
		async = true,
		formatters = { "prettierd" },
		lsp_fromat = "never",
	})
end, {})

-- Register extended functionality commands
local extended = require("minimalist.extended")
extended.register_case_commands()
extended.register_lsp_case_commands()

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

	local cmd = string.format("biome check --write \"%s\"", current_file)
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

vim.api.nvim_create_user_command("Cnear", function(details)
	local args = details.fargs
	local count = args[1] or vim.v.count1
	require("treesitter-context").go_to_context(count)
end, {
	desc = "Jump to context (upwards)",
	nargs = "?",
})
