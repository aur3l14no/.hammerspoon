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

    if win:isFullscreen() then
        win:setFullScreen(false)
        hs.timer.doAfter(1, function()
            win:moveToScreen(toScreen)
        end)
        hs.timer.doAfter(1, function()
            win:setFullScreen(true)
        end)
    else
        win:moveToScreen(toScreen)
    end

    if showNotify then
        hs.alert.show("Move " .. win:application():name() .. " to " .. toScreen:name())
    end
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


