local M = {}

function M.setup()
	local null_ls = require("null-ls")
	null_ls.setup({
		sources = {
			null_ls.builtins.code_actions.refactoring,
			null_ls.builtins.code_actions.ts_node_action,
		},
	})
end

return M
