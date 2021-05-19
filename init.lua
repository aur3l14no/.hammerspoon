hs.loadSpoon("SpoonInstall")

Install=spoon.SpoonInstall

require('module-caffeinate')
require('module-app')
require('module-config')
require('module-window')
require('module-screen')

-- Inits
hs.window.animationDuration = 0

-- Auto reload
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- Init speaker
-- speaker = hs.speech.new()

hs.console.clearConsole()

myAlert("Sir, I'm online!")
