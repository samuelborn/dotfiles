#!/usr/bin/env bash
opt=$(printf "Logout\nReboot\nShutdown\nSuspend\nUEFI" | fuzzel --dmenu --lines 5 --anchor bottom-left --hide-prompt)
case "$opt" in
  Logout) hyprctl dispatch exit;;
  Reboot) systemctl reboot;;
  Shutdown) systemctl poweroff;;
  Suspend) systemctl suspend;;
  UEFI) systemctl reboot --firmware;;
esac
