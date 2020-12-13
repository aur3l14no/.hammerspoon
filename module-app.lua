require("module-config")
require("module-util")

function findApplication(appPath)
    local apps = hs.application.runningApplications()
    for i = 1, #apps do
        local app = apps[i]
        if app:path() == appPath then
            return app
        end
    end
    return nil
end

-- Handle cursor focus and application's screen manage.
startAppPath = ""
function applicationWatcher(appName, eventType, appObject)
    -- Move cursor to center of application when application activated.
    -- Then don't need move cursor between screens.
    if (eventType == hs.application.watcher.activated) then
        -- Just adjust cursor postion if app open by user keyboard.
        if appObject:path() == startAppPath then
            startAppPath = ""
        end
    end
end

function toggleApplication(app)
    local appPath = app[1]
    local inputMethod = app[2]

    startAppPath = appPath

    local app = findApplication(appPath)
    local setInputMethod = true

    if not app then
        -- Application not running, launch app
        hs.application.launchOrFocus(appPath)
    else
        -- Application running, toggle hide/unhide
        local mainwin = app:mainWindow()
        if mainwin then
            if app:isFrontmost() then
                -- Show mouse circle if has focus on target application.
                app:hide()
                setInputMethod = false
            elseif app:hide() then
                hs.application.launchOrFocus(appPath)
            else
                -- Focus target application if it not at frontmost.
                mainwin:application():activate(true)
                mainwin:application():unhide()
                mainwin:focus()
            end
        else
            -- Start application if application is hide.
            if app:hide() then
                hs.application.launchOrFocus(appPath)
            end
        end
    end

    if setInputMethod then
        if inputMethod == "English" then
            English()
        else
            Chinese()
        end
    end
end

for key, app in pairs(key2App) do
    hs.hotkey.bind(
        hyper,
        key,
        function()
            toggleApplication(app)
        end
    )
end
