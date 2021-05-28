require("module-config")
require("module-util")

function toggleApplication(appBundleID)
  local app = hs.application.get(appBundleID)

  if app ~= nil and app:isFrontmost() then
    app:hide()
  else
    hs.application.launchOrFocusByBundleID(appBundleID)
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
