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

presetLayouts = {
  {"Chrome + Shell + Finder", "4", {
     {'com.google.Chrome', nil, nil, presetLayout['left'], nil, nil},
     {'com.googlecode.iterm2', nil, nil, presetLayout['right-top'], nil, nil},
     {'com.apple.finder', nil, nil, presetLayout['right-bottom'], nil, nil},
  }},
  {"PDF + Emacs", "3", {
     {'com.readdle.PDFExpert-Mac', nil, nil, presetLayout['left'], nil, nil},
     {'org.gnu.Emacs', nil, nil, presetLayout['right'], nil, nil},
  }},
  {"Music", "5", {
     {'com.netease.163music', nil, nil, presetLayout['center-large'], nil, nil},
  }},
}

-- Layout switching

savedLayouts = {}

function saveCurrentLayout(dest)
  savedLayouts[dest] = {}
  local wins = hs.window.orderedWindows()
  for i = 1, #wins do
    local win = wins[i]
    local frame = win:frame()
    savedLayouts[dest][i] = {nil, win, nil, nil, frame, nil, options={['absolute_x'] = true, ['absolute_y'] = true}}
  end
  -- printTable(savedLayouts)
end


currentLayout = "1"
function freshApplyLayout(layout)
  -- Hide windows, apply layout
  -- Only launch app when using preset layout (when appBundleID ~= nil)
  -- Requires layout[1] to be appBundleID or layout[2] to be hs.window

  local visibleWins = hs.window.visibleWindows()

  -- Launch or focus (back to front)
  for i = 1, #layout do
    local appBundleID = layout[#layout + 1 - i][1]
    local win = layout[#layout + 1 - i][2]
    if win ~= nil then
      win:focus()
    elseif appBundleID ~= nil then
      hs.application.launchOrFocusByBundleID(appBundleID)
    end
  end

  -- Apply layout
  hs.layout.apply(layout)

  -- Hide all irrelavent windows
  for _, win in ipairs(visibleWins) do
    local tries = 0
    local app = win:application()

    -- Check if the app is in layout apps
    for _, item in ipairs(layout) do
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
      printTable(win)
    end
    ::continue::
  end
end


for _, preset in ipairs(presetLayouts) do
  local name, key, layout = table.unpack(preset)
  hs.hotkey.bind(
    hyper, key,
    function()
      if currentLayout == "1" then
        saveCurrentLayout(currentLayout)
      end
      freshApplyLayout(layout)
      currentLayout = key
      -- myAlert(string.format("Layout: %s", name))
    end
  )
end

for _, key in ipairs({"1", "2"}) do
  savedLayouts[key] = {}
  hs.hotkey.bind(
    hyper, key,
    function()
      freshApplyLayout(savedLayouts[key])
      currentLayout = key
      -- myAlert(string.format("Layout %s restored!", key))
    end
  )
  hs.hotkey.bind(
    super, key,
    function()
      saveCurrentLayout(key)
      -- myAlert(string.format("Layout %s saved!", key))
    end
  )
end
