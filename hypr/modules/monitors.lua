------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
--    transform = 1, --horizontal thing
})


-- hl.monitor({
--     output   = "eDP-1",
--     mode     = "1920x1080@60.16400",
--     position = "0x0",
--     scale    = "1.5",
-- })

hl.config({ xwayland = { force_zero_scaling = true } })

