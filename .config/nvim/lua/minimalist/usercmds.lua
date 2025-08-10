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
	local formatters = require("minimalist.utils").get_closest_formatter({
		biome = { "biome.json" },
		prettierd = { ".prettierrc", "prettier.config.js" },
	})

	if not formatters then
		require("conform").format({ async = true, lsp_format = "fallback", range = range })
	else
		require("conform").format({ async = true, lsp_format = "never", formatters, range = range })
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
