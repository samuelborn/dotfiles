#!/usr/bin/env bash
opt=$(printf "Logout\nReboot\nShutdown\nSuspend" | fuzzel --dmenu --lines 4)
case "$opt" in
  Logout) hyprctl dispatch exit;;
  Reboot) systemctl reboot;;
  Shutdown) systemctl poweroff;;
  Suspend) systemctl suspend;;
esac
