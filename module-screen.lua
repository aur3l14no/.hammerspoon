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

-- screen.uuid -> pos
lastMousePosOnScreen = {}

-- Switch to last focused window
-- Since we can't use window watcher for now (hs.window.filter is very slow),
-- we always focus the top window
function focusScreen(rel)
  local focusedWin = hs.window.focusedWindow()
  local screen = focusedWin:screen()
  local curPos = hs.mouse.getRelativePosition()
  -- remember mouse position if focused screen == mouse screen
  if screen == hs.mouse.getCurrentScreen() then
    lastMousePosOnScreen[screen:getUUID()] = curPos
  end
  if rel == 1 then
    screen = screen:next()
  elseif rel == -1 then
    screen = screen:previous()
  end
  for _, win in ipairs(hs.window.orderedWindows()) do
    if win:screen() == screen then
      win:focus()
      break
    end
  end
  local prevPos = lastMousePosOnScreen[screen:getUUID()]
  if prevPos then
    hs.mouse.setRelativePosition(prevPos, screen)
  else
    local center = screen:fullFrame().center
    local frame = screen:fullFrame()
    local rel = {}
    rel["x"] = center["x"] - frame["x"]
    rel["y"] = center["y"] - frame["y"]
    hs.mouse.setRelativePosition(rel, screen)
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
