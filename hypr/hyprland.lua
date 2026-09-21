-- Hyprland configuration (Lua format)
-- Converted from hyprland.conf

------------------
---- PROGRAMS ----
------------------
local mod = "SUPER"
local terminal = "kitty -o font_size=12"
local menu = "wofi --show drun"
local status = "waybar"
local ss = 'grim -g "$(slurp)" ~/pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png'
local scp = 'grim -g "$(slurp)" - | wl-copy'
local browser = "firefox"
local lock = "waylock"

------------------
---- MONITORS ----
------------------
-- monitor = ,preferred,auto,1.2
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1.25",
})

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("GTK_THEME", "Adwaita-dark")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
    hl.exec_cmd(status)
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in     = 0,
        gaps_out    = 0,
        border_size = 0,
        layout      = "dwindle",
    },

    decoration = {
        rounding = 0,
    },

    input = {
        kb_layout    = "us",
        follow_mouse = 1,

        touchpad = {
            natural_scroll = true,
        },
    },

    animations = {
        enabled = false,
    },
})

---------------------
---- KEYBINDINGS ----
---------------------

-- Applications & Utilities
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + SPACE",  hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + M",      hl.dsp.exec_cmd(status))
hl.bind(mod .. " + O",      hl.dsp.exec_cmd(lock))
hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("killall " .. status))

-- Vim-style window focus movement
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Workspaces
-- MOD1 (ALT) + 1-9: switch workspace
-- SUPER + SHIFT + 1-9: move window to workspace
for i = 1, 9 do
    hl.bind("ALT + " .. i,             hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Screenshots
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd(ss))
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd(scp))

-- Fullscreen
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())

-- Logout
hl.bind(mod .. " + X", hl.dsp.exec_cmd("wlogout"))

-- Window Resizing (repeating = true)
hl.bind("CTRL + left",  hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind("CTRL + right", hl.dsp.window.resize({ x = 10,  y = 0, relative = true }), { repeating = true })
hl.bind("CTRL + up",    hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
hl.bind("CTRL + down",  hl.dsp.window.resize({ x = 0, y =  10, relative = true }), { repeating = true })

-- Audio & Brightness controls
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +2%"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -2%"), { repeating = true })

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 2%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 2%-"), { repeating = true })

hl.bind("XF86AudioMute",    hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"))
