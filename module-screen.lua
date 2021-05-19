require('module-config')
require('module-util')

-- Change the below according to your situation --

super = {'ctrl', 'command', 'option', 'shift'}

-- Switch external monitor to PC
hs.hotkey.bind(
    hyper, "-",
    function()
        os.execute(ddcctl_path .. ' -d 1 -i 15')  -- DP (PC)
end)

-- Move windows to laptop screen and switch external monitor to PC
hs.hotkey.bind(
    super, "-",
    function()
        os.execute(ddcctl_path .. ' -d 1 -i 15')  -- switch external monitor to PC
        os.execute(displayplacer_path .. ' "id:B89A6485-DE30-8A16-E384-E6EF923F03B4 res:1440x900 color_depth:4 scaling:on origin:(0,0) degree:0" "id:7A055398-1B2E-56CA-9775-0D75FCD479CC res:1920x1080 hz:60 color_depth:8 scaling:on origin:(1440,0) degree:0"')
        -- moveAllWindowsTo("Color LCD", true)  -- make sure all windows are here
end)

-- Switch external monitor to laptop
hs.hotkey.bind(
    hyper, "=",
    function()
        os.execute(ddcctl_path .. ' -d 1 -i 17')  -- HDMI (Laptop)
end)

-- Move windows to external monitor and switch external monitor to Laptop (HDMI)
hs.hotkey.bind(
    super, "=",
    function()
        os.execute(ddcctl_path .. ' -d 1 -i 17')  -- HDMI (Laptop)
        os.execute(displayplacer_path .. ' "id:7A055398-1B2E-56CA-9775-0D75FCD479CC res:1920x1080 hz:60 color_depth:8 scaling:on origin:(0,0) degree:0" "id:B89A6485-DE30-8A16-E384-E6EF923F03B4 res:1440x900 color_depth:4 scaling:on origin:(-1440,68) degree:0"')
        -- moveAllWindowsTo("U2790B", true)  -- make sure all windows are here
end)
