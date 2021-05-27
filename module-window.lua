require('module-config')
require('module-util')
require('module-layout')


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
