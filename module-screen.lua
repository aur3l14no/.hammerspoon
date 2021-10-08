require('module-config')
require('module-util')

-- Core functions

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

screenFocusMemory = {}
function focusScreen(rel)
  local focusedWin = hs.window.focusedWindow()
  local screen = focusedWin:screen()
  local pos = hs.mouse.getRelativePosition()
  screenFocusMemory[screen:getUUID()] = {focusedWin, pos}
  if rel == 1 then
    screen = screen:next()
  elseif rel == -1 then
    screen = screen:previous()
  end
  local pack = screenFocusMemory[screen:getUUID()]
  if pack and pack[1]:isVisible() then
    pack[1]:focus()
    hs.mouse.setRelativePosition(pack[2], screen)
  else
    for _, win in ipairs(hs.window.filter.default:getWindows()) do
      if win:screen() == screen then
        win:focus()
        break
      end
    end
  end
end

-- Keybindings

hs.hotkey.bind(
  hyper, "tab",
  function()
    focusScreen(1)
end)

hs.hotkey.bind(
  super, "tab",
  function()
    focusScreen(-1)
end)

hs.hotkey.bind(
  hyper, ",",
  function()
    moveToRelScreen(hs.window.focusedWindow(), -1, true)
end)

hs.hotkey.bind(
  hyper, ".",
  function()
    moveToRelScreen(hs.window.focusedWindow(), 1, true)
end)
