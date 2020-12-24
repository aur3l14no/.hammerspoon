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

appLayout = {
  {'WeChat',        nil, nil, presetLayout['right-top'],    nil, nil, nil},
  {'QQ',            nil, nil, presetLayout['center'],       nil, nil, nil},
  {'Telegram',      nil, nil, presetLayout['center'],       nil, nil, nil},
  {'NeteaseMusic',  nil, nil, presetLayout['left-top'],     nil, nil, nil},
  {'Emacs',         nil, nil, presetLayout['right'],        nil, nil, nil},
  {'Finder',        nil, nil, presetLayout['left-bottom'],  nil, nil, nil},
  {'iTerm2',        nil, nil, presetLayout['right-bottom'], nil, nil, nil},
  {'PDF Expert',    nil, nil, presetLayout['left'],         nil, nil, nil},
  {'Google Chrome', nil, nil, presetLayout['fullscreen'],   nil, nil, nil},
  {'Code',          nil, nil, presetLayout['fullscreen'],   nil, nil, nil}
}

hs.hotkey.bind(
  hyper, "\\",
  function()
    hs.layout.apply(appLayout)
end)
