-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function () 
	hl.exec_cmd("waybar")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprsunset")
end)

hl.on("config.reloaded", function ()
   	hl.exec_cmd("killall    waybar; sleep 0.2 && export LANG=ru_RU.UTF-8 && export LC_TIME=ru_RU.UTF-8 && waybar &")
	hl.exec_cmd("killall hyprpaper; sleep 0.2 && hyprpaper")
    hl.exec_cmd("killall hypridle; sleep 0.2 && hypridle")
    hl.exec_cmd("killall hyprsunset; sleep 0.5 && hyprsunset &")
end)

