require("module-config")

presetLayout = {
  ['fullscreen']   = hs.geometry.unitrect(0      , 0    , 1    , 1   ),
  ['left']         = hs.geometry.unitrect(0      , 0    , 0.55 , 1   ),
  ['right']        = hs.geometry.unitrect(0.55   , 0    , 0.45 , 1   ),
  ['mid-small']    = hs.geometry.unitrect(0.25   , 0.15 , 0.5  , 0.7 ),
  ['mid-large']    = hs.geometry.unitrect(0.15   , 0.1  , 0.7  , 0.8 ),
  ['left-top']     = hs.geometry.unitrect(0      , 0    , 0.55 , 0.5 ),
  ['left-bottom']  = hs.geometry.unitrect(0      , 0.5  , 0.55 , 0.5 ),
  ['right-top']    = hs.geometry.unitrect(0.55   , 0    , 0.45 , 0.5 ),
  ['right-bottom'] = hs.geometry.unitrect(0.55   , 0.5  , 0.45 , 0.5 ),
  ['corner']       = hs.geometry.unitrect(0.95   , 0.95 , 0.05 , 0.05),
}

appLayout = {
  ['/Applications/WeChat.app']                = presetLayout['mid-small'],
  ['/Applications/QQ.app']                    = presetLayout['mid-small'],
  ['/Applications/Telegram.app']              = presetLayout['mid-small'],
  ['/Applications/NeteaseMusic.app']          = presetLayout['left-top'],
  ['/Applications/Emacs.app']                 = presetLayout['right'],
  ['/System/Library/CoreServices/Finder.app'] = presetLayout['left-bottom'],
  ['/Applications/iTerm.app']                 = presetLayout['mid-large'],
  ['/Applications/PDF Expert.app']            = presetLayout['left'],
  ['/Applications/Google Chrome.app']         = presetLayout['fullscreen'],
  ['/Applications/Visual Studio Code.app']    = presetLayout['fullscreen']
  -- ['/Applications/Toggl Track.app']        = presetLayout['mid-small'],
  -- ['/Applications/iThoughtsX.app']         = presetLayout['mid-small'],
  -- ['/Applications/Notion.app']             = presetLayout['mid-small']
}

function applyAppPresetLayout()
  local wins = hs.window.allWindows()
  for i = 1, #wins do
    local dest = appLayout[wins[i]:application():path()]
    if dest then
      wins[i]:moveToUnit(dest)
    end
  end
end

hs.hotkey.bind(
  hyper, "\\",
  function()
    applyAppPresetLayout()
    -- hs.layout.apply(appLayout)
end)

--   -- Official way
-- appLayout = {
--   {'WeChat', nil, nil, presetLayout['mid-small'], nil, nil, nil},
--   {'QQ', nil, nil, presetLayout['mid-small'], nil, nil, nil},
--   {'Telegram', nil, nil, presetLayout['mid-small'], nil, nil, nil},
--   {'NeteaseMusic', nil, nil, presetLayout['left-top'], nil, nil, nil},
--   {'Emacs', nil, nil, presetLayout['right'], nil, nil, nil},
--   {'Finder', nil, nil, presetLayout['left-bottom'], nil, nil, nil},
--   {'iTerm', nil, nil, presetLayout['mid-large'], nil, nil, nil},
--   {'PDF Expert', nil, nil, presetLayout['right'], nil, nil, nil},
--   {'Google Chrome', nil, nil, presetLayout['fullscreen'], nil, nil, nil},
--   {'Visual Studio Code', nil, nil, presetLayout['fullscreen'], nil, nil, nil}
--   -- ['/Applications/Toggl Track.app']        = presetLayout['mid-small'],
--   -- ['/Applications/iThoughtsX.app']         = presetLayout['mid-small'],
--   -- ['/Applications/Notion.app']             = presetLayout['mid-small']
-- }

