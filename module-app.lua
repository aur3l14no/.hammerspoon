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

function toggleApplication(app)
    local appPath = app[1]

    startAppPath = appPath

    local app = findApplication(appPath)

    if app and app:isFrontmost() then
        -- App is focused -> Hide it
        app:hide()
    else
        hs.application.launchOrFocus(appPath)
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
