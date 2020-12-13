require('module-config')

function resizeToCenter(winScale)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    local heightScale = -winScale*winScale + 2*winScale

    f.x = max.x + (max.w * (1 - winScale) / 2)
    f.y = max.y + (max.h * (1 - heightScale) / 2)
    f.w = max.w * winScale
    f.h = max.h * heightScale
    win:setFrame(f)
end

function moveToRelScreen(win, rel, showNotify)
    local toScreen = win:screen()
    if rel == 1 then
        toScreen = toScreen:next()
    elseif rel == -1 then
        toScreen = toScreen:previous()
    end
    if showNotify then
        hs.alert.show("Move " .. win:application():name() .. " to " .. toScreen:name())
    end
    win:moveToScreen(toScreen)
end


local tempScreen = nil

function moveAllWindowsTo(dest, showNotify)
    local wins = hs.window.allWindows()
    local screens = hs.screen.allScreens()
    assert(dest <= #screens and dest > 0, "Invalid destination screen")

    for i = 1, #wins do
        local win = wins[i]
        win:moveToScreen(screens[dest])
    end
end

-- Window operations.
hs.hotkey.bind(hyper, 'U', function()
    resizeToCenter(0.5)
end)

hs.hotkey.bind(hyper, 'Y', function()
    resizeToCenter(0.7)
end)

hs.hotkey.bind(
    hyper, "H",
    function()
        hs.window.focusedWindow():moveToUnit(hs.geometry.unitrect(0, 0, 0.55, 1))
end)

hs.hotkey.bind(
    hyper, "L",
    function()
        hs.window.focusedWindow():moveToUnit(hs.geometry.unitrect(0.55, 0, 0.45, 1))
end)

hs.hotkey.bind(
    hyper, "/",
    function()
        hs.window.focusedWindow():moveToUnit(hs.geometry.unitrect(0.95, 0.95, 0.05, 0.05))
end)

hs.hotkey.bind(
    hyper, "return",
    function()
        hs.window.focusedWindow():moveToUnit(hs.geometry.unitrect(0, 0, 1, 1))
end)

hs.hotkey.bind(
    hyper, ",",
    function()
        moveToRelScreen(hs.window.focusedWindow(), -1, true)
end)

hs.hotkey.bind(
    hyper, ".",
    function()
        hs.window.focusedWindow():screen():previous()
        moveToRelScreen(hs.window.focusedWindow(), 1, true)
end)


-- Change the below according to your situation
hs.hotkey.bind(
    hyper, "F11",
    function()
        os.execute(ddcctl_path .. ' -d 1 -i 17')  -- Laptop
end)


hs.hotkey.bind(
    hyper, "F12",
    function()
        os.execute(ddcctl_path .. ' -d 1 -i 15')  -- PC
end)


hs.hotkey.bind(
    hyper, "F9",
    function()
        moveAllWindowsTo(2, true)  -- Laptop screen
end)


hs.hotkey.bind(
    hyper, "F10",
    function()
        moveAllWindowsTo(1, true) -- External monitor
end)

