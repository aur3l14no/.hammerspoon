--- Software KVM.
--- Emitting signal to switch external monitor's input source when specified USB device is connected.

local debug = false

local triggerProductID = 21033

local M1DDC_PATH = '/Users/y/bin/m1ddc'

local function handler(event)
  if debug then
    Print(event)
  end
  if event['eventType'] == 'added' and event['productID'] == triggerProductID then
    if hs.execute(M1DDC_PATH .. ' get input') == '15\n' then
      hs.execute(M1DDC_PATH .. ' set input 17')
    end
  elseif event['eventType'] == 'removed' and event['productID'] == triggerProductID then
    if hs.execute(M1DDC_PATH .. ' get input') == '17\n' then
      hs.execute(M1DDC_PATH .. ' set input 15')
    end
  end
end

kvmUSBWatcher = hs.usb.watcher.new(handler)
kvmUSBWatcher:start()
