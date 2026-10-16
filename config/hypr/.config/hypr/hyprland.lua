-- API reference: /run/current-system/sw/share/hypr/stubs/hl.meta.lua
-- Check after editing: Hyprland --verify-config -c ~/.config/hypr/hyprland.lua

-- every screen at 125%; the monitor picks 3440x1440 at 165 Hz on its own
hl.monitor({ output = "", scale = 1.25 })

-- NixOS starts Hyprland through a wrapper with extra rights, which drops TZDIR for every
-- app it starts. Without it GLib apps can't look up time zones, and some crash.
hl.env("TZDIR", "/etc/zoneinfo")

-- nmtui looks like nvim; newt and nmtui read their colors from separate variables
hl.env("NEWT_COLORS_FILE", os.getenv("HOME") .. "/.config/newt/colors")
hl.env("NMT_NEWT_COLORS_FILE", os.getenv("HOME") .. "/.config/newt/colors")

hl.on("hyprland.start", function()
    -- User services and autostart apps need these before they start. Hyprland hands them
    -- over itself too, but maybe too late, and the password prompt also needs XDG_SESSION_ID.
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE XDG_SESSION_ID"
        .. " && systemctl --user start xdg-autostart-if-no-desktop-manager.target")
    -- Night light: GNOME's warmth, sunset and sunrise for central Germany. Started before
    -- waybar, which looks for it once. The moon icon in waybar stops and restarts it.
    hl.exec_cmd("wlsunset -t 2700 -l 51 -L 10")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("swaybg -m fill -i ~/.config/hypr/wallpaper.jpg")
    hl.exec_cmd("wl-paste --watch cliphist store")
end)

-- stop the autostart services with the session, so a quick log out and back in starts them fresh
hl.on("hyprland.shutdown", function()
    hl.exec_cmd("systemctl --user stop xdg-autostart-if-no-desktop-manager.target")
end)

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 6,
        border_size = 2,
        col = { inactive_border = "rgba(00000000)" },
        resize_on_border = true,
        layout = "master",
    },
    decoration = {
        rounding = 10,
        shadow = { enabled = false },
        blur = { enabled = false },
    },
    input = { kb_layout = "eu" },
    xwayland = { force_zero_scaling = true }, -- sharp X apps and games at 125%
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})

-- Opening, closing and fading are done almost in the first frame; moves and workspace
-- slides ease out so the eye can follow them. speed 1 = 100ms.
hl.curve("pop", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1 } } })
hl.curve("glide", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.animation({ leaf = "global", enabled = true, speed = 1, bezier = "pop" })
hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "pop", style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1.5, bezier = "glide" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.5, bezier = "glide" })

hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ match = { class = "com.gabm.satty" }, float = true })

-- Bar popups drop down from the bar, lined up with the tiled windows (gap 6 + border 2).
-- move doesn't see the size set here, so the width is written out.
hl.window_rule({
    match = { class = "io.github.kaii_lb.Overskride|org.pulseaudio.pavucontrol|ghostty.nmtui" },
    float = true,
    size = { 700, 580 },
    move = "monitor_w-708 38",
})
hl.window_rule({ match = { class = "org.gnome.Calendar" }, float = true, move = "(monitor_w-window_w)/2 38" })

-- no fade for slurp, or region shots catch its frame fading out
hl.layer_rule({ match = { namespace = "selection" }, no_anim = true })

local function run(keys, cmd, opts)
    hl.bind(keys, hl.dsp.exec_cmd(cmd), opts)
end

run("SUPER + Return", "ghostty")
run("SUPER + W", "brave-origin")
run("SUPER + D", "nautilus")
run("SUPER + Super_L", "pkill -x fuzzel || fuzzel", { release = true })
run("SUPER + V", "cliphist list | fuzzel --dmenu --with-nth 2 --placeholder Clipboard | cliphist decode | wl-copy")
run("SUPER + Delete", "systemctl poweroff")
run("SUPER + F1", "systemctl suspend")

-- While fuzzel is open it gets every click, even beside it, and ignores those. So this closes
-- it, which is also what makes a second click on the power button close the power menu.
-- non_consuming, or no click would reach any window.
hl.bind("mouse:272", function()
    local p = hl.get_cursor_pos()
    for _, l in ipairs(hl.get_layers({ namespace = "launcher" })) do
        if p.x < l.x or p.x >= l.x + l.w or p.y < l.y or p.y >= l.y + l.h then
            hl.exec_cmd("pkill -x fuzzel")
        end
    end
end, { non_consuming = true })

run("Print", "~/.config/hypr/screenshot")
run("SUPER + Print", "~/.config/hypr/screenshot screen")
run("SHIFT + Print", "hyprpicker --autocopy --notify")

hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.float())
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen())

for dir, step in pairs({ left = { -80, 0 }, right = { 80, 0 }, up = { 0, -80 }, down = { 0, 80 } }) do
    hl.bind("SUPER + " .. dir, hl.dsp.focus({ direction = dir }))
    hl.bind("SUPER + SHIFT + " .. dir, hl.dsp.window.move({ direction = dir }))
    hl.bind("SUPER + CTRL + " .. dir, hl.dsp.window.resize({ x = step[1], y = step[2], relative = true }), { repeating = true })
end

for i = 1, 10 do
    hl.bind("SUPER + " .. i % 10, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. i % 10, hl.dsp.window.move({ workspace = i }))
end

-- like GNOME, Page Up/Down also step into empty workspaces; the wheel skips them
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "r-1" }))
hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

run("XF86AudioRaiseVolume", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", { repeating = true })
run("XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", { repeating = true })
run("XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
run("XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
-- the signal makes waybar redraw the sun icon
run("XF86MonBrightnessUp", "ddcutil setvcp 10 + 10; pkill -RTMIN+8 waybar")
run("XF86MonBrightnessDown", "ddcutil setvcp 10 - 10; pkill -RTMIN+8 waybar")
run("XF86AudioPlay", "playerctl play-pause")
run("XF86AudioPause", "playerctl play-pause")
run("XF86AudioNext", "playerctl next")
run("XF86AudioPrev", "playerctl previous")
