require("module-config")
require("module-util")

function toggleApplication(appBundleID)
  local app = hs.application.get(appBundleID)

  if app == nil then
    hs.application.launchOrFocusByBundleID(appBundleID)
    return
  else
    -- local bundleID = app:bundleID()
    if app:isFrontmost() then
      app:hide()
    else
      -- app:mainWindow():focus()
      for _, win in ipairs(app:allWindows()) do
        win:focus()
      end
    end
  end
end

for _, item in ipairs(key2App) do
  local key, appBundleID = table.unpack(item)
  hs.hotkey.bind(
    hyper,
    key,
    function()
      toggleApplication(appBundleID)
    end
  )
end
