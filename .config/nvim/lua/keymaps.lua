-- Using m4xshen/hardtime.nvim instead
-- require("utils.discipline").cowboy()

local function trim(s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

-- buffer commands
vim.keymap.set("n", "<leader>ba", "<cmd>bufdo bd<CR>", { desc = "Close [a]ll buffers" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Close current buffer" })
vim.keymap.set("n", "<leader>bc", "<cmd>%bd|e#<CR>", { desc = "Close all but current buffer" })

-- move selected lines up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- exit from insert mode
vim.keymap.set("i", "jk", "<ESC>", { noremap = true, silent = true })

-- half page jump
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- search to stay in middle when switching back and forth between them
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- keep old copied content even after pasting it over another selected content
vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Past over selection w/o loosing the clipboard content" })

-- navigating suggestion
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- use plus register for yanking
-- vim.opt.clipboard = "unnamedplus"
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- stay in vim mode after command execution
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true })

-- search and replace, shortcut
vim.keymap.set(
	"n",
	"<leader>sr",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "search and replace" }
)
-- executes search and replace in all the buffers of a quickfix list
vim.keymap.set(
	"n",
	"<leader>sg",
	[[:cdo s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "global search and replace" }
)

-- Re-base current branch
vim.keymap.set(
	"n",
	"<leader>hf",
	"<cmd>!git fetch<CR><cmd>!git rebase<CR>",
	{ desc = "[f]etch origin, and rebase current branch" }
)

vim.keymap.set("n", "<leader>tn", function()
	vim.cmd("set number!")
end, { desc = "Toggle line [n]umbering" })

vim.keymap.set("n", "<leader>tr", function()
	vim.cmd("set relativenumber!")
end, { desc = "Toggle [r]elative line numbering" })

-- Disable arrow keys in normal mode (to improve vim usage)
vim.keymap.set("n", "<left>", "<cmd>echo \"Use h to move!!\"<CR>")
vim.keymap.set("n", "<right>", "<cmd>echo \"Use l to move!!\"<CR>")
-- vim.keymap.set("n", "<up>", "<cmd>echo \"Use k to move!!\"<CR>")
-- vim.keymap.set("n", "<down>", "<cmd>echo \"Use j to move!!\"<CR>")

-- Increment/decrement
vim.keymap.set("n", "<up>", "<C-a>")
vim.keymap.set("n", "<down>", "<C-x>")

-- Diagnostic keymaps (requires 0.11)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>lg", function()
	local tmux_env = vim.fn.system("echo $TMUX")
	if string.len(trim(tmux_env)) > 0 then
		vim.cmd("!tmux new-window -c " .. vim.fn.getcwd() .. " -- lazygit")
		return
	end

	local cmd =
			string.format("zellij run -c -f --height 100%% --width 100%% -x 0 -y 0 --cwd %s -- lazygit", vim.fn.getcwd())
	vim.fn.system(cmd)
end, { desc = "Lazy[g]it in new tmux window / zellij floating window", silent = true })
vim.keymap.set("n", "<leader>ld", function()
	local tmux_env = vim.fn.system("echo $TMUX")
	if string.len(trim(tmux_env)) > 0 then
		vim.cmd("!tmux new-window -c " .. vim.fn.getcwd() .. " -- lazydocker")
		return
	end
	local cmd =
			string.format("zellij run -c -f --height 100%% --width 100%% -x 0 -y 0 --cwd %s -- lazydocker", vim.fn.getcwd())
	vim.fn.system(cmd)
end, { desc = "Lazy[d]ocker in new tmux window / zellij floating window", silent = true })

-- Switching between camelCase and snake_case
vim.api.nvim_set_keymap(
	"n",
	"<leader>tc",
	"<cmd>lua require(\"utils.switch-case\").switch_case()<CR>",
	{ noremap = true, silent = true, desc = "[T]oggle switch [c]ase" }
)

-- Select all below current line
vim.keymap.set("n", "<C-a>", "<S-v>G", { desc = "Select all lines below current line" })
-- Select all
vim.keymap.set("n", "<C-M-A>", "gg<S-v>G", { desc = "Select all" })

-- Re-size window
vim.keymap.set("n", "<C-w><down>", "<cmd>horizontal resize -10<CR>")
vim.keymap.set("n", "<C-w><up>", "<cmd>horizontal resize +10<CR>")
vim.keymap.set("n", "<C-w><right>", "<cmd>vertical resize +10<CR>")
vim.keymap.set("n", "<C-w><left>", "<cmd>vertical resize -10<CR>")

-- Formatting
vim.keymap.set("n", "<leader>af", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "[F]ormat file async" })
vim.keymap.set("v", "<leader>af", function()
	local selection = require("utils.get-visual-selection").get_visual_selection()
	vim.lsp.buf.format({
		range = {
			["start"] = { selection.start.line - 1, selection.start.col - 1 },
			["end"] = { selection["end"].line - 1, selection["end"].col - 1 },
		},
	})
end, { desc = "Format selected [r]ange async", noremap = true })

-- Move between splits using Alt + h/j/k/l
vim.keymap.set("n", "<M-h>", "<C-w>h", { desc = "Move to the left pane", silent = true })
vim.keymap.set("n", "<M-j>", "<C-w>j", { desc = "Move to the bottom pane", silent = true })
vim.keymap.set("n", "<M-k>", "<C-w>k", { desc = "Move to the top pane", silent = true })
vim.keymap.set("n", "<M-l>", "<C-w>l", { desc = "Move to the right pane", silent = true })

-- Zellij new tab layouts
vim.keymap.set("n", "<leader>zlg", function()
	local cmd = "zellij action new-tab --layout ~/.config/zellij/layouts/lazygit.kdl --name lazygit"
	vim.fn.system(cmd)
end, { desc = "Open lazygit in a new zellij tab" })
vim.keymap.set("n", "<leader>zld", function()
	local cmd = "zellij action new-tab --layout ~/.config/zellij/layouts/lazydocker.kdl --name lazydocker"
	vim.fn.system(cmd)
end, { desc = "Open lazydocker in a new zellij tab" })
vim.keymap.set("n", "<leader>zly", function()
	local cmd = "zellij action new-tab --layout ~/.config/zellij/layouts/yazi.kdl --name yazi"
	vim.fn.system(cmd)
end, { desc = "Open yazi in a new zellij tab" })
