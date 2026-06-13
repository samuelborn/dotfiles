#!/usr/bin/env sh
cd "$(dirname "$0")" || exit 1
stow -v -R -t "$HOME" */

