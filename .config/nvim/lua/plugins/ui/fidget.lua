local M = {}

function M.setup()
	require("fidget").setup({
		progress = {
			-- Required: the Claude completion source (plugins.completion.sources.claude)
			-- shows its "generating" spinner through fidget.progress.handle.create, and
			-- <M-c> runs in insert mode. With suppress_on_insert = true fidget hides all
			-- progress while you are in insert mode, so the spinner would never show.
			-- false is also the default; it is explicit so a later change can't break it.
			suppress_on_insert = false,
		},
	})
end

return M
