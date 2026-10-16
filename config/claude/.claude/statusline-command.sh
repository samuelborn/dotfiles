#!/bin/bash
# Format: 5h% reset     7d% reset     model effort     context size
input=$(cat)

five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_at=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
model=$(echo "$input" | jq -r '.model.display_name // "?"')
effort=$(echo "$input" | jq -r '(.effort | if type == "object" then .level else . end) // empty')
ctx=$(echo "$input" | jq -r '.context_window.current_usage | if . == null then 0 else (.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0) end')

if [ -n "$five" ]; then
  a="$(printf '%.0f' "$five")% $(date -d "@$five_at" +%-H:%M)"
else
  a="5h n/a"
fi
if [ -n "$week" ]; then
  b="$(printf '%.0f' "$week")% $(date -d "@$week_at" '+%a %-H:%M')"
else
  b="7d n/a"
fi
m="$model"
[ -n "$effort" ] && m="$model $effort"
c="$(awk -v n="$ctx" 'BEGIN{ if (n>=1000) printf "%.0fk", n/1000; else printf "%d", n }')"

echo "$a     $b     $m     $c"
