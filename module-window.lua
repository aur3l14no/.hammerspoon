require('module-config')
hs.loadSpoon("WindowHalfsAndThirds")
hs.loadSpoon("SpoonInstall")

Install=spoon.SpoonInstall

function resizeToCenter(winScale)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w * (1 - winScale) / 2)
    f.y = max.y + (max.h * (1 - winScale) / 2)
    f.w = max.w * winScale
    f.h = max.h * winScale
    win:setFrame(f)
end

-- Window operations.
hs.hotkey.bind(hyper, 'U', function()
    resizeToCenter(0.6)
end)

hs.hotkey.bind(hyper, 'Y', function()
    resizeToCenter(0.75)
end)

hs.hotkey.bind(
    hyper, "H",
    function()
        hs.window.focusedWindow():moveToUnit(hs.geometry.unitrect(0,0,0.55,1))
end)

hs.hotkey.bind(
    hyper, "L",
    function()
        hs.window.focusedWindow():moveToUnit(hs.geometry.unitrect(0.55,0,0.45,1))
end)


-- Binding key to start plugin.
Install:andUse(
    "WindowHalfsAndThirds",
    {
        config = { use_frame_correctness = true },
        hotkeys = { max_toggle = {hyper, "return"} }
})