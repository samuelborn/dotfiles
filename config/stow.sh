#!/usr/bin/env sh
cd "$(dirname "$0")" || exit 1
packages="btop claude ghostty git lazygit nvim tmux zsh"
if [ "$(uname)" = Darwin ]; then
  packages="$packages aerospace ghostty-macos git-work nvim-work ssh-work swiftbar"
else
  packages="$packages fuzzel git-home hypr mako voxtype waybar"
fi
# Without ~/.claude stow would link the whole folder, and Claude's login and history would land in the repo.
mkdir -p ~/.claude
# Same for ~/.ssh: otherwise new keys and known_hosts would land in the repo.
mkdir -p ~/.ssh && chmod 700 ~/.ssh
stow -v -R -t ~ $packages
