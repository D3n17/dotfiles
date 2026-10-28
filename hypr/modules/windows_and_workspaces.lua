--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- convenient Picture-in-Picture
-- for some reason if you can't maximize if pin = true the thing below fixes it
hl.config({
    binds = {
        allow_pin_fullscreen = true,
    },
})
hl.window_rule({
    name = "Picture-in-Picture only float, no transparency",
    match = {
        -- class thing worked only for firefox
        -- class = "^(firefox|TelegramDesktop)$",
        title = "^(Picture-in-Picture|TelegramDesktop)$",
    },
    float = true,
    opaque = true,
    pin = true,

    rounding = 0,
    border_size = 0,
})
