#!/usr/bin/env bash
# Sets up a macOS machine to use this nvim config: CLI deps this config
# assumes are on PATH (git, ripgrep, node, a C compiler, the tree-sitter CLI),
# a Nerd Font for the icons nvim-tree/diffview render, all lazy.nvim plugins
# installed, and the ~/notes dir.
#
# Requires Homebrew (https://brew.sh) to already be installed.
# Run this from a clone of the repo at ~/.config/nvim (see README.md).
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "init-osx.sh is for macOS only." >&2
  exit 1
fi

NERD_FONT_CASK="font-jetbrains-mono-nerd-font"

echo "==> Checking Homebrew"
if ! command -v brew &>/dev/null; then
  echo "Homebrew is required: https://brew.sh" >&2
  exit 1
fi

echo "==> Checking Xcode Command Line Tools (C compiler for treesitter parsers)"
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools (follow the GUI prompt, then re-run this script)..."
  xcode-select --install
  exit 0
fi

echo "==> Installing CLI dependencies via Homebrew"
brew install neovim git ripgrep node tree-sitter-cli

echo "==> Installing Nerd Font ($NERD_FONT_CASK) for nvim-tree/diffview icons"
brew install --cask "$NERD_FONT_CASK"

echo "==> Installing/syncing plugins with lazy.nvim"
nvim --headless "+Lazy! sync" +qa

echo "==> Creating ~/notes"
mkdir -p "$HOME/notes"

cat <<'EOF'

==> Done.

Not covered here, since they're per-project toolchains rather than editor
dependencies:
  - Rust: `rustup component add rust-analyzer` (used by lsp.lua/rust.lua)
  - Lean: install elan (https://leanprover-community.github.io/get_started.html)
EOF
