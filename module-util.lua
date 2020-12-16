function Chinese()
    hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end

function English()
    hs.keycodes.currentSourceID("com.apple.keylayout.US")
end


function myprint(x)
    hs.console.printStyledtext(x)
end

function randomDisturb(base)
    local coef = 0.01
    base.w = base.w + (math.random() * 2 - 1) * coef
    base.h = base.h + (math.random() * 2 - 1) * coef
    base.x = base.x + (math.random() * 2 - 1) * coef
    base.y = base.y + (math.random() * 2 - 1) * coef
    if base.x < 0 then base.x = 0 end
    if base.x + base.w > 1 then base.x = 1 - base.w end
    if base.y < 0 then base.y = 0 end
    if base.y + base.h > 1 then base.y = 1 - base.h end
    return base
end
