require('module-config')

appMenubar = hs.menubar.new()

function gatherIcons()
  local icons = {}
  local focusedScreen = hs.window.focusedWindow():screen()
  local gatheredBundleIDs = {}
  for _, win in ipairs(hs.window.filter.default:getWindows()) do
    if win:screen() == focusedScreen then
      local bundleID = win:application():bundleID()
      if not gatheredBundleIDs[bundleID] then
        local image = hs.image.imageFromAppBundle(bundleID)
        gatheredBundleIDs[bundleID] = true
        table.insert(icons, image)
      end
    end
  end
  local canvas = hs.canvas.new{x=0, y=0, w=32*#icons, h=32}

  local elements = {}
  for i, icon in ipairs(icons) do
    table.insert(elements, {
                   type='image',
                   frame = {x = (i-1) * 32, y = 0, h=32, w=32},
                   image=icon:template(false)
    })
  end
  canvas:appendElements(elements)
  -- canvas:show()
  return canvas:imageFromCanvas()
end

function updateMenubarIcon()
  local image = gatherIcons()
  image:size{h=25, w=10000}
  appMenubar:setIcon(image, false)
end


local timerUpdateMenubarIcon = hs.timer.delayed.new(2, updateMenubarIcon):start()
hs.window.filter.default:subscribe(
  hs.window.filter.windowFocused,
  function()
    timerUpdateMenubarIcon:start()
end)

--- Test

-- hs.hotkey.bind(
--   super, 'space',
--   updateMenubarIcon
-- )
