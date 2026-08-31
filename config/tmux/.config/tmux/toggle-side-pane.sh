#!/bin/sh
# Toggle a side pane (Claude Code) on the right, independently per window.
# 1st press: creates the pane running `claude` in the current window.
# Next presses: hide it into a background window / bring it back.
# The hidden window's id is kept in the *window* option @side_window of the
# window it belongs to, so every tab has its own Claude pane. Hidden windows
# are parked at index HIDDEN_BASE + <tab index> to keep the low indices free.
WIDTH=30%
HIDDEN_BASE=10

cur_pane=${TMUX_PANE:-$(tmux display -p '#{pane_id}')}
cur_win=$(tmux display -p -t "$cur_pane" '#{window_id}')
cur_idx=$(tmux display -p -t "$cur_pane" '#{window_index}')

hidden=$(tmux show-option -wqv -t "$cur_win" @side_window)
if [ -n "$hidden" ] && tmux list-windows -F '#{window_id}' | grep -qx "$hidden"; then
    tmux join-pane -h -l "$WIDTH" -s "$hidden" -t "$cur_pane"
    tmux set-option -wu -t "$cur_win" @side_window
else
    side=$(tmux list-panes -t "$cur_win" -F '#{pane_id} #{@side}' | awk '$2 == "1" { print $1; exit }')
    if [ -n "$side" ]; then
        target=$((HIDDEN_BASE + cur_idx))
        if tmux list-windows -F '#{window_index}' | grep -qx "$target"; then
            win=$(tmux break-pane -d -P -F '#{window_id}' -s "$side" -n "claude-hidden-$cur_idx")
        else
            win=$(tmux break-pane -d -P -F '#{window_id}' -s "$side" -t ":$target" -n "claude-hidden-$cur_idx")
        fi
        tmux set-option -w -t "$cur_win" @side_window "$win"
    else
        tmux split-window -h -l "$WIDTH" -t "$cur_pane" -c "$(tmux display -p -t "$cur_pane" '#{pane_current_path}')" claude
        tmux set-option -p -t "$cur_win" @side 1
    fi
fi
