#!/bin/bash
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# Shows AeroSpace workspaces that have windows, e.g. "0 1 [2] 4".
# Refreshed every 5s and on workspace change (exec-on-workspace-change in aerospace.toml).
aerospace=/run/current-system/sw/bin/aerospace

focused=$($aerospace list-workspaces --focused)
$aerospace list-windows --all --format '%{workspace}|%{app-name}' |
  sort -t'|' -k1,1 -k2,2 -u |
  awk -F'|' -v focused="$focused" -v bin="$aerospace" '
    { apps[$1] = ($1 in apps) ? apps[$1] ", " $2 : $2 }
    END {
      apps[focused] = (focused in apps) ? apps[focused] : "empty"
      n = 0
      for (ws in apps) list[++n] = ws
      # insertion sort, workspace names are short
      for (i = 2; i <= n; i++) for (j = i; j > 1 && list[j-1] > list[j]; j--) { t = list[j]; list[j] = list[j-1]; list[j-1] = t }
      title = ""
      for (i = 1; i <= n; i++) title = title (i > 1 ? " " : "") (list[i] == focused ? "[" list[i] "]" : list[i])
      print title
      print "---"
      for (i = 1; i <= n; i++)
        print list[i] ": " apps[list[i]] " | bash=" bin " param1=workspace param2=" list[i] " terminal=false refresh=true"
    }'
