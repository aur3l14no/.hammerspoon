require('module-config')
require('module-util')
require('module-layout')

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

function moveAllWindowsTo(screenName, showNotify)
    local wins = hs.window.allWindows()
    local screen = hs.screen.findByName(screenName)

    if screen then
        for i = 1, #wins do
            local win = wins[i]
            win:moveToScreen(screen)
        end
    end
end

-- Window operations.

local lastMovedWin = nil
local lastLayout = nil
local moveWindowState = {
    ['left'] = {'', '-top', '-bottom'},
    ['right'] = {'', '-top', '-bottom'},
    ['center'] = {'', '-large'}
}
local moveWindowCounter = 1

-- by pressing hyper + x multiple times, different layout will be applied
function moveWindow(win, layoutStr)
    if win == lastMovedWin and layoutStr == lastLayout and
            string.match('left|right|center', layoutStr) then
        moveWindowCounter = moveWindowCounter % #moveWindowState[layoutStr] + 1
        win:moveToUnit(presetLayout[layoutStr .. moveWindowState[layoutStr][moveWindowCounter]])
    else
        lastMovedWin = win
        lastLayout = layoutStr
        moveWindowCounter = 1
        win:moveToUnit(presetLayout[layoutStr])
    end
end


hs.hotkey.bind(
    hyper, 'U',
    function()
        moveWindow(hs.window.focusedWindow(), 'center')
end)

hs.hotkey.bind(
    hyper, "H",
    function()
        moveWindow(hs.window.focusedWindow(), 'left')
end)

hs.hotkey.bind(
    hyper, "L",
    function()
        moveWindow(hs.window.focusedWindow(), 'right')
end)

hs.hotkey.bind(
    hyper, "/",
    function()
        moveWindow(hs.window.focusedWindow(), 'corner')
end)

hs.hotkey.bind(
    hyper, "return",
    function()
        moveWindow(hs.window.focusedWindow(), 'fullscreen')
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
        os.execute(displayplacer_path .. ' "id:B89A6485-DE30-8A16-E384-E6EF923F03B4 res:1440x900 color_depth:4 scaling:on origin:(0,0) degree:0" "id:7A055398-1B2E-56CA-9775-0D75FCD479CC res:1920x1080 hz:60 color_depth:8 scaling:on origin:(1440,0) degree:0"')
        -- moveAllWindowsTo("Color LCD", true)  -- make sure all windows are here
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
        os.execute(displayplacer_path .. ' "id:7A055398-1B2E-56CA-9775-0D75FCD479CC res:1920x1080 hz:60 color_depth:8 scaling:on origin:(0,0) degree:0" "id:B89A6485-DE30-8A16-E384-E6EF923F03B4 res:1440x900 color_depth:4 scaling:on origin:(-1440,68) degree:0"')
        -- moveAllWindowsTo("U2790B", true)  -- make sure all windows are here
end)
