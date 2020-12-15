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


-- Change the below according to your situation --

super = {'ctrl', 'command', 'option', 'shift'}

-- Switch external monitor to PC
hs.hotkey.bind(
    hyper, "-",
    function()
        os.execute(ddcctl_path .. ' -d 1 -i 15')  -- DP (PC)
end)

-- Move windows to laptop screen and switch external monitor to PC
hs.hotkey.bind(
    super, "-",
    function()
        os.execute(ddcctl_path .. ' -d 1 -i 15')  -- switch external monitor to PC
        moveAllWindowsTo(1, true)  -- move windows to main screen
        os.execute(displayplacer_path .. ' "id:B89A6485-DE30-8A16-E384-E6EF923F03B4 res:1440x900 color_depth:4 scaling:on origin:(0,0) degree:0" "id:7A055398-1B2E-56CA-9775-0D75FCD479CC res:1920x1080 hz:60 color_depth:8 scaling:on origin:(1440,0) degree:0"')
end)

-- Switch external monitor to laptop
hs.hotkey.bind(
    hyper, "=",
    function()
        os.execute(ddcctl_path .. ' -d 1 -i 17')  -- HDMI (Laptop)
end)

-- Move windows to external monitor and switch external monitor to Laptop (HDMI)
hs.hotkey.bind(
    super, "=",
    function()
        os.execute(ddcctl_path .. ' -d 1 -i 17')  -- HDMI (Laptop)
        moveAllWindowsTo(1, true)  -- move windows to main screen
        os.execute(displayplacer_path .. ' "id:7A055398-1B2E-56CA-9775-0D75FCD479CC res:1920x1080 hz:60 color_depth:8 scaling:on origin:(0,0) degree:0" "id:B89A6485-DE30-8A16-E384-E6EF923F03B4 res:1440x900 color_depth:4 scaling:on origin:(-1440,68) degree:0"')
end)
