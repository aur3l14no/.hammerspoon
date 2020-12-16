hs.loadSpoon("SpoonInstall")

Install=spoon.SpoonInstall

require('module-caffeinate')
require('module-app')
require('module-window')
require('module-config')

-- Inits
hs.window.animationDuration = 0

-- Auto reload
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- Init speaker
-- speaker = hs.speech.new()

hs.console.clearConsole()

hs.notify.new({title="Hammer", informativeText="Sir, I'm online!"}):send()
