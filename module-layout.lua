require("module-config")

presetLayout = {
  ['fullscreen']   = hs.geometry.unitrect(0      , 0    , 1    , 1   ),
  ['left']         = hs.geometry.unitrect(0      , 0    , 0.55 , 1   ),
  ['right']        = hs.geometry.unitrect(0.55   , 0    , 0.45 , 1   ),
  ['center']       = hs.geometry.unitrect(0.25   , 0.15 , 0.5  , 0.7 ),
  ['center-large'] = hs.geometry.unitrect(0.15   , 0.1  , 0.7  , 0.8 ),
  ['left-top']     = hs.geometry.unitrect(0      , 0    , 0.55 , 0.55),
  ['left-bottom']  = hs.geometry.unitrect(0      , 0.45 , 0.55 , 0.55),
  ['right-top']    = hs.geometry.unitrect(0.55   , 0    , 0.45 , 0.55),
  ['right-bottom'] = hs.geometry.unitrect(0.55   , 0.45 , 0.45 , 0.55),
  ['corner']       = hs.geometry.unitrect(0.95   , 0.95 , 0.05 , 0.05),
}

savedLayouts = {
  ['1'] = {'User-1', {}, {}},
  ['2'] = {'User-2', {}, {}},
  ['3'] = {'PDF + Emacs', {
             {'com.readdle.PDFExpert-Mac', nil, nil, presetLayout['left'], nil, nil},
             {'org.gnu.Emacs', nil, nil, presetLayout['right'], nil, nil},
  }},
  ['4'] = {'Chrome + Shell + Finder', {
             {'com.google.Chrome', nil, nil, presetLayout['left'], nil, nil},
             {'com.googlecode.iterm2', nil, nil, presetLayout['right-top'], nil, nil},
             {'com.apple.finder', nil, nil, presetLayout['right-bottom'], nil, nil},
  }},
  ['5'] = {'Music', {
             {'com.netease.163music', nil, nil, presetLayout['center-large'], nil, nil},
  }},
}

-- Layout switching

function saveCurrentLayout(dest)
  local wins = hs.window.orderedWindows()
  for _, win in ipairs(wins) do
    local frame = win:frame()
    table.insert(savedLayouts[dest][2], {nil, win, nil, nil, frame, nil, options={['absolute_x'] = true, ['absolute_y'] = true}})
  end
  local wins = hs.window.invisibleWindows()
  for _, win in ipairs(wins) do
    local frame = win:frame()
    table.insert(savedLayouts[dest][3], {nil, win, nil, nil, frame, nil, options={['absolute_x'] = true, ['absolute_y'] = true}})
  end
  -- printTable(savedLayouts["1"])
end


function freshApplyLayout(name, visibleLayout, invisibleLayout)
  -- Hide windows, apply layout
  -- Only launch app when using preset layout (when appBundleID ~= nil)
  -- Requires layout[1] to be appBundleID or layout[2] to be hs.window

  local visibleWins = hs.window.visibleWindows()

  -- Launch or focus (back to front)
  for i = 1, #visibleLayout do
    local appBundleID = visibleLayout[#visibleLayout + 1 - i][1]
    local win = visibleLayout[#visibleLayout + 1 - i][2]
    if win ~= nil then
      win:focus()
    elseif appBundleID ~= nil then
      hs.application.launchOrFocusByBundleID(appBundleID)
    end
  end

  -- Apply visible layout
  hs.layout.apply(visibleLayout)

  -- Hide all irrelavent windows
  for _, win in ipairs(visibleWins) do
    local tries = 0
    local app = win:application()

    -- Check if the app is in visibleLayout apps
    for _, item in ipairs(visibleLayout) do
      if app:bundleID() == item[1] or win == item[2] then
        goto continue
      end
    end
    -- Try to hide it 3 times
    while not app:hide() and tries < 3 do
      tries = tries + 1
    end
    if not app:isHidden() then
      print('Failed to hide:')
      printTable(app)
    end
    ::continue::
  end

  -- Apply invisible layout
  if invisibleLayout ~= nil then
    hs.layout.apply(invisibleLayout)
  end

  hs.alert.show(string.format("Layout applied: %s", name))
end

emptySlots = {["1"] = true, ["2"] = true}

currentLayout = "1"
for key, layout in pairs(savedLayouts) do
  local name, visibleLayout, invisibleLayout = table.unpack(layout)
  hs.hotkey.bind(
    hyper, key,
    function()
      if emptySlots[currentLayout] then
        saveCurrentLayout(currentLayout)
      end
      freshApplyLayout(name, visibleLayout, invisibleLayout)
      currentLayout = key
    end
  )
  if emptySlots[key] then
    hs.hotkey.bind(
      super, key,
      function()
        saveCurrentLayout(key)
      end
    )
  end
end
