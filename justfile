link:
	ln -s $(pwd)/.config/nvim ~/.config/nvim
	ln -s $(pwd)/.config/tmux ~/.config/tmux
	ln -s $(pwd)/.config/fish ~/.config/fish
	ln -s $(pwd)/.config/starship ~/.config/starship
	ln -s $(pwd)/.config/worktree ~/.config/worktree
	ln -s $(pwd)/scripts ~/scripts
	ln -s $(pwd)/.config/yazi ~/.config/yazi
	ln -s $(pwd)/.claude/CLAUDE.md ~/.claude/CLAUDE.md
	ln -s $(pwd)/.claude/commands ~/.claude/commands
	ln -s $(pwd)/.config/git ~/.config/git
	ln -s $(pwd)/.config/delta ~/.config/delta
	ln -s $(pwd)/.config/bat ~/.config/bat
	ln -s $(pwd)/.config/kitty ~/.config/kitty
	ln -s $(pwd)/.config/ghostty ~/.config/ghostty
	ln -s $(pwd)/.config/dtop ~/.config/dtop
	ln -s $(pwd)/.config/btop ~/.config/btop
	ln -s $(pwd)/.config/ccstatusline ~/.config/ccstatusline
	ln -s $(pwd)/.config/nushell ~/.config/nushell
	ln -s $(pwd)/.config/sql-formatter ~/.config/sql-formatter
	ln -s $(pwd)/.config/scribble ~/.config/scribble
	ln -s $(pwd)/.config/lazygit ~/.config/lazygit

clean:
	rm -rf ~/.config/nvim
	rm -rf ~/.config/tmux
	rm -rf ~/.config/fish
	rm -rf ~/.config/starship
	rm -rf ~/.config/worktree
	rm -rf ~/scripts
	rm -rf ~/.config/yazi
	rm ~/.claude/CLAUDE.md
	rm -rf ~/.claude/commands
	rm -rf ~/.config/git
	rm -rf ~/.config/delta
	rm -rf ~/.config/bat
	rm -rf ~/.config/kitty
	rm -rf ~/.config/ghostty
	rm -rf ~/.config/dtop
	rm -rf ~/.config/btop
	rm -rf ~/.config/ccstatusline
	rm -rf ~/.config/nushell
	rm -rf ~/.config/sql-formatter
	rm -rf ~/.config/scribble
	rm -rf ~/.config/lazygit
