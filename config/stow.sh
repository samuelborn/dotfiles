#!/usr/bin/env sh
cd "$(dirname "$0")" || exit 1
packages="btop claude ghostty git lazygit nvim tmux zsh"
if [ "$(uname)" = Darwin ]; then
  packages="$packages aerospace git-work"
else
  packages="$packages fuzzel git-home hypr mako voxtype waybar"
fi
# Without ~/.claude stow would link the whole folder, and Claude's login and history would land in the repo.
mkdir -p ~/.claude
stow -v -R -t ~ $packages
