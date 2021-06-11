hs.loadSpoon("SpoonInstall")

Install=spoon.SpoonInstall

require('module-caffeinate')
require('module-app')
require('module-config')
require('module-window')
require('module-screen')
-- require('module-menubar')

-- Inits
hs.window.animationDuration = 0
hs.alert.defaultStyle['atScreenEdge'] = 2
hs.window.filter.default:setFilters({
    ['Microsoft Teams'] = {['rejectTitles'] = 'Microsoft Teams Notification'},
    ['default'] = {
      ['visible'] = true,
      -- ['fullscreen'] = false
    }
})
hs.window.filter.invisible = hs.window.filter.copy(hs.window.filter.default)
hs.window.filter.invisible:setFilters({
    ['default'] = {
      ['visible'] = false,
      ['fullscreen'] = false
    }
})


-- Auto reload
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- Init speaker
-- speaker = hs.speech.new()

hs.console.clearConsole()

myNotify("Sir, I'm online!")
