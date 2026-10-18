#!/usr/bin/env bash
input=$(cat)
j() { echo "$input" | jq -r "$1 // empty"; }

five=$(j '.rate_limits.five_hour.used_percentage')
five_r=$(j '.rate_limits.five_hour.resets_at')
week=$(j '.rate_limits.seven_day.used_percentage')
week_r=$(j '.rate_limits.seven_day.resets_at')
model=$(j '.model.display_name')
effort=$(j '.effort.level')
tokens=$(j '.context_window.total_input_tokens')

pct() { [ -n "$1" ] && printf '%.0f%%' "$1" || printf -- '--'; }
at() { [ -n "$1" ] && date -d "@$1" "+$2" || printf -- '--'; }

printf '%s %s     %s %s     %s %s     %sk\n' \
  "$(pct "$five")" "$(at "$five_r" %H:%M)" \
  "$(pct "$week")" "$(at "$week_r" '%a %H:%M')" \
  "$model" "$effort" "$(( ${tokens:-0} / 1000 ))"
