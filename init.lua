hs.loadSpoon("WindowGrid")
hs.loadSpoon("KSheet")
hs.loadSpoon("SpoonInstall")

Install=spoon.SpoonInstall

require('module-caffeinate')
require('module-app')
require('module-window')
require('module-config')

-- Inits
hs.window.animationDuration = 0


-- Init speaker
speaker = hs.speech.new()

-- Install:andUse(
--     "WindowGrid",
--     {
--         config = {gridGeometries = {{"6x4"}}},
--         hotkeys = {show_grid = {hyper, "/"}},
--         start = true
-- })



local ksheetIsShow = false
local ksheetAppPath = ""

hs.hotkey.bind(
    hyper, "\\",
    function ()
        local currentAppPath = hs.window.focusedWindow():application():path()

        -- Toggle ksheet window if cache path equal current app path.
        if ksheetAppPath == currentAppPath then
            if ksheetIsShow then
                spoon.KSheet:hide()
                ksheetIsShow = false
            else
                spoon.KSheet:show()
                ksheetIsShow = true
            end
            -- Show app's keystroke if cache path not equal current app path.
        else
            spoon.KSheet:show()
            ksheetIsShow = true

            ksheetAppPath = currentAppPath
        end
end)

hs.console.clearConsole()

hs.notify.new({title="Hammer", informativeText="Aur3l14no, I'm online!"}):send()

-- speaker:speak("Can you hear me")
