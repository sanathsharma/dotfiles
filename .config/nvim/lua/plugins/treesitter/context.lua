local M = {}

function M.setup()
	require("treesitter-context").setup({
		multiline_threshold = 5, -- Maximum number of lines to show for a single context
	})

	vim.api.nvim_create_user_command("Cnear", function(details)
		local args = details.fargs
		local count = args[1] or vim.v.count1
		require("treesitter-context").go_to_context(count)
	end, {
		desc = "Jump to context (upwards)",
		nargs = "?",
	})
end

return M
