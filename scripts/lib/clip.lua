local M = {}

M.clip = function(result)
	if vim.fn.executable("pbcopy") == 1 then
		vim.fn.system("pbcopy", result)
		print("Copied to clipboard (macOS)")
	elseif vim.fn.executable("xclip") == 1 then
		vim.fn.system("xclip -selection clipboard", result)
		print("Copied to clipboard (Linux)")
	elseif vim.fn.executable("wl-copy") == 1 then
		vim.fn.system("wl-copy", result)
		print("Copied to clipboard (Wayland)")
	else
		print("No clipboard utility found. Output:")
		print(result)
	end
end

return M
