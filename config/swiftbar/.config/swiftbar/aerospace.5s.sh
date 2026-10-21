#!/bin/bash
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# Shows AeroSpace workspaces that have windows, e.g. "1  2  3  7".
# All bold, the focused workspace is red. The menu lists the apps on each workspace.
# Refreshed every 5s and on workspace change (exec-on-workspace-change in aerospace.toml).
aerospace=/run/current-system/sw/bin/aerospace

focused=$($aerospace list-workspaces --focused)
$aerospace list-windows --all --format '%{workspace}|%{app-name}' |
  sort -t'|' -k1,1 -k2,2 |
  awk -F'|' -v focused="$focused" -v bin="$aerospace" '
    # count windows per app, e.g. "Ghostty ×2"
    { count[$1 "|" $2]++; if (!(($1 "|" $2) in seen)) { seen[$1 "|" $2] = 1; order[$1] = order[$1] "|" $2 } }
    END {
      if (!(focused in order)) order[focused] = ""
      n = 0
      for (ws in order) list[++n] = ws
      # insertion sort, workspace names are short
      for (i = 2; i <= n; i++) for (j = i; j > 1 && list[j-1] > list[j]; j--) { t = list[j]; list[j] = list[j-1]; list[j-1] = t }

      title = ""
      for (i = 1; i <= n; i++) title = title (i > 1 ? "  " : "") (list[i] == focused ? "\033[31m" list[i] "\033[0m" : list[i])
      print title " | font=.AppleSystemUIFontBold size=15 ansi=true"
      print "---"
      for (i = 1; i <= n; i++) {
        ws = list[i]
        cmd = " bash=" bin " param1=workspace param2=" ws " terminal=false refresh=true"
        if (i > 1) print "---"
        print "Workspace " ws " |" cmd (ws == focused ? " checked=true" : "")
        m = split(substr(order[ws], 2), apps, "|")
        if (m == 0) print "    empty | color=gray"
        for (k = 1; k <= m; k++) {
          c = count[ws "|" apps[k]]
          print "    " apps[k] (c > 1 ? " ×" c : "") " |" cmd
        }
      }
    }'
