-- every screen at 125% zoom; the monitor picks 3440x1440 at 165 Hz by itself
hl.monitor({ output = "", scale = 1.25 })

-- lost when NixOS starts Hyprland; without it apps opened here show wrong times or crash
hl.env("TZDIR", "/etc/zoneinfo")

hl.on("hyprland.start", function()
    -- tell background apps about this session early, so autostart apps and password prompts work
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE XDG_SESSION_ID"
        .. " && systemctl --user start xdg-autostart-if-no-desktop-manager.target")
    hl.exec_cmd("wlsunset -t 2700 -l 51 -L 10")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("swaybg -m fill -i ~/.config/hypr/wallpaper.png")
    hl.exec_cmd("wl-paste --watch cliphist store")
end)

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 6,
        border_size = 2,
        col = { inactive_border = "rgba(00000000)" },
        resize_on_border = true,
        layout = "dwindle",
    },
    decoration = {
        rounding = 4,
        shadow = { enabled = false },
        blur = { enabled = false },
    },
    input = { kb_layout = "eu" },
    xwayland = { force_zero_scaling = true }, -- keeps older apps and games sharp at 125%
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})

hl.animation({ leaf = "global", enabled = true, speed = 1, bezier = "default" })

hl.window_rule({ match = { class = "com.gabm.satty" }, float = true })

-- bar popups open under the bar
hl.window_rule({
    match = { class = "io.github.kaii_lb.Overskride|org.pulseaudio.pavucontrol|ghostty.nmtui" },
    float = true,
    size = { 700, 580 },
    move = "monitor_w-708 38",
})
hl.window_rule({ match = { class = "org.gnome.Calendar" }, float = true, move = "(monitor_w-window_w)/2 38" })

-- no fade-out for the screenshot area picker, or it shows up in the screenshot
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
run("Print", "~/.config/hypr/screenshot")
run("SUPER + Print", "~/.config/hypr/screenshot screen")
run("SHIFT + Print", "hyprpicker --autocopy --notify")
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.float())
hl.bind("SUPER + M", hl.dsp.window.fullscreen())

for dir, step in pairs({ left = { -80, 0 }, right = { 80, 0 }, up = { 0, -80 }, down = { 0, 80 } }) do
    hl.bind("SUPER + " .. dir, hl.dsp.focus({ direction = dir }))
    hl.bind("SUPER + SHIFT + " .. dir, hl.dsp.window.move({ direction = dir }))
    hl.bind("SUPER + CTRL + " .. dir, hl.dsp.window.resize({ x = step[1], y = step[2], relative = true }), { repeating = true })
end

for i = 1, 9 do
    hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

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
run("XF86MonBrightnessUp", "ddcutil setvcp 10 + 10; pkill -RTMIN+8 waybar")
run("XF86MonBrightnessDown", "ddcutil setvcp 10 - 10; pkill -RTMIN+8 waybar")
run("XF86AudioPlay", "playerctl play-pause")
run("XF86AudioPause", "playerctl play-pause")
run("XF86AudioNext", "playerctl next")
run("XF86AudioPrev", "playerctl previous")
