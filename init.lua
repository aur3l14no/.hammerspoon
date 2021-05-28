hs.loadSpoon("SpoonInstall")

Install=spoon.SpoonInstall

require('module-caffeinate')
require('module-app')
require('module-config')
require('module-window')
require('module-screen')
require('module-menubar')

-- Inits
hs.window.animationDuration = 0
hs.alert.defaultStyle['atScreenEdge'] = 2

-- Auto reload
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- Init speaker
-- speaker = hs.speech.new()

hs.console.clearConsole()

myNotify("Sir, I'm online!")
