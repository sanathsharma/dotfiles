#!/bin/sh
set -e

# Spawns one kitty tab per update group, running them all in parallel.
# Requires kitty remote control (allow_remote_control + listen_on set in
# kitty.conf) and must be run from inside a kitty window.
# Tabs are left open after their commands finish or fail (each block ends
# by exec-ing into $SHELL) so results/errors can be inspected per tab.
# (kitty's remote-control `launch` action has no --hold option, unlike
# plain `kitty --hold`, so this is done manually.)
# --env PATH=$PATH forwards this script's PATH (bun/brew/go dirs added in
# fish config) into each new tab explicitly: `kitty @ launch` otherwise
# spawns from kitty's own process environment, and --copy-env is unreliable
# here since it copies from whichever window is "active" at dispatch time,
# which becomes a just-created tab partway through this loop.

if [ -z "$KITTY_LISTEN_ON" ]; then
	echo "Error: update.sh must be run from inside a kitty window with remote control enabled (KITTY_LISTEN_ON is not set)."
	exit 1
fi

echo "Spawning update tabs..."

BUN_CMD=$(cat <<'EOF'
if command -v bun >/dev/null 2>&1; then
	echo "==> bun update -g"
	bun update -g
else
	echo "bun not installed, skipping"
fi
echo ""
echo "[bun update finished]"
exec $SHELL
EOF
)

BREW_CMD=$(cat <<'EOF'
if command -v brew >/dev/null 2>&1; then
	echo "==> brew update"
	brew update
	echo "==> brew upgrade"
	brew upgrade
else
	echo "brew not installed, skipping"
fi
echo ""
echo "[brew update finished]"
exec $SHELL
EOF
)

BOB_CMD=$(cat <<'EOF'
if command -v bob >/dev/null 2>&1; then
	echo "==> bob update stable"
	bob update stable
else
	echo "bob not installed, skipping"
fi
echo ""
echo "[bob update finished]"
exec $SHELL
EOF
)

RUST_CMD=$(cat <<'EOF'
if command -v rustup >/dev/null 2>&1; then
	echo "==> rustup update stable"
	rustup update stable
else
	echo "rustup not installed, skipping toolchain update"
fi
if command -v cargo >/dev/null 2>&1; then
	if ! cargo install-update --help >/dev/null 2>&1; then
		echo "==> installing cargo-update"
		cargo install cargo-update
	fi
	echo "==> cargo install-update -a"
	cargo install-update -a
else
	echo "cargo not installed, skipping global package update"
fi
echo ""
echo "[rust update finished]"
exec $SHELL
EOF
)

GO_CMD=$(cat <<'EOF'
if command -v go >/dev/null 2>&1; then
	GOBIN_DIR=$(go env GOPATH)/bin
	if [ -d "$GOBIN_DIR" ]; then
		for bin in "$GOBIN_DIR"/*; do
			[ -f "$bin" ] || continue
			MOD_PATH=$(go version -m "$bin" 2>/dev/null | awk '$1 == "path" { print $2 }')
			if [ -n "$MOD_PATH" ]; then
				echo "==> go install $MOD_PATH@latest"
				go install "$MOD_PATH@latest"
			fi
		done
	else
		echo "no global go binaries found, skipping"
	fi
else
	echo "go not installed, skipping"
fi
echo ""
echo "[go update finished]"
exec $SHELL
EOF
)

APT_CMD=$(cat <<'EOF'
if command -v apt >/dev/null 2>&1; then
	echo "==> sudo apt update"
	sudo apt update
	echo "==> sudo apt upgrade"
	sudo apt upgrade -y
else
	echo "apt not installed, skipping"
fi
echo ""
echo "[apt update finished]"
exec $SHELL
EOF
)

kitty @ launch --type=tab --tab-title "Bun" --env "PATH=$PATH" sh -c "$BUN_CMD"
kitty @ launch --type=tab --tab-title "Homebrew" --env "PATH=$PATH" sh -c "$BREW_CMD"
kitty @ launch --type=tab --tab-title "Neovim (bob)" --env "PATH=$PATH" sh -c "$BOB_CMD"
kitty @ launch --type=tab --tab-title "Rust" --env "PATH=$PATH" sh -c "$RUST_CMD"
kitty @ launch --type=tab --tab-title "Go" --env "PATH=$PATH" sh -c "$GO_CMD"
kitty @ launch --type=tab --tab-title "APT" --env "PATH=$PATH" sh -c "$APT_CMD"

echo "Spawned 6 update tabs: Bun, Homebrew, Neovim (bob), Rust, Go, APT"
