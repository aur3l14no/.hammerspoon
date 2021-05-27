require('module-config')
require('module-util')

-- Change the below according to your situation --

ddcctl_path = '~/bin/ddcctl'

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

function focusScreen(rel)
  local focusedWin = hs.window.focusedWindow()
  local screen = focusedWin:screen()
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


-- -- Switch external monitor to PC
-- hs.hotkey.bind(
--     hyper, "-",
--     function()
--         os.execute(ddcctl_path .. ' -d 1 -i 15')  -- DP (PC)
-- end)
--
-- -- Switch external monitor to laptop
-- hs.hotkey.bind(
--     hyper, "=",
--     function()
--         os.execute(ddcctl_path .. ' -d 1 -i 17')  -- HDMI (Laptop)
-- end)
--
-- -- Move windows to laptop screen and switch external monitor to PC
-- hs.hotkey.bind(
--     super, "-",
--     function()
--         os.execute(ddcctl_path .. ' -d 1 -i 15')  -- switch external monitor to PC
--         -- moveAllWindowsTo("Color LCD", true)  -- make sure all windows are here
-- end)
--
-- -- Move windows to external monitor and switch external monitor to Laptop (HDMI)
-- hs.hotkey.bind(
--     super, "=",
--     function()
--         os.execute(ddcctl_path .. ' -d 1 -i 17')  -- HDMI (Laptop)
--         -- moveAllWindowsTo("U2790B", true)  -- make sure all windows are here
-- end)
