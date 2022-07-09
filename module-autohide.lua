--- Inactive applications on the main spaces are hide automatically.
--- Space-related APIs seem to be broken, so we only handle the main one.

-- how this works
-- past ----------------> present
-- [t0 app_1 activated]
-- [t1 app_1 deactivated] [t1 app_2 activated]
-- [t2 app_2 deactivated] [t2 app_1 activated] (NOTE: first event is discarded)
-- [t2 app_2 deactivated] [t3 app_1 deactivated] [t3 app_3 activated]

local debug = false

-- these apps are never hidden
local whiteList = {
  "Google Chrome",
  "Hammerspoon", -- useful when developing
}

-- when not empty, only these apps are auto hidden
local blackList = {}

-- IMPORTANT! only consider one main space
local affectedSpace = 1
-- if there are less than `minAppsToKeep` apps, do not auto hide any
local minAppsToKeep = 4
-- do not hide apps that are recently used, even when they are at the bottom of the stack
local minTimeToKeep = 30

local doEvery = 10

local lastActive = {}

local function handler(name, type, app)
  if type == hs.application.watcher.activated or
      type == hs.application.watcher.deactivated then
    -- only consider one `affectedSpace`
    if app:mainWindow() then
      for _, spaceId in ipairs(hs.spaces.windowSpaces(app:mainWindow())) do
        if spaceId ~= affectedSpace then return
        end
      end
    end
    if debug then
      print(name, type)
    end
    lastActive[name] = os.time()
  end
end

--- hide inactive apps
local function doHide()
  if debug then
    Print(lastActive)
  end
  local now = os.time()

  -- sort: the more recent appears first
  local names = {}
  for name, _ in pairs(lastActive) do
    table.insert(names, name)
  end
  table.sort(names, function(a, b)
    return lastActive[a] > lastActive[b]
  end)

  for i, name in pairs(names) do
    -- most recent `minAppsToKeep` apps are always kept
    if i <= minAppsToKeep then goto continue end
    -- whitelisted apps are always kept
    if contains(whiteList, name) then goto continue end
    -- inactive for more than `minTimeToKeep` seconds
    -- AND in blacklist or blacklist is empty
    if now - lastActive[name] >= minTimeToKeep and
        (#blackList == 0 or contains(blackList, name)) then
      local app = hs.application.get(name)
      if app ~= nil then
        local win = app:mainWindow()
        if win ~= nil then
          app:hide()
        end
      end
      -- successful or not, remove it
      lastActive[name] = nil
    end
    ::continue::
  end
  if debug then
    print('-->')
    Print(lastActive)
  end
end

local watcher = hs.application.watcher.new(handler)
watcher:start()

hs.timer.doEvery(doEvery, doHide)
